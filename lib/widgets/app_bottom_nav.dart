import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _go(BuildContext context, int index) {
    // routes must match your onGenerateRoute
    const routes = ['/home', '/products', '/orders', '/profile'];

    if (index == currentIndex) return;

    // Use replacement so bottom tabs don't create a deep back stack
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(context, Icons.home, 'Home', 0),
              _item(context, Icons.grid_view, 'Products', 1),
              _item(context, Icons.shopping_bag, 'Orders', 2),
              _item(context, Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    final inactiveColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return InkWell(
      onTap: () => _go(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? Theme.of(context).colorScheme.primary : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Theme.of(context).colorScheme.primary : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
