import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  // Get all orders
  Future<ApiResponse> getOrders() async {
    return await _apiService.get(ApiConfig.orders, auth: true);
  }

  // Get single order
  Future<ApiResponse> getOrder(int orderId) async {
    return await _apiService.get('${ApiConfig.orderDetail}/$orderId', auth: true);
  }

  // Create order (checkout)
  Future<ApiResponse> createOrder({
    required String shippingName,
    required String shippingEmail,
    required String shippingPhone,
    required String shippingAddress,
    required String shippingCity,
    required String shippingPostalCode,
    required String paymentMethod,
    String? notes,
  }) async {
    final data = {
      'shipping_name': shippingName,
      'shipping_email': shippingEmail,
      'shipping_phone': shippingPhone,
      'shipping_address': shippingAddress,
      'shipping_city': shippingCity,
      'shipping_postal_code': shippingPostalCode,
      'payment_method': paymentMethod,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    return await _apiService.post(ApiConfig.createOrder, data, auth: true);
  }

  // Cancel order
  Future<ApiResponse> cancelOrder(int orderId) async {
    return await _apiService.post('${ApiConfig.cancelOrder}/$orderId/cancel', {}, auth: true);
  }

  // Initialize PayHere payment
  Future<ApiResponse> initializePayment(int orderId) async {
    final data = {'order_id': orderId};
    return await _apiService.post(ApiConfig.initializePayment, data, auth: true);
  }

  // Verify payment
  Future<ApiResponse> verifyPayment(int orderId) async {
    final data = {'order_id': orderId};
    return await _apiService.post(ApiConfig.verifyPayment, data, auth: true);
  }

  // Submit contact form
  Future<ApiResponse> submitContact({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };

    return await _apiService.post(ApiConfig.contact, data);
  }
}
