import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/theme_config.dart';
import '../../services/location_service.dart';
import '../../services/permission_service.dart';

class StoreLocatorScreen extends StatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  State<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  final LocationService _locationService = LocationService();
  final PermissionService _permissionService = PermissionService();

  Position? _currentPosition;
  bool _isLoading = false;
  String _errorMessage = '';

  // Sample store locations (in a real app, these would come from an API)
  final List<Map<String, dynamic>> _stores = [
    {
      'name': 'DreamyBloom Colombo',
      'address': '123 Galle Road, Colombo 03',
      'phone': '+94 11 234 5678',
      'latitude': 6.9271,
      'longitude': 79.8612,
      'hours': 'Mon-Sat: 9:00 AM - 8:00 PM',
    },
    {
      'name': 'DreamyBloom Kandy',
      'address': '456 Peradeniya Road, Kandy',
      'phone': '+94 81 234 5678',
      'latitude': 7.2906,
      'longitude': 80.6337,
      'hours': 'Mon-Sat: 9:00 AM - 7:00 PM',
    },
    {
      'name': 'DreamyBloom Galle',
      'address': '789 Main Street, Galle',
      'phone': '+94 91 234 5678',
      'latitude': 6.0535,
      'longitude': 80.2210,
      'hours': 'Mon-Sat: 9:00 AM - 7:00 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Check location permission
      final hasPermission = await _permissionService.hasLocationPermission();
      if (!hasPermission) {
        final granted = await _permissionService.requestLocationPermission();
        if (!granted) {
          setState(() {
            _errorMessage =
                'Location permission is required to find nearby stores';
            _isLoading = false;
          });
          return;
        }
      }

      // Get current position
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });
        _calculateDistances();
      } else {
        setState(() {
          _errorMessage =
              'Unable to get your location. Please enable location services.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  void _calculateDistances() {
    if (_currentPosition == null) return;

    for (var store in _stores) {
      final distance = _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        store['latitude'],
        store['longitude'],
      );
      store['distance'] = distance;
    }

    // Sort stores by distance
    _stores.sort((a, b) => (a['distance'] ?? double.infinity)
        .compareTo(b['distance'] ?? double.infinity));

    setState(() {});
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Locator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _getCurrentLocation,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_currentPosition != null) ...[
            _buildCurrentLocationCard(),
            const SizedBox(height: 24),
          ],
          const Text(
            'Nearby Stores',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._stores.map((store) => _buildStoreCard(store)).toList(),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppColors.primaryColor,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Accuracy: ${_locationService.getAccuracyDescription(_currentPosition!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    final hasDistance = store.containsKey('distance');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // In a real app, this would open maps or show more details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${store['name']}...'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (hasDistance)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDistance(store['distance']),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.textGray),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      store['address'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: AppColors.textGray),
                  const SizedBox(width: 8),
                  Text(
                    store['phone'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: AppColors.textGray),
                  const SizedBox(width: 8),
                  Text(
                    store['hours'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Open in maps
                      },
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Directions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Call store
                      },
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
