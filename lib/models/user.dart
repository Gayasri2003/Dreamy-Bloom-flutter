class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.address,
    this.city,
    this.postalCode,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'customer',
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'image': image,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? address,
    String? city,
    String? postalCode,
    String? image,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      image: image ?? this.image,
    );
  }
}
