import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/local_storage/hive_boxes.dart';
import '../../../core/data/local_storage/local_storage_service.dart';
import '../../../core/data/local_storage/storage_keys.dart';
import '../../../core/dependencies/injection_container.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particlesController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoController.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    final storage = sl<LocalStorageService>();

    await Future.delayed(const Duration(seconds: 3));

    final accessToken = storage.read(
      box: HiveBoxes.authBox,
      key: StorageKeys.accessToken,
    );
    final saveSession = storage.read(
      box: HiveBoxes.authBox,
      key: StorageKeys.saveSession,
    );


    if (accessToken != null && saveSession == true && mounted) {
      context.go(AppRoutes.dashboard);
    } else {
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Animated particles
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return Stack(
                children: List.generate(
                  8,
                  (index) => _floatingParticle(size, index),
                ),
              );
            },
          ),

          /// Logo section
          Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Logo container
                    Container(
                      width: size.width * 0.22,
                      height: size.width * 0.22,
                      constraints: const BoxConstraints(
                        maxWidth: 140,
                        maxHeight: 140,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// App Name
                    Text(
                      "SAFEDROP",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Tagline
                    Text(
                      "Smart Transport Management",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.8),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Loader
                    const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingParticle(Size size, int index) {
    final random = Random(index);

    final top = size.height * random.nextDouble();
    final left = size.width * random.nextDouble();

    final radius = random.nextDouble() * 50 + 20;

    return Positioned(
      top: top,
      left: left,
      child: Transform.translate(
        offset: Offset(
          sin(_particlesController.value * 2 * pi + index) * 18,
          cos(_particlesController.value * 2 * pi + index) * 18,
        ),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface.withOpacity(0.08),
          ),
        ),
      ),
    );
  }
}
