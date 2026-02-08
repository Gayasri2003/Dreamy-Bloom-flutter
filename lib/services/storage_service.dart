import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Token Management (Secure)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // User Data Management (SharedPreferences)
  Future<void> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData);
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Clear All
  Future<void> clearAll() async {
    await deleteToken();
    await clearUserData();
  }
}
