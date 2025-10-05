import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/screen_container.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveScreenContainer(
        backgroundColor: _getBackgroundColor(context),
        mobileLayout: _buildMobileLayout(),
        tabletLayout: _buildTabletLayout(),
        desktopLayout: _buildDesktopLayout(),
        child: _buildDefaultLayout(),
      ),
      // Floating action button for demo credentials (only in debug mode)
      floatingActionButton:
          kDebugMode
              ? FloatingActionButton.small(
                onPressed: controller.fillDemoCredentials,
                tooltip: 'Fill demo credentials',
                child: const Icon(Icons.person),
              )
              : null,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (context.isWeb || context.isDesktop) {
      return const Color(0xFF1a1a2e);
    }
    return Colors.white;
  }

  // Mobile Layout - Full screen form
  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: controller.fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(size: 100),
                    const SizedBox(height: 40),
                    _buildTitle('Admin Portal'),
                    const SizedBox(height: 8),
                    _buildSubtitle('Sign in to continue'),
                    const SizedBox(height: 40),
                    _buildLoginForm(),
                    const SizedBox(height: 20),
                    _buildForgotPasswordLink(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Tablet Layout - Centered card
  Widget _buildTabletLayout() {
    return Center(
      child: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: controller.fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: Container(
                  width: 500,
                  margin: const EdgeInsets.all(32),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogo(size: 80),
                          const SizedBox(height: 32),
                          _buildTitle('Admin Portal'),
                          const SizedBox(height: 8),
                          _buildSubtitle('Welcome back'),
                          const SizedBox(height: 32),
                          _buildLoginForm(),
                          const SizedBox(height: 20),
                          _buildForgotPasswordLink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Desktop Layout - Split screen with branding
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: AnimatedBuilder(
              animation: controller.fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 120,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Admin Dashboard',
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Manage your application with ease',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: AnimatedBuilder(
                  animation: controller.fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: SlideTransition(
                        position: controller.slideAnimation,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildTitle('Sign In'),
                              const SizedBox(height: 8),
                              _buildSubtitle('Enter your credentials'),
                              const SizedBox(height: 40),
                              _buildLoginForm(),
                              const SizedBox(height: 20),
                              _buildForgotPasswordLink(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultLayout() {
    return _buildMobileLayout();
  }

  Widget _buildLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(size / 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.admin_panel_settings,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: Get.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Get.context!.isDesktop ? Colors.grey[800] : null,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Error message display
          Obx(() {
            if (controller.errorMessage != null) {
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.clearError,
                      child: Icon(
                        Icons.close,
                        color: Colors.red[700],
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildRememberMeCheckbox(),
          const SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: controller.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => controller.login(),
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: controller.validatePassword,
      );
    });
  }

  Widget _buildRememberMeCheckbox() {
    return Obx(() {
      return Row(
        children: [
          Checkbox(
            value: controller.rememberMe,
            onChanged: controller.toggleRememberMe,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Text('Remember me'),
        ],
      );
    });
  }

  Widget _buildLoginButton() {
    return Obx(() {
      return ElevatedButton(
        onPressed: controller.isLoading ? null : controller.login,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        child:
            controller.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
      );
    });
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: controller.forgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: const Color(0xFF667eea),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
