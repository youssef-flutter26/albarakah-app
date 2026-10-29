import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/product_card.dart';
import '../../cart/presentation/cart_page.dart';
import '../../products/presentation/data/product_model.dart';
import '../../products/presentation/product_details_page.dart';
import '../../wishlist/presentation/wishlist_page.dart';
import '../presentation/all_products_page.dart';
import '../../search/presentation/search_page.dart';
import '../../profile/presentation/profile_page.dart';

import '../data/home_cubit.dart';
import '../data/home_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  List<ProductModel> allProducts = [];
  List<ProductModel> displayedProducts = [];
  List<CategoryModel> categories = [];
  String selectedCategory = 'All';
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _filterByCategory(String category, {bool scrollToProducts = false}) {
    setState(() {
      selectedCategory = category;
      if (category.toLowerCase() == 'all') {
        displayedProducts = allProducts;
      } else {
        displayedProducts = allProducts.where((p) {
          return p.category.toLowerCase().contains(category.toLowerCase()) ||
              p.name.toLowerCase().contains(category.toLowerCase());
        }).toList();
      }
    });

    if (scrollToProducts && _scrollController.hasClients) {
      _scrollController.animateTo(
        420,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(context),
      const CartPage(),
      const WishlistPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[navIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141210),
          border: Border(
            top: BorderSide(color: AppTheme.gold.withOpacity(0.2), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: AppTheme.gold.withOpacity(0.25),
          selectedIndex: navIndex,
          onDestinationSelected: (index) => setState(() => navIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white60),
              selectedIcon: Icon(Icons.home_rounded, color: AppTheme.gold),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined, color: Colors.white60),
              selectedIcon:
                  Icon(Icons.shopping_bag_rounded, color: AppTheme.gold),
              label: 'Bag',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded, color: Colors.white60),
              selectedIcon: Icon(Icons.favorite_rounded, color: AppTheme.gold),
              label: 'Wishlist',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: Colors.white60),
              selectedIcon: Icon(Icons.person_rounded, color: AppTheme.gold),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ALBARAKAH',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: AppTheme.gold,
                fontSize: 20,
              ),
            ),
            Text(
              'THE ART OF FRAGRANCE',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 2,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B18),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
              icon: const Icon(Icons.search_rounded,
                  color: AppTheme.gold, size: 20),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12, left: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B18),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              icon: const Icon(Icons.person_outline_rounded,
                  color: AppTheme.gold, size: 20),
            ),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            setState(() {
              final combinedList = [
                ...state.homeData.featuredProducts,
                ...state.homeData.newArrivals,
              ];

              final uniqueMap = {for (var p in combinedList) p.id: p};
              allProducts = uniqueMap.values
                  .where((product) => product.image.isNotEmpty)
                  .toList();

              final uniqueCategories = combinedList
                  .map((p) => p.category)
                  .where((c) => c.isNotEmpty)
                  .toSet();
              categories = uniqueCategories
                  .map(
                      (name) => CategoryModel(id: name, name: name, slug: name))
                  .toList();

              if (selectedCategory == 'All') {
                displayedProducts = allProducts;
              } else {
                _filterByCategory(selectedCategory);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.gold),
            );
          } else if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 60, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.ink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<HomeCubit>().getHomeData();
                      },
                      child: const Text('Retry',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.gold,
            backgroundColor: const Color(0xFF1E1B18),
            onRefresh: () async {
              await context.read<HomeCubit>().getHomeData();
            },
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _hero(),
                const SizedBox(height: 28),
                _sectionTitle('Explore Collections'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        final selected = selectedCategory == 'All';
                        return _buildCategoryChip(
                            'All', selected, () => _filterByCategory('All'));
                      }
                      final category = categories[index - 1];
                      final selected = category.name == selectedCategory;
                      return _buildCategoryChip(category.name, selected,
                          () => _filterByCategory(category.name));
                    },
                  ),
                ),
                const SizedBox(height: 32),
                _sectionTitle(
                  'Bestsellers',
                  action: 'View All',
                  onActionTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllProductsPage(
                          title: 'Bestsellers',
                          products: allProducts,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                displayedProducts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No products found in this collection',
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayedProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: .66,
                        ),
                        itemBuilder: (_, index) {
                          final productModel = displayedProducts[index];
                          return ProductCard(
                            product: productModel,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsPage(product: productModel),
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 32),
                _collectionBanner(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.gold, AppTheme.gold.withOpacity(0.8)])
              : const LinearGradient(
                  colors: [Color(0xFF1E1B18), Color(0xFF1E1B18)]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.gold : AppTheme.gold.withOpacity(0.25),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.gold.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.ink : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF261D15), Color(0xFF12100E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.gold.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              Icons.spa_rounded,
              size: 250,
              color: AppTheme.gold.withOpacity(0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'EXCLUSIVE RELEASE',
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'THE OUD\nEDIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    height: 0.95,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Luxury fragrance crafted for unforgettable moments.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.ink,
                      elevation: 8,
                      shadowColor: AppTheme.gold.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      _filterByCategory('Oud', scrollToProducts: true);
                    },
                    child: const Text(
                      'SHOP COLLECTION',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title,
      {String? action, VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              action,
              style: const TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _collectionBanner() {
    return GestureDetector(
      onTap: () {
        _filterByCategory('Oud', scrollToProducts: true);
      },
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1B18),
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: AppTheme.gold.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ARABIAN SIGNATURES',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w900,
                color: AppTheme.gold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Oud. Amber. Rose.\nMade to leave a trace.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Text(
                  'Discover the signature collection',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded,
                    color: AppTheme.gold, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
