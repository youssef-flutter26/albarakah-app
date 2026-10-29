import 'package:alberaperfume/features/products/presentation/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/product_card.dart';
import '../../products/presentation/data/product_model.dart';
import '../../wishlist/presentation/wishlist_controller.dart';
import '../../home/data/home_model.dart';

class AllProductsPage extends StatelessWidget {
  final String title;
  final List<ProductModel> products;

  const AllProductsPage({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppTheme.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppTheme.gold,
            fontSize: 18,
          ),
        ),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .68,
              ),
              itemBuilder: (_, index) {
                final product = products[index];
                final wishlist = context.watch<WishlistController>();
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(product: product),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
