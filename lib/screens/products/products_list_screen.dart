import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/app_bottom_nav.dart';

class ProductsListScreen extends StatefulWidget {
  final String? category;
  final String? search;

  const ProductsListScreen({
    super.key,
    this.category,
    this.search,
  });

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  String _sortBy = 'latest';
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.search != null) {
      _searchController.text = widget.search!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });
  }

  void _fetchProducts() {
    Provider.of<ProductProvider>(context, listen: false).fetchProducts(
      category: _sortBy == 'category' ? widget.category : widget.category,
      search: _searchController.text.isNotEmpty
          ? _searchController.text
          : widget.search,
      sort: _sortBy == 'category' ? null : _sortBy,
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              _sortBy == 'category'
                  ? '${widget.category ?? 'All'} Category'
                  : (widget.category ?? 'All Products'),
              style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              PopupMenuButton<String>(
                icon:
                    Icon(Icons.sort, color: Theme.of(context).iconTheme.color),
                onSelected: (value) {
                  setState(() => _sortBy = value);
                  _fetchProducts();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'category', child: Text('Category')),
                  const PopupMenuItem(value: 'latest', child: Text('Latest')),
                  const PopupMenuItem(
                      value: 'price_low', child: Text('Price: Low to High')),
                  const PopupMenuItem(
                      value: 'price_high', child: Text('Price: High to Low')),
                  const PopupMenuItem(value: 'name', child: Text('Name (A-Z)')),
                ],
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).iconTheme.color),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _fetchProducts(),
                ),
              ),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: LoadingWidget()),
                );
              }

              if (provider.products.isEmpty) {
                return const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.search_off,
                    title: 'No Products Found',
                    message: 'Try adjusting your search or filters',
                  ),
                );
              }

              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = provider.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(context, '/product-detail',
                              arguments: product);
                        },
                        onAddToCart: () async {
                          final cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          try {
                            await cartProvider.addToCart(product.id, 1);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Added to bag'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle error
                          }
                        },
                      );
                    },
                    childCount: provider.products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }


}
