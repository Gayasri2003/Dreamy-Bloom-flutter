import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  PreferredSizeWidget _buildFixedHomeAppBar() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final onSurface = theme.colorScheme.onSurface;
    final iconColor = onSurface;
    final greetingColor = textTheme.bodyMedium?.color ?? onSurface.withOpacity(0.8);
    final nameColor = textTheme.titleMedium?.color ?? onSurface;

    return AppBar(
      elevation: 0,
      backgroundColor: theme.cardColor,
      automaticallyImplyLeading: false,
      toolbarHeight: 130,

      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            'assets/images/DreamyBloom_Logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Greeting
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${getGreeting()},',
                          style: TextStyle(
                            color: greetingColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined, color: iconColor),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cartProvider.itemCount}',
                                style: const TextStyle(

                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),


            Container(
              height: 42,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: TextStyle(color: textTheme.bodySmall?.color),
                  prefixIcon: Icon(Icons.search, color: iconColor.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  Navigator.pushNamed(
                    context,
                    '/products',
                    arguments: {'search': value},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // senser for greetings

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    if (hour >= 17 && hour < 21) return "Good Evening";
    return "Good Night";
  }

  int _currentCarouselIndex = 0;


  final List<Map<String, String>> _carouselItems = [
    {
      'title': '✨ Enhance Your Natural Beauty',
      'subtitle': 'Discover premium cosmetics, skincare, and beauty essentials',
      'image': 'assets/images/home_image.jpeg',
    },
    {
      'title': '💄 Makeup That Empowers',
      'subtitle': 'From everyday looks to glamorous transformations',
      'image': 'assets/images/about_image.png',
    },
    {
      'title': '🌸 Skincare Essentials',
      'subtitle': 'Nurture your skin with our carefully curated collection',
      'image': 'assets/images/c1.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(refresh: true);
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: _buildFixedHomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProductProvider>(context, listen: false)
              .fetchProducts(refresh: true);
        },
        child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildCarousel()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildFeatures()),
              SliverToBoxAdapter(child: _buildNewArrivals()),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),

    );
  }



  Widget _buildCarousel() {
    return Column(
      children: [
        const SizedBox(height: 10),
        CarouselSlider(
          items: _carouselItems.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background Image
                    SizedBox.expand(
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryColor,
                          );
                        },
                      ),
                    ),
                    // Gradient Overlay for Readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Decorative Circles
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150, // Reduced size
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min, // Important for fitting
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'NEW ARRIVAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Reduced font size
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            // Use expanded for subtitle to avoid overflow
                            child: Text(
                              item['subtitle']!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 36, // Fixed button height
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/products'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF6B4C9A),
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Shop Collection',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            // Reduced slightly height
            viewportFraction: 0.92,
            // Tighter viewport
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentCarouselIndex = index);
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselItems
              .asMap()
              .entries
              .map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselIndex == entry.key
                    ? AppColors.primaryColor
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Skincare', 'image': 'assets/images/c2.jpeg'},
      {'name': 'Makeup', 'image': 'assets/images/c5.png'},
      {'name': 'Face', 'image': 'assets/images/c1.jpg'},
      {
        'name': 'Body',
        'image': 'assets/images/home_image.jpeg'
      }, // Reusing home
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            'Shop by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.color,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final selectedCategory = categories[index]['name']!;
              return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/products',
                      arguments: {'category': selectedCategory}, // send category
                    );
                  },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(categories[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    categories[index]['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    // Simplified elegant features
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFeaturePill(Icons.verified_outlined, 'Authentic'),
          const SizedBox(width: 12),
          _buildFeaturePill(Icons.local_shipping_outlined, 'Fast Delivery'),
          const SizedBox(width: 12),
          _buildFeaturePill(Icons.headset_mic_outlined, '24/7 Support'),
          const SizedBox(width: 12),
          _buildFeaturePill(Icons.card_giftcard, 'Offers'),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme
              .of(context)
              .brightness == Brightness.dark
              ? Colors.grey[700]!
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme
              .of(context)
              .colorScheme
              .primary, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge
                  ?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivals() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        final products = provider.products.take(6).toList();
        if (products.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Arrivals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/products'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280, // Restored height for cards
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4),
                // Added vertical padding for shadow
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: ProductCard(
                      product: products[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: products[index],
                        );
                      },
                      onAddToCart: () async {
                        // Copy pasted cart logic for consistency (or could extract to helper)
                        try {
                          await Provider.of<CartProvider>(context,
                              listen: false)
                              .addToCart(products[index].id, 1);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Added to cart'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.purpleAccent,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle error
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}