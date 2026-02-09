class ApiConfig {
  // Base URL - Update this to your actual backend URL
  static const String baseUrl = 'https://dreamybloom.katalytic.online/api/v1';
  static const String storageUrl = 'https://dreamybloom.katalytic.online/storage';
  
  // Authentication Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String updateProfile = '/user/profile';
  static const String updateProfilePicture = '/user/profile-photo';
  static const String updatePassword = '/user/password';
  
  // Product Endpoints
  static const String products = '/products';
  static const String productDetail = '/products'; // + /{slug}
  static const String productsByCategory = '/products/category'; // + /{category-slug}
  
  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryDetail = '/categories'; // + /{slug}
  
  // Cart Endpoints
  static const String cart = '/cart';
  static const String addToCart = '/cart';
  static const String updateCart = '/cart'; // + /{cart_id}
  static const String removeCart = '/cart'; // + /{cart_id}
  static const String clearCart = '/cart';
  
  // Order Endpoints
  static const String orders = '/orders';
  static const String orderDetail = '/orders'; // + /{order_id}
  static const String createOrder = '/orders';
  static const String cancelOrder = '/orders'; // + /{order_id}/cancel
  
  // Payment Endpoints
  static const String initializePayment = '/payment/initialize';
  static const String verifyPayment = '/payment/verify';
  
  // Other Endpoints
  static const String testimonials = '/testimonials';
  static const String contact = '/contact';
  
  // Helper method to construct image URLs
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('assets/') || imagePath.startsWith('http')) {
      return imagePath;
    }
    return '$storageUrl/$imagePath';
  }
}
