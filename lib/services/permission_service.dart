import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    final status = await Permission.storage.request();
    if (status.isDenied) {
      // For Android 13+, try photos permission
      final photosStatus = await Permission.photos.request();
      return photosStatus.isGranted;
    }
    return status.isGranted;
  }

  // Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  // Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }

  // Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    final storageGranted = await Permission.storage.isGranted;
    final photosGranted = await Permission.photos.isGranted;
    return storageGranted || photosGranted;
  }

  // Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
      List<Permission> permissions) async {
    return await permissions.request();
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
