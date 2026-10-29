import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/product_card.dart';
import '../../../data/repositories/product_repository.dart';
import '../../home/data/home_api_service.dart';
import '../../products/presentation/data/product_model.dart';
import '../../products/presentation/product_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _repository = ProductRepository(HomeApiService(Apiclient()));
  final _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _repository.getFeaturedProducts();
      if (mounted) {
        setState(() {
          _allProducts = products.cast<ProductModel>();
          _filteredProducts = _allProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product.name.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppTheme.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          cursorColor: AppTheme.gold,
          decoration: const InputDecoration(
            hintText: 'Search for luxury fragrances...',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: AppTheme.gold, fontSize: 16),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppTheme.gold),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : _filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 80, color: AppTheme.gold.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      const Text(
                        'No fragrances found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Try searching with a different keyword',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .68,
                  ),
                  itemBuilder: (_, index) {
                    final product = _filteredProducts[index];
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
