import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:alberaperfume/features/wishlist/data/wishlist_cubit.dart';
import 'package:alberaperfume/features/wishlist/data/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/products/presentation/data/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String imageUrl = product.image;
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'https://albara-perfume.com$imageUrl';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1B18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(Icons.image_outlined,
                                  size: 50, color: Colors.white54),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.white54),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, wishlistState) {
                        bool isFavorite = false;
                        if (wishlistState is WishlistLoaded) {
                          isFavorite = wishlistState.items.any(
                            (item) =>
                                item.id.toString() == product.id.toString(),
                          );
                        }

                        return CircleAvatar(
                          backgroundColor: AppTheme.ink.withOpacity(0.8),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite ? Colors.redAccent : AppTheme.gold,
                              size: 20,
                            ),
                            onPressed: () {
                              context
                                  .read<WishlistCubit>()
                                  .toggleWishlist(product.id.toString());
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'INR ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
