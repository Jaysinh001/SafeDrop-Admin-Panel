import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
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
    emailController.text = 'sanjay.nandan@capgemini.com';
    passwordController.text = 'Password123!';
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
    AppSnackbar.info(
      context,
      "We are working on this feature",
      title: 'Coming Soon!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen:
          (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
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
    final colorScheme = Theme.of(context).colorScheme;
    if (width >= 1024) {
      // Desktop: use primary color gradient background
      return colorScheme.surface;
    }
    return colorScheme.surface;
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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, AppColors.primaryLight],
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
            color: colorScheme.surface,
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
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            AppColors.primaryLight,
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDesktop ? Colors.white : colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginForm() {
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme.error.withOpacity(0.1),
                    border: Border.all(
                      color: colorScheme.error.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => context.read<LoginBloc>().add(
                              LoginErrorCleared(),
                            ),
                        child: Icon(
                          Icons.close,
                          color: colorScheme.error,
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
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surfaceContainer,
      ),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    final colorScheme = Theme.of(context).colorScheme;

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
            fillColor: colorScheme.surfaceContainer,
          ),
          validator: _validatePassword,
        );
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    final colorScheme = Theme.of(context).colorScheme;

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
            Text('Remember me', style: TextStyle(color: colorScheme.onSurface)),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton() {
    final colorScheme = Theme.of(context).colorScheme;

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
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 2,
          ),
          child:
              state.isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: _forgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
