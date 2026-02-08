import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class JsonDataService {
  // Load local JSON file from assets
  Future<Map<String, dynamic>> loadLocalJson(String fileName) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/$fileName');
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading local JSON: $e');
      return {};
    }
  }

  // Fetch external JSON file from URL
  Future<Map<String, dynamic>> fetchExternalJson(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to load external JSON: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching external JSON: $e');
      return {};
    }
  }

  // Get products from local JSON
  Future<List<dynamic>> getOfflineProducts() async {
    final data = await loadLocalJson('offline_products.json');
    return data['products'] as List<dynamic>? ?? [];
  }

  // Get testimonials from local JSON
  Future<List<dynamic>> getLocalTestimonials() async {
    final data = await loadLocalJson('testimonials.json');
    return data['testimonials'] as List<dynamic>? ?? [];
  }

  // Fetch products from external JSON with fallback to local
  Future<ApiResponse> getProductsWithFallback({
    String? externalUrl,
    bool forceOffline = false,
  }) async {
    if (!forceOffline && externalUrl != null) {
      try {
        final data = await fetchExternalJson(externalUrl);
        if (data.isNotEmpty) {
          return ApiResponse(
            success: true,
            message: 'Products loaded from external source',
            data: data,
          );
        }
      } catch (e) {
        print('External fetch failed, falling back to local: $e');
      }
    }

    // Fallback to local JSON
    final products = await getOfflineProducts();
    return ApiResponse(
      success: true,
      message: 'Products loaded from offline storage',
      data: {'products': products},
    );
  }

  // Fetch testimonials from external JSON with fallback to local
  Future<ApiResponse> getTestimonialsWithFallback({
    String? externalUrl,
    bool forceOffline = false,
  }) async {
    if (!forceOffline && externalUrl != null) {
      try {
        final data = await fetchExternalJson(externalUrl);
        if (data.isNotEmpty) {
          return ApiResponse(
            success: true,
            message: 'Testimonials loaded from external source',
            data: data,
          );
        }
      } catch (e) {
        print('External fetch failed, falling back to local: $e');
      }
    }

    // Fallback to local JSON
    final testimonials = await getLocalTestimonials();
    return ApiResponse(
      success: true,
      message: 'Testimonials loaded from offline storage',
      data: {'testimonials': testimonials},
    );
  }
}
