import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';

class GpsService {
  static GpsService get I => GetIt.I<GpsService>();

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  final StreamController<Position> _positionController = StreamController<Position>.broadcast();
  final StreamController<LocationServiceStatus> _serviceStatusController = StreamController<LocationServiceStatus>.broadcast();

  Position? get currentPosition => _currentPosition;
  Stream<Position> get positionStream => _positionController.stream;
  Stream<LocationServiceStatus> get serviceStatusStream => _serviceStatusController.stream;

  bool get isWebPlatform => kIsWeb;
  bool get isLocationSupported => !kIsWeb || (kIsWeb && _isSecureContext());

  bool _isSecureContext() {
    // On web, location API only works on secure contexts (HTTPS or localhost)
    if (kIsWeb) {
      try {
        final url = Uri.base;
        return url.scheme == 'https' || url.host == 'localhost' || url.host == '127.0.0.1';
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _serviceStatusController.add(LocationServiceStatus.disabled);
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _serviceStatusController.add(LocationServiceStatus.permissionDenied);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _serviceStatusController.add(LocationServiceStatus.permissionDeniedForever);
      return false;
    }

    _serviceStatusController.add(LocationServiceStatus.available);
    return true;
  }

  Future<Position?> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeout,
  }) async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );

      _currentPosition = position;
      _positionController.add(position);
      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> startLocationTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
    Duration? intervalDuration,
  }) async {
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      return;
    }

    await stopLocationTracking();

    late LocationSettings locationSettings;

    if (kIsWeb) {
      // Web platform settings
      locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: intervalDuration,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        intervalDuration: intervalDuration ?? const Duration(seconds: 5),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Location tracking is active",
          notificationTitle: "Location Service",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      );
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _currentPosition = position;
        _positionController.add(position);
      },
      onError: (e) {
        debugPrint('Location stream error: $e');
      },
    );
  }

  Future<void> stopLocationTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<double> calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<double> calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<List<Placemark>?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  Future<List<Location>?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }

  Future<String?> getFormattedAddress(double latitude, double longitude) async {
    final placemarks = await getAddressFromCoordinates(latitude, longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final parts = <String>[];

      if (placemark.street != null && placemark.street!.isNotEmpty) {
        parts.add(placemark.street!);
      }
      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        parts.add(placemark.locality!);
      }
      if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
        parts.add(placemark.administrativeArea!);
      }
      if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
        parts.add(placemark.postalCode!);
      }
      if (placemark.country != null && placemark.country!.isNotEmpty) {
        parts.add(placemark.country!);
      }

      return parts.join(', ');
    }
    return null;
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    _positionController.close();
    _serviceStatusController.close();
  }
}

enum LocationServiceStatus {
  available,
  disabled,
  permissionDenied,
  permissionDeniedForever,
}