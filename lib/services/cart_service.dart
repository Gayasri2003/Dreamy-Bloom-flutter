import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService = ApiService();

  // Get cart items
  Future<ApiResponse> getCart() async {
    return await _apiService.get(ApiConfig.cart, auth: true);
  }

  // Add to cart
  Future<ApiResponse> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final data = {
      'product_id': productId,
      'quantity': quantity,
    };

    return await _apiService.post(ApiConfig.addToCart, data, auth: true);
  }

  // Update cart item
  Future<ApiResponse> updateCart({
    required int cartId,
    required int quantity,
  }) async {
    final data = {
      'quantity': quantity,
    };

    return await _apiService.put('${ApiConfig.updateCart}/$cartId', data, auth: true);
  }

  // Remove cart item
  Future<ApiResponse> removeCart(int cartId) async {
    return await _apiService.delete('${ApiConfig.removeCart}/$cartId', auth: true);
  }

  // Clear cart
  Future<ApiResponse> clearCart() async {
    return await _apiService.delete(ApiConfig.clearCart, auth: true);
  }
}
