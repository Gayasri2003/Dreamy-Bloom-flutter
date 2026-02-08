import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();

  Cart? _cart;
  Cart? get cart => _cart;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int get itemCount => _cart?.count ?? 0;
  double get total => _cart?.total ?? 0.0;
  bool get isEmpty => _cart?.isEmpty ?? true;

  // Fetch cart
  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _cartService.getCart();
      _isLoading = false;

      if (response.success && response.data != null) {
        _cart = Cart.fromJson(response.data as Map<String, dynamic>);
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

  // Add to cart
  Future<bool> addToCart(int productId, int quantity) async {
    try {
      // Ensure cart is fetched before checking
      if (_cart == null) {
        await fetchCart();
      }

      // Check if item already exists in cart
      final existingItem = _cart?.items.firstWhere(
        (item) => item.productId == productId,
        orElse: () => CartItem(id: -1, productId: -1, quantity: 0),
      );

      if (existingItem != null && existingItem.id != -1) {
        // Item exists, verify not exceeding limits if necessary, then update quantity
        return updateCartItem(
            existingItem.id, existingItem.quantity + quantity);
      }

      // Item does not exist, add new
      final response = await _cartService.addToCart(
        productId: productId,
        quantity: quantity,
      );

      if (response.success) {
        await fetchCart(); // Refresh cart
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

  // Update cart item
  Future<bool> updateCartItem(int cartId, int quantity) async {
    try {
      final response = await _cartService.updateCart(
        cartId: cartId,
        quantity: quantity,
      );

      if (response.success) {
        await fetchCart(); // Refresh cart
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

  // Remove cart item
  Future<bool> removeCartItem(int cartId) async {
    try {
      final response = await _cartService.removeCart(cartId);

      if (response.success) {
        await fetchCart(); // Refresh cart
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

  // Clear cart
  Future<bool> clearCart() async {
    try {
      final response = await _cartService.clearCart();

      if (response.success) {
        _cart = null;
        notifyListeners();
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
