import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../providers/theme_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../services/battery_service.dart';
import '../../services/permission_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BatteryService _batteryService = BatteryService();
  final PermissionService _permissionService = PermissionService();

  int _batteryLevel = 0;
  String _batteryState = 'Unknown';
  bool _isLoadingBattery = true;

  @override
  void initState() {
    super.initState();
    _loadBatteryInfo();
    _listenToBatteryChanges();
  }

  Future<void> _loadBatteryInfo() async {
    setState(() => _isLoadingBattery = true);
    try {
      final level = await _batteryService.getBatteryLevel();
      final state = await _batteryService.getBatteryStateString();
      setState(() {
        _batteryLevel = level;
        _batteryState = state;
        _isLoadingBattery = false;
      });
    } catch (e) {
      setState(() => _isLoadingBattery = false);
    }
  }

  void _listenToBatteryChanges() {
    _batteryService.batteryStateStream.listen((state) {
      _loadBatteryInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Appearance',
            children: [
              _buildThemeTile(context),
            ],
          ),
          _buildSection(
            title: 'Device Information',
            children: [
              _buildConnectivityTile(context),
              _buildBatteryTile(context),
            ],
          ),
          _buildSection(
            title: 'Permissions',
            children: [
              _buildPermissionTile(
                context,
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'For profile pictures and product reviews',
                onTap: () async {
                  final granted =
                      await _permissionService.requestCameraPermission();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(granted
                            ? 'Camera permission granted'
                            : 'Camera permission denied'),
                        backgroundColor: granted ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
              _buildPermissionTile(
                context,
                icon: Icons.location_on,
                title: 'Location',
                subtitle: 'For delivery address and store finder',
                onTap: () async {
                  final granted =
                      await _permissionService.requestLocationPermission();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(granted
                            ? 'Location permission granted'
                            : 'Location permission denied'),
                        backgroundColor: granted ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
              _buildPermissionTile(
                context,
                icon: Icons.photo_library,
                title: 'Storage',
                subtitle: 'For saving images and files',
                onTap: () async {
                  final granted =
                      await _permissionService.requestStoragePermission();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(granted
                            ? 'Storage permission granted'
                            : 'Storage permission denied'),
                        backgroundColor: granted ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          _buildSection(
            title: 'About',
            children: [
              _buildInfoTile(
                context,
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _buildInfoTile(
                context,
                icon: Icons.business,
                title: 'Company',
                subtitle: 'DreamyBloom Beauty & Skincare',
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textGray,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: AppColors.primaryColor,
          ),
          title: const Text('Theme'),
          subtitle: Text(themeProvider.getThemeModeString()),
          trailing: PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (ThemeMode mode) {
              themeProvider.setThemeMode(mode);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectivityTile(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, child) {
        return ListTile(
          leading: Icon(
            connectivityProvider.isOnline ? Icons.wifi : Icons.wifi_off,
            color: connectivityProvider.isOnline ? Colors.green : Colors.red,
          ),
          title: const Text('Network Status'),
          subtitle: Text(connectivityProvider.connectivityType),
          trailing: Icon(
            Icons.circle,
            size: 12,
            color: connectivityProvider.isOnline ? Colors.green : Colors.red,
          ),
        );
      },
    );
  }

  Widget _buildBatteryTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        _batteryState == 'Charging'
            ? Icons.battery_charging_full
            : Icons.battery_std,
        color: _batteryLevel < 20 ? Colors.red : Colors.green,
      ),
      title: const Text('Battery Status'),
      subtitle: _isLoadingBattery
          ? const Text('Loading...')
          : Text('$_batteryLevel% - $_batteryState'),
      trailing: _isLoadingBattery
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              '$_batteryLevel%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _batteryLevel < 20 ? Colors.red : Colors.green,
              ),
            ),
    );
  }

  Widget _buildPermissionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
