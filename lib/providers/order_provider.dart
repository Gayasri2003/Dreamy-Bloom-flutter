import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Fetch orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _orderService.getOrders();
      _isLoading = false;

      if (response.success && response.data != null) {
        _orders = (response.data as List)
            .map((json) => Order.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _error = response.message;
      }

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
    }
  }

  // Get single order
  Future<Order?> getOrder(int orderId) async {
    try {
      final response = await _orderService.getOrder(orderId);

      if (response.success && response.data != null) {
        return Order.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Create order
  Future<Order?> createOrder({
    required String shippingName,
    required String shippingEmail,
    required String shippingPhone,
    required String shippingAddress,
    required String shippingCity,
    required String shippingPostalCode,
    required String paymentMethod,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _orderService.createOrder(
        shippingName: shippingName,
        shippingEmail: shippingEmail,
        shippingPhone: shippingPhone,
        shippingAddress: shippingAddress,
        shippingCity: shippingCity,
        shippingPostalCode: shippingPostalCode,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      _isLoading = false;

      if (response.success && response.data != null) {
        final order = Order.fromJson(response.data as Map<String, dynamic>);
        _orders.insert(0, order); // Add to top of list
        notifyListeners();
        return order;
      } else {
        _error = response.message;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await _orderService.cancelOrder(orderId);

      if (response.success) {
        await fetchOrders(); // Refresh orders
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
