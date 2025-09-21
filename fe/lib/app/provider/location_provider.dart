import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hankan/app/service/gps_service.dart';

final currentLocationProvider = FutureProvider<Position?>((ref) async {
  return await GpsService.I.getCurrentLocation();
});

final locationStreamProvider = StreamProvider<Position>((ref) {
  return GpsService.I.positionStream;
});

final locationServiceStatusProvider = StreamProvider<LocationServiceStatus>((ref) {
  return GpsService.I.serviceStatusStream;
});

final formattedAddressProvider = FutureProvider.family<String?, (double, double)>((ref, coords) async {
  return await GpsService.I.getFormattedAddress(coords.$1, coords.$2);
});

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState());

  final GpsService _gpsService = GpsService.I;

  Future<void> startTracking() async {
    state = state.copyWith(isTracking: true);
    await _gpsService.startLocationTracking();
  }

  Future<void> stopTracking() async {
    state = state.copyWith(isTracking: false);
    await _gpsService.stopLocationTracking();
  }

  Future<void> requestCurrentLocation() async {
    state = state.copyWith(isLoading: true);
    final position = await _gpsService.getCurrentLocation();
    if (position != null) {
      state = state.copyWith(
        isLoading: false,
        currentPosition: position,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> getAddress(double latitude, double longitude) async {
    return await _gpsService.getFormattedAddress(latitude, longitude);
  }

  Future<double> calculateDistanceFromCurrent(double endLat, double endLng) async {
    if (state.currentPosition == null) {
      await requestCurrentLocation();
    }

    if (state.currentPosition != null) {
      return await _gpsService.calculateDistance(
        state.currentPosition!.latitude,
        state.currentPosition!.longitude,
        endLat,
        endLng,
      );
    }
    return 0.0;
  }

  Future<void> openSettings() async {
    await _gpsService.openLocationSettings();
  }
}

class LocationState {
  final bool isLoading;
  final bool isTracking;
  final Position? currentPosition;
  final String? errorMessage;

  const LocationState({
    this.isLoading = false,
    this.isTracking = false,
    this.currentPosition,
    this.errorMessage,
  });

  LocationState copyWith({
    bool? isLoading,
    bool? isTracking,
    Position? currentPosition,
    String? errorMessage,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      isTracking: isTracking ?? this.isTracking,
      currentPosition: currentPosition ?? this.currentPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});