import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/local_storage/hive_boxes.dart';
import '../../../core/data/local_storage/local_storage_service.dart';
import '../../../core/data/local_storage/storage_keys.dart';
import '../repo/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final LocalStorageService storage;

  LoginBloc({required this.authRepository, required this.storage})
    : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginRememberMeToggled>(_onRememberMeToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginErrorCleared>(_onErrorCleared);
    on<LoginDemoCredentialsFilled>(_onDemoCredentialsFilled);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onRememberMeToggled(
    LoginRememberMeToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.value));
  }

  void _onErrorCleared(LoginErrorCleared event, Emitter<LoginState> emit) {
    emit(state.copyWith(clearError: true));
  }

  void _onDemoCredentialsFilled(
    LoginDemoCredentialsFilled event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        email: 'admin@example.com',
        password: 'password123',
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(errorMessage: emailError ?? passwordError));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final res = await authRepository.login(
        email: state.email,
        password: state.password,
      );

      log("response : ${res.data.toString()}");
      if (res.success) {

        if (state.rememberMe) {
           await storage.write(
          box: HiveBoxes.authBox,
          key: StorageKeys.saveSession,
          value: true,
        );
        }

        await storage.write(
          box: HiveBoxes.authBox,
          key: StorageKeys.accessToken,
          value: res.data["token"],
        );

        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid email or password',
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred. Please try again.',
        ),
      );
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
