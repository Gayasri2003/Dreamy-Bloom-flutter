import 'package:flutter/foundation.dart' hide Category;
import '../models/product.dart';
import '../models/category.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // Fetch products
  Future<void> fetchProducts({
    String? category,
    String? search,
    String? sort,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _products = [];
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        category: category,
        search: search,
        sort: sort,
        page: _currentPage,
      );

      _isLoading = false;

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        // Support both paginated and flat product list structures
        List productsRaw;
        int? currentPage;
        int? lastPage;
        if (data['products'] != null && data['products'] is Map<String, dynamic>) {
          // paginated: { products: { data: [...], current_page: x, last_page: y, ... } }
          final productsObj = data['products'] as Map<String, dynamic>;
          productsRaw = productsObj['data'] as List? ?? [];
          currentPage = productsObj['current_page'] as int?;
          lastPage = productsObj['last_page'] as int?;
        } else if (data['data'] != null && data['data'] is List) {
          // paginated: { data: [...], current_page: x, last_page: y, ... }
          productsRaw = data['data'] as List;
          currentPage = data['current_page'] as int?;
          lastPage = data['last_page'] as int?;
        } else if (data is Map<String, dynamic> && data.isNotEmpty && data.values.first is List) {
          // fallback: { something: [...] }
          productsRaw = data.values.first as List;
        } else {
          productsRaw = [];
        }
        final productList = productsRaw
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        if (refresh) {
          _products = productList;
        } else {
          _products.addAll(productList);
        }

        _currentPage = currentPage ?? 1;
        _totalPages = lastPage ?? 1;
        _hasMore = _currentPage < _totalPages;
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

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final response = await _productService.getCategories();

      if (response.success && response.data != null) {
        _categories = (response.data as List)
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      // Silent fail for categories
    }
  }

  // Get single product
  Future<Product?> getProduct(String slug) async {
    try {
      final response = await _productService.getProduct(slug);

      if (response.success && response.data != null) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Load more products
  Future<void> loadMore({
    String? category,
    String? search,
    String? sort,
  }) async {
    if (!_hasMore || _isLoading) return;
    _currentPage++;
    await fetchProducts(
      category: category,
      search: search,
      sort: sort,
      refresh: false,
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
