import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'auth_state.dart';
import 'auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  // 1. Login
  Future<void> login(
      {required String identifier, required String password}) async {
    emit(AuthLoading());
    try {
      final model = await authRepository.login(
        identifier: identifier,
        password: password,
      );
      emit(AuthSuccess(model, 'Login successful'));
    } catch (e) {
      if (e is DioException) {
        print('Server Response error: ${e.response?.data}');
      }
      emit(AuthError(e.toString()));
    }
  }

  // 2. Register (يدعم الـ Named Parameters المباشرة لتفادي إيرور الشاشة)
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      final model = await authRepository.register({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      emit(AuthSuccess(model, 'Registration successful'));
    } catch (e) {
      if (e is DioException) {
        print('Server Response error: ${e.response?.data}');
      }
      emit(AuthError(e.toString()));
    }
  }

  // 3. Send OTP
  Future<void> sendOtp({
    required String phone,
    required String purpose,
  }) async {
    emit(AuthLoading());
    try {
      emit(OtpSentState('OTP sent successfully'));
    } catch (e) {
      if (e is DioException) {
        print('Server Response error: ${e.response?.data}');
      }
      emit(AuthError(e.toString()));
    }
  }

  // 4. Verify OTP
  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required String purpose,
  }) async {
    emit(AuthLoading());
    try {
      final model = await authRepository.verifyotp(phone, otp, purpose);
      emit(AuthSuccess(model, 'Successfully verified'));
    } catch (e) {
      if (e is DioException) {
        print('Server Response error: ${e.response?.data}');
      }
      emit(AuthError(e.toString()));
    }
  }

  // 5. Reset Password
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(token, password);
      emit(OtpSentState('Successfully reset password'));
    } catch (e) {
      if (e is DioException) {
        print('Server Response error: ${e.response?.data}');
      }
      emit(AuthError(e.toString()));
    }
  }
}
