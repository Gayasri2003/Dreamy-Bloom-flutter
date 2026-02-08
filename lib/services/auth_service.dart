import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();

  // Register
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };

    final response = await _apiService.post(ApiConfig.register, data);
    
    // Save token if registration successful
    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        await _storage.saveToken(token);
      }
    }
    
    return response;
  }

  // Login
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await _apiService.post(ApiConfig.login, data);
    
    // Save token if login successful
    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        await _storage.saveToken(token);
      }
    }
    
    return response;
  }

  // Logout
  Future<ApiResponse> logout() async {
    final response = await _apiService.post(ApiConfig.logout, {}, auth: true);
    
    // Clear local storage regardless of API response
    await _storage.clearAll();
    
    return response;
  }

  // Get User Profile
  Future<ApiResponse> getUserProfile() async {
    return await _apiService.get(ApiConfig.user, auth: true);
  }

  // Update Profile
  Future<ApiResponse> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    final data = {
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (postalCode != null) 'postal_code': postalCode,
    };

    return await _apiService.put(ApiConfig.updateProfile, data, auth: true);
  }

  // Update Password
  Future<ApiResponse> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final data = {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };

    return await _apiService.put(ApiConfig.updatePassword, data, auth: true);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.hasToken();
  }
}
