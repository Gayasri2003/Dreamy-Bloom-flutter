import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Stream controller for connectivity changes
  final StreamController<ConnectivityResult> _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  ConnectivityService() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityController.add(result);
    });
  }

  // Check current connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    return result;
  }

  // Check if device is online
  Future<bool> isOnline() async {
    final result = await checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Get connectivity type as string
  Future<String> getConnectivityType() async {
    final result = await checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'Offline';
    }
  }

  void dispose() {
    _connectivityController.close();
  }
}
