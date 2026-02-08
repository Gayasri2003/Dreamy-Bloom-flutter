import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme_config.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/connectivity_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/products/products_list_screen.dart';
import 'screens/products/product_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/cart/checkout_screen.dart';
import 'screens/orders/orders_list_screen.dart';
import 'screens/orders/order_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/contact/contact_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/store_locator/store_locator_screen.dart';

import 'models/product.dart';
import 'models/order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'DreamyBloom',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (_) => const SplashScreen());

                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginScreen());

                case '/register':
                  return MaterialPageRoute(
                      builder: (_) => const RegisterScreen());

                case '/home':
                  return MaterialPageRoute(builder: (_) => const HomeScreen());

                case '/products':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => ProductsListScreen(
                      category: args?['category'] as String?,
                      search: args?['search'] as String?,
                    ),
                  );

                case '/product-detail':
                  final product = settings.arguments as Product;
                  return MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  );

                case '/cart':
                  return MaterialPageRoute(builder: (_) => const CartScreen());

                case '/checkout':
                  return MaterialPageRoute(
                      builder: (_) => const CheckoutScreen());

                case '/orders':
                  return MaterialPageRoute(
                      builder: (_) => const OrdersListScreen());

                case '/order-detail':
                  final order = settings.arguments as Order;
                  return MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(order: order),
                  );

                case '/profile':
                  return MaterialPageRoute(
                      builder: (_) => const ProfileScreen());

                case '/edit-profile':
                  return MaterialPageRoute(
                      builder: (_) => const EditProfileScreen());

                case '/contact':
                  return MaterialPageRoute(
                      builder: (_) => const ContactScreen());

                case '/settings':
                  return MaterialPageRoute(
                      builder: (_) => const SettingsScreen());

                case '/store-locator':
                  return MaterialPageRoute(
                      builder: (_) => const StoreLocatorScreen());

                default:
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(
                        child: Text('No route defined for ${settings.name}'),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
