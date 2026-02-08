import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_response.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage = StorageService();

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET Request
  Future<ApiResponse> get(String endpoint, {bool auth = false}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: auth);

      final response = await http.get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // POST Request
  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool auth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: auth);

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // PUT Request
  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool auth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: auth);

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // DELETE Request
  Future<ApiResponse> delete(String endpoint, {bool auth = false}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: auth);

      final response = await http.delete(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: data['success'] ?? true,
          message: data['message'] ?? 'Success',
          data: data['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Request failed',
          errors: data['errors'] as Map<String, dynamic>?,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to parse response: ${e.toString()}',
      );
    }
  }
}
