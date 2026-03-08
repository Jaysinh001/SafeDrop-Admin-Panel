import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool rememberMe;
  final String? errorMessage;
  final bool isSuccess;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.rememberMe = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? rememberMe,
    String? errorMessage,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordVisible,
    isLoading,
    rememberMe,
    errorMessage,
    isSuccess,
  ];
}
