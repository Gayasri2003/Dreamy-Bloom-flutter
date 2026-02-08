import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _addressController.text = user.address ?? '';
        _cityController.text = user.city ?? '';
        _postalCodeController.text = user.postalCode ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // 1. Create Order first (Pending state)
    final order = await orderProvider.createOrder(
      shippingName: _nameController.text.trim(),
      shippingEmail: _emailController.text.trim(),
      shippingPhone: _phoneController.text.trim(),
      shippingAddress: _addressController.text.trim(),
      shippingCity: _cityController.text.trim(),
      shippingPostalCode: _postalCodeController.text.trim(),
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim(),
    );

    if (!mounted) return;

    if (order != null) {
      await cartProvider.clearCart();

      // 2. Handle Payment
      if (_paymentMethod == 'payhere') {
        // Start PayHere
        PaymentService().startPayment(
          order: order,
          userEmail: _emailController.text.trim(),
          userName: _nameController.text.trim(),
          userPhone: _phoneController.text.trim(),
          userAddress: _addressController.text.trim(),
          userCity: _cityController.text.trim(),
          onSuccess: (paymentId) {
            // TODO: Call backend to verify/update payment status if needed
            // For now, assume success and navigate
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Successful!')),
            );
            _navigateToOrders();
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Payment Failed: $error'),
                  backgroundColor: AppColors.error),
            );
            // Even if payment fails, order exists as Pending. Navigate to orders so they can retry or see it.
            _navigateToOrders();
          },
          onDismissed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Dismissed')),
            );
            _navigateToOrders();
          },
        );
      } else {
        // Cash on Delivery
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        _navigateToOrders();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Failed to place order'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _navigateToOrders() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    Navigator.of(context).pushNamed('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Checkout',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Shipping Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Email is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Phone is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address',
                controller: _addressController,
                maxLines: 2,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Address is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'City',
                controller: _cityController,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'City is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Postal Code',
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Postal code is required' : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onBackground,
                ),
              ),

              const SizedBox(height: 12),
              RadioListTile<String>(
                title: Text('Cash on Delivery',
                  style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
                value: 'cash',
                groupValue: _paymentMethod,
                activeColor: theme.colorScheme.primary,
                tileColor: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              RadioListTile<String>(
                title:  Text('PayHere (Online Payment)',
                  style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
                ),
                value: 'payhere',
                groupValue: _paymentMethod,
                activeColor: theme.colorScheme.primary,
                tileColor: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Order Notes (Optional)',
                controller: _notesController,
                maxLines: 3,
                hint: 'Any special instructions?',
              ),
              const SizedBox(height: 24),
              Consumer2<OrderProvider, CartProvider>(
                builder: (context, orderProvider, cartProvider, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),

                          Text(
                            'Rs. ${cartProvider.total.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),

                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Place Order',
                        onPressed: _placeOrder,
                        isLoading: orderProvider.isLoading,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
