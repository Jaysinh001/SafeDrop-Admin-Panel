import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utility/app_snackbar.dart';
import '../../../shared/widgets/screen_container.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/dependencies/injection_container.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: const _LoginViewStateful(),
    );
  }
}

class _LoginViewStateful extends StatefulWidget {
  const _LoginViewStateful();

  @override
  State<_LoginViewStateful> createState() => _LoginViewStatefulState();
}

class _LoginViewStatefulState extends State<_LoginViewStateful>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    context.read<LoginBloc>().add(LoginDemoCredentialsFilled());
    emailController.text = 'admin@example.com';
    passwordController.text = 'password123';
  }

  void _login() {
    if (formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginEmailChanged(emailController.text));
      context.read<LoginBloc>().add(
        LoginPasswordChanged(passwordController.text),
      );
      context.read<LoginBloc>().add(LoginSubmitted());
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _forgotPassword() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Forgot password functionality coming soon!'),
    //     backgroundColor: Colors.blue,
    //   ),
    // );

    AppSnackbar.info(context, "We are working on this feature", title:  'Coming Soon!');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Login successful!'),
          //     backgroundColor: Colors.green,
          //     duration: Duration(seconds: 3),
          //   ),
          // );

          AppSnackbar.success(context, "Login Successful!");
          context.go(AppRoutes.dashboard);
        }
      },
      child: Scaffold(
        body: ResponsiveScreenContainer(
          backgroundColor: _getBackgroundColor(context),
          mobileLayout: _buildMobileLayout(),
          tabletLayout: _buildTabletLayout(),
          desktopLayout: _buildDesktopLayout(),
          child: _buildDefaultLayout(),
        ),
        floatingActionButton:
            kDebugMode
                ? FloatingActionButton.small(
                  onPressed: _fillDemoCredentials,
                  tooltip: 'Fill demo credentials',
                  child: const Icon(Icons.person),
                )
                : null,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return const Color(0xFF1a1a2e);
    }
    return Colors.white;
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
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

  Widget _buildTabletLayout() {
    return Center(
      child: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
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

  Widget _buildDesktopLayout() {
    return Row(
      children: [
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
              animation: fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
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
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Manage your application with ease',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white.withOpacity(0.8)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: AnimatedBuilder(
                  animation: fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation,
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
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDesktop ? Colors.grey[800] : null,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<LoginBloc, LoginState>(
            buildWhen:
                (previous, current) =>
                    previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              if (state.errorMessage != null) {
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
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => context.read<LoginBloc>().add(
                              LoginErrorCleared(),
                            ),
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
            },
          ),
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
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen:
          (previous, current) =>
              previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return TextFormField(
          controller: passwordController,
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _login(),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed:
                  () => context.read<LoginBloc>().add(
                    LoginPasswordVisibilityToggled(),
                  ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: _validatePassword,
        );
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen:
          (previous, current) => previous.rememberMe != current.rememberMe,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.rememberMe,
              onChanged:
                  (value) => context.read<LoginBloc>().add(
                    LoginRememberMeToggled(value ?? false),
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text('Remember me'),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isLoading ? null : _login,
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
              state.isLoading
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
      },
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: _forgotPassword,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Color(0xFF667eea), fontWeight: FontWeight.w500),
      ),
    );
  }
}
