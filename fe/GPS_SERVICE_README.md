# GPS Service Usage Guide

## Platform Configuration

### iOS Configuration (ios/Runner/Info.plist)
Add these keys to request location permissions:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open to show your current location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background to track your location.</string>
```

### Android Configuration (android/app/src/main/AndroidManifest.xml)
Add these permissions:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

## Usage Examples

### 1. Get Current Location
```dart
import 'package:hankan/app/service/gps_service.dart';

// Get current location
final position = await GpsService.I.getCurrentLocation();
if (position != null) {
  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');
}
```

### 2. Using with Riverpod
```dart
import 'package:hankan/app/provider/location_provider.dart';

// In a ConsumerWidget
Consumer(
  builder: (context, ref, child) {
    final locationAsync = ref.watch(currentLocationProvider);

    return locationAsync.when(
      data: (position) => Text('Location: ${position?.latitude}, ${position?.longitude}'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  },
)

// Get formatted address
final address = ref.watch(formattedAddressProvider((37.5665, 126.9780)));
```

### 3. Track Location Continuously
```dart
// Start tracking
await GpsService.I.startLocationTracking();

// Listen to location updates
GpsService.I.positionStream.listen((position) {
  print('New position: ${position.latitude}, ${position.longitude}');
});

// Stop tracking
await GpsService.I.stopLocationTracking();
```

### 4. Calculate Distance
```dart
final distance = await GpsService.I.calculateDistance(
  startLatitude,
  startLongitude,
  endLatitude,
  endLongitude,
);
print('Distance: ${distance} meters');
```

### 5. Get Address from Coordinates
```dart
final address = await GpsService.I.getFormattedAddress(37.5665, 126.9780);
print('Address: $address');
```

### 6. Get Coordinates from Address
```dart
final locations = await GpsService.I.getCoordinatesFromAddress('Seoul, South Korea');
if (locations != null && locations.isNotEmpty) {
  final location = locations.first;
  print('Coordinates: ${location.latitude}, ${location.longitude}');
}
```

### 7. Using LocationNotifier
```dart
// In a ConsumerWidget
final location = ref.watch(locationProvider);
final locationNotifier = ref.read(locationProvider.notifier);

// Request current location
await locationNotifier.requestCurrentLocation();

// Start tracking
await locationNotifier.startTracking();

// Calculate distance from current location
final distance = await locationNotifier.calculateDistanceFromCurrent(
  destinationLat,
  destinationLng,
);

// Open location settings
await locationNotifier.openSettings();
```

### 8. Check Permission Status
```dart
final locationStatus = ref.watch(locationServiceStatusProvider);

locationStatus.when(
  data: (status) {
    switch (status) {
      case LocationServiceStatus.available:
        // Location service is available
        break;
      case LocationServiceStatus.disabled:
        // Location service is disabled
        break;
      case LocationServiceStatus.permissionDenied:
        // Permission denied
        break;
      case LocationServiceStatus.permissionDeniedForever:
        // Permission denied forever, need to open settings
        break;
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

## Integration with Map Widgets

### With flutter_map package
```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Consumer(
  builder: (context, ref, child) {
    final location = ref.watch(currentLocationProvider);

    return location.when(
      data: (position) {
        if (position == null) return Text('No location');

        return FlutterMap(
          options: MapOptions(
            center: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: LatLng(position.latitude, position.longitude),
                  builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  },
)
```

## Best Practices

1. **Always check permissions** before accessing location
2. **Handle errors gracefully** - location services may not be available
3. **Stop tracking** when not needed to save battery
4. **Use appropriate accuracy** - high accuracy uses more battery
5. **Respect user privacy** - only request permissions when needed
6. **Test on real devices** - simulators may have limited GPS functionality