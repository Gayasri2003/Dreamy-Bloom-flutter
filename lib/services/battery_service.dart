import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class BatteryService {
  final Battery _battery = Battery();

  // Get current battery level (0-100)
  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  // Get battery state (charging, discharging, full, etc.)
  Future<BatteryState> getBatteryState() async {
    return await _battery.batteryState;
  }

  // Stream of battery state changes
  Stream<BatteryState> get batteryStateStream => _battery.onBatteryStateChanged;

  // Get battery state as string
  Future<String> getBatteryStateString() async {
    final state = await getBatteryState();
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.connectedNotCharging:
        return 'Connected (Not Charging)';
      default:
        return 'Unknown';
    }
  }

  // Get battery info as formatted string
  Future<String> getBatteryInfo() async {
    final level = await getBatteryLevel();
    final state = await getBatteryStateString();
    return '$level% - $state';
  }

  // Check if battery is low (below 20%)
  Future<bool> isBatteryLow() async {
    final level = await getBatteryLevel();
    return level < 20;
  }

  // Check if battery is critical (below 10%)
  Future<bool> isBatteryCritical() async {
    final level = await getBatteryLevel();
    return level < 10;
  }

  // Get battery icon based on level
  String getBatteryIcon(int level) {
    if (level >= 90) return '🔋'; // Full
    if (level >= 60) return '🔋'; // Good
    if (level >= 30) return '🔋'; // Medium
    if (level >= 10) return '🪫'; // Low
    return '🪫'; // Critical
  }
}
