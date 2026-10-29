import 'package:alberaperfume/core/storage/shared_pref.dart';
import 'package:alberaperfume/features/my_order.dart/data/order_cubit.dart';
import 'package:alberaperfume/features/my_order.dart/data/order_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'features/cart/presentation/cart_controller.dart';
import 'features/editProfile/data/edit_profile_cubit.dart';
import 'features/editProfile/data/edit_profile_repo.dart';
import 'features/editProfile/data/edit_profile_service.dart';
import 'features/wishlist/presentation/wishlist_controller.dart';
import 'features/auth/data/api_auth_service.dart';
import 'features/auth/data/auth_cubit.dart';
import 'features/auth/data/auth_repo.dart';
import 'features/home/data/home_api_service.dart';
import 'features/home/data/home_cubit.dart';
import 'features/home/data/home_repo.dart';
import 'features/cart/data/cart_api_service.dart';
import 'features/cart/data/cart_cubit.dart';
import 'features/cart/data/cart_repo.dart';
import 'features/wishlist/data/wishlist_api_service.dart';
import 'features/wishlist/data/wishlist_cubit.dart';
import 'features/wishlist/data/wishlist_repo.dart';
import 'features/products/presentation/data/product_api_service.dart';
import 'features/products/presentation/data/product_cubit.dart';
import 'features/products/presentation/data/product_repo.dart';
import 'features/profile/data/profile_repo.dart';
import 'features/profile/data/profile_cubit.dart';
import 'features/payment/data/payment_api_service.dart';
import 'features/payment/data/payment_repo.dart';
import 'features/payment/data/payment_cubit.dart';
import 'features/shippingAddresses/data/shipping_api_service.dart';
import 'features/shippingAddresses/data/shipping_cubit.dart';
import 'features/shippingAddresses/data/shipping_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('1 - Binding OK');

  try {
    await dotenv.load(fileName: '.env', isOptional: true);
    debugPrint('2 - Dotenv OK');
  } catch (e) {
    debugPrint('Dotenv loading exception: $e');
  }

  final storage = LocalStorage();
  await storage.init();
  debugPrint('3 - Storage OK');

  // تهيئة الـ SharedPreferences هنا لمنع خطأ الـ LateInitializationError
  await SharedPref.init();
  debugPrint('3.1 - SharedPreferences Init OK');

  final apiclient = Apiclient();
  debugPrint('4 - ApiClient OK');

  final authApiService = AuthApiService(apiclient);
  final authRepo = AuthRepository(apiservice: authApiService);
  final homeApiService = HomeApiService(apiclient);
  final homeRepo = HomeRepository(homeApiService);
  final cartApiService = CartApiService(apiclient);
  final cartRepo = CartRepository(cartApiService);
  final wishlistApiService = WishlistApiService(apiclient);
  final wishlistRepo = WishlistRepository(wishlistApiService);
  final productApiService = ProductApiService(apicliemt: apiclient);
  final productRepo = ProductRepo(apiservice: productApiService);
  final profileRepo = ProfileRepository(apiclient);
  final editProfileApiService = EditProfileService(apiclient);
  final editProfileRepo = EditProfileRepository(editProfileApiService);
  final orderRepo = OrderRepository(apiclient);
  final paymentApiService = PaymentApiService(apiclient);
  final paymentRepo = PaymentRepo(paymentApiService);
  final shippingApiService = ShippingApiService(apiclient);
  final shippingRepo = ShippingRepo(shippingApiService);

  debugPrint('5 - All Repos OK - About to runApp');

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storage),
        Provider.value(value: apiclient),
        ChangeNotifierProvider(create: (_) => CartController(storage)),
        ChangeNotifierProvider(create: (_) => WishlistController(storage)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepository: authRepo)),
          BlocProvider<HomeCubit>(create: (context) => HomeCubit(homeRepo)),
          BlocProvider<CartCubit>(create: (context) => CartCubit(cartRepo)),
          BlocProvider<WishlistCubit>(
              create: (context) => WishlistCubit(wishlistRepo)),
          BlocProvider<ProductCubit>(
              create: (context) => ProductCubit(repo: productRepo)),
          BlocProvider<ProfileCubit>(
              create: (context) => ProfileCubit(profileRepo)),
          BlocProvider<EditProfileCubit>(
              create: (context) => EditProfileCubit(editProfileRepo)),
          BlocProvider<OrderCubit>(create: (context) => OrderCubit(orderRepo)),
          BlocProvider<PaymentCubit>(
              create: (context) => PaymentCubit(paymentRepo)),
          BlocProvider<ShippingCubit>(
              create: (context) => ShippingCubit(shippingRepo)),
        ],
        child: const AlberaApp(),
      ),
    ),
  );
}
