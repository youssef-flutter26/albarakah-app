import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_model.dart';
import 'home_repo.dart';

// --- States ---
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeData homeData;
  HomeLoaded(this.homeData);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// --- Cubit ---
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());
    try {
      // تم إلغاء الـ timeout القصير والاحتفاظ بالبيانات القادمة من السيرفر
      final homeData = await _homeRepository.fetchHomeContent();
      print(
          '✅ [HOME CUBIT LOADED]: ${homeData.featuredProducts.length} Featured Products');
      emit(HomeLoaded(homeData));
    } catch (e) {
      print('❌ [HOME CUBIT CATCH ERROR]: $e');
      emit(HomeError(e.toString()));
    }
  }
}
