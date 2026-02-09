import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart.dart';
import '../config/theme_config.dart';
import '../config/api_config.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    if (product == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              child: _buildProductImage(context, product),
            ),
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceText.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (item.quantity > 1) {
                            onQuantityChanged(item.quantity - 1);
                          }
                        },
                        icon: const Icon(Icons.remove),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.bgLightPink,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (item.quantity < product.stock) {
                            onQuantityChanged(item.quantity + 1);
                          }
                        },
                        icon: const Icon(Icons.add),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, product) {
    final imageUrl = ApiConfig.getImageUrl(product.image);

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.bgLightPink,
        width: 80,
        height: 80,
      ),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColors.bgLightPink,
      width: 80,
      height: 80,
      child: const Icon(Icons.image_not_supported),
    );
  }
}
