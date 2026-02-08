class Category {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse int
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Helper to safely parse bool
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return true;
    }

    return Category(
      id: parseInt(json['id']),
      name: json['name'] as String? ?? 'Unknown Category',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
      isActive: parseBool(json['is_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'is_active': isActive,
    };
  }
}
