import 'category.dart';

class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final int stock;
  final String? image;
  final bool isActive;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.stock,
    this.image,
    this.isActive = true,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse numbers
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

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return true; // default
    }

    return Product(
      id: parseInt(json['id']),
      name: json['name'] as String? ?? 'Unknown Product',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: parseDouble(json['price']),
      stock: parseInt(json['stock']),
      image: json['image'] as String?,
      isActive: parseBool(json['is_active']),
      category: json['category'] != null 
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'is_active': isActive,
      'category': category?.toJson(),
    };
  }

  bool get inStock => stock > 0;
}
