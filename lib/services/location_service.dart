import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Get address from coordinates (requires reverse geocoding - would need geocoding package)
  Future<String> getAddressFromPosition(Position position) async {
    // This is a placeholder - you would need geocoding package for full implementation
    return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
  }

  // Calculate distance between two points in meters
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get location accuracy description
  String getAccuracyDescription(Position position) {
    if (position.accuracy < 10) {
      return 'Excellent';
    } else if (position.accuracy < 50) {
      return 'Good';
    } else if (position.accuracy < 100) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }
}
