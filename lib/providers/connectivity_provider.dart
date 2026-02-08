import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isOnline = true;
  String _connectivityType = 'Unknown';

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isOnline => _isOnline;
  String get connectivityType => _connectivityType;

  ConnectivityProvider() {
    _initConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _initConnectivity() async {
    _connectivityResult = await _connectivityService.checkConnectivity();
    _isOnline = await _connectivityService.isOnline();
    _connectivityType = await _connectivityService.getConnectivityType();
    notifyListeners();
  }

  void _listenToConnectivityChanges() {
    _connectivityService.connectivityStream.listen((ConnectivityResult result) {
      _connectivityResult = result;
      _isOnline = result != ConnectivityResult.none;
      _updateConnectivityType(result);
      notifyListeners();
    });
  }

  void _updateConnectivityType(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        _connectivityType = 'WiFi';
        break;
      case ConnectivityResult.mobile:
        _connectivityType = 'Mobile Data';
        break;
      case ConnectivityResult.ethernet:
        _connectivityType = 'Ethernet';
        break;
      case ConnectivityResult.vpn:
        _connectivityType = 'VPN';
        break;
      case ConnectivityResult.bluetooth:
        _connectivityType = 'Bluetooth';
        break;
      case ConnectivityResult.other:
        _connectivityType = 'Other';
        break;
      case ConnectivityResult.none:
        _connectivityType = 'Offline';
        break;
    }
  }

  Future<void> checkConnectivity() async {
    await _initConnectivity();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
}
