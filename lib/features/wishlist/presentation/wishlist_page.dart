import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/product_card.dart';
import '../../products/presentation/data/product_model.dart';
import '../data/wishlist_cubit.dart';
import '../data/wishlist_state.dart';
import '../../products/presentation/product_details_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'FAVORITES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppTheme.gold,
          ),
        ),
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.gold),
            );
          } else if (state is WishlistError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            );
          } else if (state is WishlistLoaded) {
            final wishlistProducts = state.items.map((item) {
              String img = item.image?.toString().trim() ?? '';

              if (img.isNotEmpty) {
                if (img.startsWith('http://') || img.startsWith('https://')) {
                  // رابط كامل جاهز زي Cloudinary مش بنلعب فيه
                } else {
                  if (!img.startsWith('/')) {
                    img = '/$img';
                  }
                  // استخدام الدومين الصحيح المأخوذ من الـ API الأساسي (albarakah.me)
                  img = 'https://albarakah.me$img';
                }
              } else {
                img = '';
              }

              double parsedPrice = 0.0;
              if (item.price != null) {
                parsedPrice = double.tryParse(item.price.toString()) ?? 0.0;
              }

              return ProductModel(
                id: item.id?.toString() ?? '',
                name: item.name ?? 'Luxury Fragrance',
                slug: item.slug ?? '',
                subtitle: item.subtitle ?? '',
                image: img,
                price: parsedPrice,
                compareAtPrice: 0.0,
                brand: '',
                inStock: item.inStock ?? true,
                sizeLabel: '100 ML',
                category: '',
                available: true,
                related: [],
                description: '',
                stock: 10,
              );
            }).toList();

            if (wishlistProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 80,
                      color: AppTheme.gold.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your Wishlist is Empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save your favorite luxury fragrances here',
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .68,
              ),
              itemBuilder: (_, index) {
                final product = wishlistProducts[index];
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
