import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../config/api_config.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(Icons.add_shopping_cart,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {  Navigator.pushNamed(context, '/cart');},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: CachedNetworkImage(
                  imageUrl: ApiConfig.getImageUrl(widget.product.image),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[50]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black12,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.product.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.product.category!.name.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.product.inStock
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.product.inStock
                                ? AppColors.success.withOpacity(0.5)
                                : AppColors.error.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.product.inStock
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              size: 14,
                              color: widget.product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.inStock
                                  ? 'In Stock'
                                  : 'Out of Stock',
                              style: TextStyle(
                                color: widget.product.inStock
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      height: 1.1,
                      fontFamily:
                          'Playfair Display', // Elegant Serif if available, else falls back
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rs. ${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Description', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.6,
                      wordSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 200), // Spacing for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      child: const Icon(Icons.remove, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        if (_quantity < widget.product.stock)
                          setState(() => _quantity++);
                      },
                      child: Icon(Icons.add,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.product.inStock
                        ? () async {
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            await cartProvider.addToCart(
                                widget.product.id, _quantity);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Added to cart successfully!'),
                                    ],
                                  ),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.product.inStock ? 'Add to Cart' : 'Out of Stock',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
