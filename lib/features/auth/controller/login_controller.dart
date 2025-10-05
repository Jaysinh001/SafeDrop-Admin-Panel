// =============================================================================
// GetX Controller for Login Logic
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _rememberMe = false.obs;
  final _errorMessage = Rx<String?>(null);

  // Animation controllers
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  // Getters for reactive variables
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  bool get rememberMe => _rememberMe.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fadeController.dispose();
    super.onClose();
  }

  void _setupAnimations() {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeOutCubic),
    );

    fadeController.forward();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    _rememberMe.value = value ?? false;
  }

  // Clear error message
  void clearError() {
    _errorMessage.value = null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Main login method
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      if (emailController.text == 'admin@example.com' &&
          passwordController.text == 'password123') {
        // Success - Show success message and navigate
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Store remember me preference if needed
        if (_rememberMe.value) {
          // Here you would typically save to GetStorage or SharedPreferences
          print('Remember me enabled');
        }

        // Navigate to dashboard (replace with your route)
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        _errorMessage.value = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage.value = 'An error occurred. Please try again.';
      print('Login error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Forgot password method
  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Forgot password functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Auto-fill demo credentials (for development)
  void fillDemoCredentials() {
    emailController.text = 'admin@example.com';
    passwordController.text = 'password123';
  }
}
