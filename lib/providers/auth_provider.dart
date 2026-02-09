import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get isAuthenticated => _user != null;

  // Check auth status on app start
  Future<bool> checkAuthStatus() async {
    try {
      final hasToken = await _storage.hasToken();
      if (!hasToken) return false;

      final response = await _authService.getUserProfile();
      if (response.success && response.data != null) {
        _user = User.fromJson(response.data as Map<String, dynamic>);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email: email, password: password);
      _isLoading = false;

      if (response.success && response.data != null) {
        _user = User.fromJson(response.data['user'] as Map<String, dynamic>);
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      _isLoading = false;

      if (response.success && response.data != null) {
        _user = User.fromJson(response.data['user'] as Map<String, dynamic>);
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  // Update Profile
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        postalCode: postalCode,
      );

      _isLoading = false;

      if (response.success) {
        await refreshProfile();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Update Password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );

      _isLoading = false;

      if (response.success) {
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Update Profile Picture
  Future<bool> updateProfilePicture(File image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.updateProfilePicture(image);
      _isLoading = false;

      if (response.success) {
        await refreshProfile();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    try {
      final response = await _authService.getUserProfile();
      if (response.success && response.data != null) {
        _user = User.fromJson(response.data as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      // Silent fail
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
