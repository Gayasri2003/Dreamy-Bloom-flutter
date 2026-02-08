import 'product.dart';

class OrderItem {
  final int id;
  final int quantity;
  final double price;
  final Product? product;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
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

    return OrderItem(
      id: parseInt(json['id']),
      quantity: parseInt(json['quantity']),
      price: parseDouble(json['price']),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'product': product?.toJson(),
    };
  }

  double get subtotal => price * quantity;
}

class Order {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String shippingName;
  final String shippingPhone;
  final String shippingAddress;
  final String shippingCity;
  final String? shippingPostalCode;
  final String? notes;
  final DateTime createdAt;
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
    required this.shippingCity,
    this.shippingPostalCode,
    this.notes,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
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

    return Order(
      id: parseInt(json['id']),
      orderNumber: json['order_number'] as String? ?? '',
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
      paymentStatus: json['payment_status'] as String? ?? 'Pending',
      orderStatus:
          (json['order_status'] ?? json['status']) as String? ?? 'Pending',
      shippingName: json['shipping_name'] as String? ?? '',
      shippingPhone: json['shipping_phone'] as String? ?? '',
      shippingAddress: json['shipping_address'] as String? ?? '',
      shippingCity: json['shipping_city'] as String? ?? '',
      shippingPostalCode: json['shipping_postal_code'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'shipping_name': shippingName,
      'shipping_phone': shippingPhone,
      'shipping_address': shippingAddress,
      'shipping_city': shippingCity,
      'shipping_postal_code': shippingPostalCode,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }

  String get statusDisplay {
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return orderStatus;
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Paid';
      case 'failed':
        return 'Failed';
      default:
        return paymentStatus;
    }
  }
}
