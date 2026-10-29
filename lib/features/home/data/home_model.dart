import '../../products/presentation/data/product_model.dart';

class HomeResponseModel {
  final bool success;
  final String message;
  final HomeData? data;

  HomeResponseModel({
    required this.success,
    this.message = '',
    this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map
          ? HomeData.fromJson(Map<String, dynamic>.from(json['data'] as Map))
          : null,
    );
  }
}

class HomeData {
  final List<ProductModel> featuredProducts;
  final List<ProductModel> newArrivals;
  final List<dynamic> offers;
  final List<BlogModel> blogs;
  final String currency;

  HomeData({
    required this.featuredProducts,
    required this.newArrivals,
    required this.offers,
    required this.blogs,
    required this.currency,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    List<ProductModel> parseProducts(dynamic list) {
      if (list is! List) return [];
      List<ProductModel> items = [];
      for (var item in list) {
        try {
          if (item != null && item is Map) {
            items.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
          }
        } catch (e) {
          print('⚠️ [PRODUCT PARSE ERROR]: $e');
        }
      }
      return items;
    }

    List<BlogModel> parseBlogs(dynamic list) {
      if (list is! List) return [];
      List<BlogModel> items = [];
      for (var item in list) {
        try {
          if (item != null && item is Map) {
            items.add(BlogModel.fromJson(Map<String, dynamic>.from(item)));
          }
        } catch (e) {
          print('⚠️ [BLOG PARSE ERROR]: $e');
        }
      }
      return items;
    }

    return HomeData(
      featuredProducts: parseProducts(json['featuredProducts']),
      newArrivals: parseProducts(json['newArrivals']),
      offers: json['offers'] is List ? List<dynamic>.from(json['offers']) : [],
      blogs: parseBlogs(json['blogs']),
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

class BlogModel {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String image;
  final String category;
  final int readingMinutes;

  BlogModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.image,
    required this.category,
    required this.readingMinutes,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      excerpt: json['excerpt']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      readingMinutes:
          int.tryParse(json['readingMinutes']?.toString() ?? '') ?? 1,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}
