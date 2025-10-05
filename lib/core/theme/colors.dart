import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/error_screens.dart';
import '../routes/app_routes.dart';
import '../routes/route.dart';

// =============================================================================
// APP COLORS - Centralized color palette for the admin panel
// =============================================================================

class AppColors {
  AppColors._();

  // =======================================================================
  // PRIMARY COLORS
  // =======================================================================
  static const Color primary = Color(0xFF667eea);
  static const Color primaryDark = Color(0xFF5a67d8);
  static const Color primaryLight = Color(0xFF7c3aed);
  static const Color primaryContainer = Color(0xFFe0e7ff);

  // Secondary/Accent Colors
  static const Color secondary = Color(0xFF764ba2);
  static const Color secondaryDark = Color(0xFF6b46c1);
  static const Color secondaryLight = Color(0xFF8b5cf6);
  static const Color secondaryContainer = Color(0xFFede9fe);

  // =======================================================================
  // SURFACE COLORS
  // =======================================================================
  static const Color surface = Color(0xFFffffff);
  static const Color surfaceDim = Color(0xFFf8fafc);
  static const Color surfaceBright = Color(0xFFffffff);
  static const Color surfaceContainer = Color(0xFFf1f5f9);
  static const Color surfaceContainerHigh = Color(0xFFe2e8f0);
  static const Color surfaceContainerHighest = Color(0xFFcbd5e1);

  // Background Colors
  static const Color background = Color(0xFFfafafa);
  static const Color backgroundSecondary = Color(0xFFf5f5f5);

  // =======================================================================
  // TEXT COLORS
  // =======================================================================
  static const Color onSurface = Color(0xFF0f172a);
  static const Color onSurfaceVariant = Color(0xFF64748b);
  static const Color onBackground = Color(0xFF1e293b);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color onSecondary = Color(0xFFffffff);

  // Text Variations
  static const Color textPrimary = Color(0xFF1e293b);
  static const Color textSecondary = Color(0xFF64748b);
  static const Color textTertiary = Color(0xFF94a3b8);
  static const Color textDisabled = Color(0xFFcbd5e1);

  // =======================================================================
  // STATUS COLORS
  // =======================================================================
  static const Color success = Color(0xFF10b981);
  static const Color successLight = Color(0xFF34d399);
  static const Color successDark = Color(0xFF059669);
  static const Color successContainer = Color(0xFFd1fae5);
  static const Color onSuccess = Color(0xFFffffff);

  static const Color warning = Color(0xFFf59e0b);
  static const Color warningLight = Color(0xFFfbbf24);
  static const Color warningDark = Color(0xFFd97706);
  static const Color warningContainer = Color(0xFFfef3c7);
  static const Color onWarning = Color(0xFFffffff);

  static const Color error = Color(0xFFef4444);
  static const Color errorLight = Color(0xFFf87171);
  static const Color errorDark = Color(0xFFdc2626);
  static const Color errorContainer = Color(0xFFfee2e2);
  static const Color onError = Color(0xFFffffff);

  static const Color info = Color(0xFF3b82f6);
  static const Color infoLight = Color(0xFF60a5fa);
  static const Color infoDark = Color(0xFF2563eb);
  static const Color infoContainer = Color(0xFFdbeafe);
  static const Color onInfo = Color(0xFFffffff);

  // =======================================================================
  // NEUTRAL COLORS
  // =======================================================================
  static const Color outline = Color(0xFFd1d5db);
  static const Color outlineVariant = Color(0xFFe5e7eb);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF1e293b);
  static const Color onInverseSurface = Color(0xFFf1f5f9);

  // =======================================================================
  // DARK MODE COLORS
  // =======================================================================
  static const Color darkSurface = Color(0xFF0f172a);
  static const Color darkSurfaceContainer = Color(0xFF1e293b);
  static const Color darkBackground = Color(0xFF020617);
  static const Color darkOnSurface = Color(0xFFf8fafc);
  static const Color darkOnBackground = Color(0xFFe2e8f0);
  static const Color darkOutline = Color(0xFF475569);

  // =======================================================================
  // SIDEBAR COLORS
  // =======================================================================
  static const Color sidebarBackground = Color(0xFF1e293b);
  static const Color sidebarSelectedItem = Color(0xFF334155);
  static const Color sidebarHoverItem = Color(0xFF475569);
  static const Color sidebarText = Color(0xFFe2e8f0);
  static const Color sidebarSelectedText = Color(0xFFffffff);

  // =======================================================================
  // CARD COLORS
  // =======================================================================
  static const Color cardBackground = Color(0xFFffffff);
  static const Color cardBorder = Color(0xFFe2e8f0);
  static const Color cardShadow = Color(0x0f000000);

  // =======================================================================
  // CHART COLORS
  // =======================================================================
  static const List<Color> chartColors = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF10b981),
    Color(0xFFf59e0b),
    Color(0xFFef4444),
    Color(0xFF3b82f6),
    Color(0xFF8b5cf6),
    Color(0xFFec4899),
  ];

  // =======================================================================
  // GRADIENT COLORS
  // =======================================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surfaceDim],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// =============================================================================
// COMPLETE THEME SETUP FOR MAIN APP
// =============================================================================

class ThemedApp extends StatelessWidget {
  const ThemedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Admin Panel',

      // Routes
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      unknownRoute: GetPage(
        name: AppRoutes.notFound,
        page: () => const NotFoundScreen(),
      ),
    );
  }
}
