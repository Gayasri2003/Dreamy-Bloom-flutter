import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products with filters
  Future<ApiResponse> getProducts({
    String? category,
    String? search,
    String? sort,
    int? perPage,
    int? page,
  }) async {
    String endpoint = ApiConfig.products;
    final queryParams = <String, String>{};

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }
    if (perPage != null) {
      queryParams['per_page'] = perPage.toString();
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }

    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      endpoint = '$endpoint?$query';
    }

    return await _apiService.get(endpoint);
  }

  // Get single product by slug
  Future<ApiResponse> getProduct(String slug) async {
    return await _apiService.get('${ApiConfig.productDetail}/$slug');
  }

  // Get products by category
  Future<ApiResponse> getProductsByCategory(String categorySlug, {
    int? perPage,
    int? page,
  }) async {
    String endpoint = '${ApiConfig.productsByCategory}/$categorySlug';
    final queryParams = <String, String>{};

    if (perPage != null) {
      queryParams['per_page'] = perPage.toString();
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }

    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      endpoint = '$endpoint?$query';
    }

    return await _apiService.get(endpoint);
  }

  // Get all categories
  Future<ApiResponse> getCategories() async {
    return await _apiService.get(ApiConfig.categories);
  }

  // Get single category
  Future<ApiResponse> getCategory(String slug) async {
    return await _apiService.get('${ApiConfig.categoryDetail}/$slug');
  }
}
