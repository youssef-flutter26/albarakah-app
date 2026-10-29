import 'auth_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthModel authModel;
  final String message;
  AuthSuccess(this.authModel, this.message);
}

class OtpSentState extends AuthState {
  final String message;
  OtpSentState(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
