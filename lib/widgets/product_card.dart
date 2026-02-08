import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../config/theme_config.dart';
import '../config/api_config.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Badges
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Main Image
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: ApiConfig.getImageUrl(product.image),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[50],
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[50],
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.5),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Category Badge
                  if (product.category != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          product.category!.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                  // Like Button (Optional visual enhancement)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines:
                                1, // Restricted to 1 line to prevent overflow often
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14, // Slightly reduced
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Flexible
                            (child: Text(
                            product.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white60
                                  : AppColors.textGray,
                              height: 1.2,
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // Align to bottom
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white60
                                      : AppColors.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Rs. ${product.price.toStringAsFixed(0)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (product.inStock)
                          InkWell(
                            onTap: onAddToCart,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
