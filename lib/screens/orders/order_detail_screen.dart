import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added
import 'package:intl/intl.dart';
import '../../config/theme_config.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart'; // Added
import '../../widgets/custom_app_bar.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _fetchLatestOrder();
  }

  Future<void> _fetchLatestOrder() async {
    setState(() => _isLoading = true);
    // Fetch fresh data
    final freshOrder = await Provider.of<OrderProvider>(context, listen: false)
        .getOrder(_order.id);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (freshOrder != null) {
          _order = freshOrder;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Order Details',
        showBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLatestOrder,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: LinearProgressIndicator(),
                )),
              Card(
                color: theme.cardColor,
                elevation: isDark ? 0 : 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${_order.orderNumber}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a')
                            .format(_order.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                        ),

                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(context, 'Status', _order.statusDisplay),
                      _buildInfoRow(context, 'Payment', _order.paymentStatusDisplay),
                      _buildInfoRow(context,
                          'Method', _order.paymentMethod.toUpperCase()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: theme.cardColor,
                elevation: isDark ? 0 : 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping Information',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Name', _order.shippingName),
                      _buildInfoRow(context, 'Phone', _order.shippingPhone),
                      _buildInfoRow(context, 'Address', _order.shippingAddress),
                      _buildInfoRow(context, 'City', _order.shippingCity),
                      if (_order.shippingPostalCode != null)
                        _buildInfoRow(context,
                            'Postal Code', _order.shippingPostalCode!),
                    ],
                  ),
                ),
              ),
              if (_order.items != null && _order.items!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: isDark ? theme.cardColor.withOpacity(0.95) : theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isDark ? BorderSide(color: Colors.white.withOpacity(0.08)) : BorderSide.none,
                  ),
                  elevation: isDark ? 0 : 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Items',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ..._order.items!.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.product?.name ?? 'Product'} x${item.quantity}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                        Divider(
                          color: isDark ? Colors.white.withOpacity(0.12) : Colors.grey.shade300,
                          height: 24,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              'Rs. ${_order.totalAmount.toStringAsFixed(2)}',
                              style: AppTextStyles.priceText
                                  .copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
