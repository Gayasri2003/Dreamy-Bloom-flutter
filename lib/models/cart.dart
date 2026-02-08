import 'product.dart';

class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final Product? product;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse numbers
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return CartItem(
      id: parseInt(json['id']),
      productId: parseInt(json['product_id']),
      quantity: parseInt(json['quantity']),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'product': product?.toJson(),
    };
  }

  double get subtotal => (product?.price ?? 0) * quantity;
}

class Cart {
  final List<CartItem> items;
  final double total;
  final int count;

  Cart({
    required this.items,
    required this.total,
    required this.count,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final items = (json['items'] as List?)
            ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return Cart(
      items: items,
      total: parseDouble(json['total']),
      count: parseInt(json['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'count': count,
    };
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
