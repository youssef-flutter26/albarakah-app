import 'package:alberaperfume/features/products/presentation/data/product_cubit.dart';
import 'package:alberaperfume/features/products/presentation/data/product_model.dart';
import 'package:alberaperfume/features/products/presentation/data/product_state.dart';
import 'package:alberaperfume/features/wishlist/data/wishlist_cubit.dart';
import 'package:alberaperfume/features/wishlist/data/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String selectedSize;
  late num currentPrice;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.sizeLabel.isNotEmpty
        ? widget.product.sizeLabel
        : '100 ML';
    currentPrice = widget.product.price;
  }

  void _updateSizeAndPrice(String size) {
    setState(() {
      selectedSize = size;
      if (size == '50 ML') {
        currentPrice = widget.product.price * 0.6;
      } else {
        currentPrice = widget.product.price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ProductActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductActionLoading;

        return Scaffold(
          backgroundColor: AppTheme.ink,
          appBar: AppBar(
            backgroundColor: AppTheme.ink,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.gold),
            title: const Text(
              'Product Details',
              style:
                  TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold),
            ),
            actions: [
              BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, wishlistState) {
                  bool isInWishlist = false;
                  if (wishlistState is WishlistLoaded) {
                    isInWishlist = wishlistState.items
                        .any((item) => item.id == widget.product.id);
                  }

                  return IconButton(
                    onPressed: () {
                      context
                          .read<WishlistCubit>()
                          .toggleWishlist(widget.product.id);
                    },
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist ? Colors.redAccent : AppTheme.gold,
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: widget.product.image,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const Center(
                      child: Icon(Icons.image_outlined,
                          size: 70, color: Colors.white54)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.slug.toUpperCase(),
                      style: const TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _sizeChip('50 ML'),
                        const SizedBox(width: 12),
                        _sizeChip('100 ML'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'INR ${currentPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.gold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.product.description.isNotEmpty
                          ? widget.product.description
                          : 'Luxury fragrance crafted with exquisite notes for unforgettable moments.',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 28),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.gold,
                            ),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              foregroundColor: AppTheme.ink,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              context.read<ProductCubit>().addToCart(
                                    slug: widget.product.slug,
                                    qty: 1,
                                  );
                            },
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: const Text(
                              'ADD TO BAG',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sizeChip(String size) {
    final isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => _updateSizeAndPrice(size),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold : const Color(0xFF1E1B18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.gold : AppTheme.gold.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? AppTheme.ink : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
