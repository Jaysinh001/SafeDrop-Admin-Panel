// =============================================================================
// THEME EXTENSIONS - Custom theme properties
// =============================================================================

import 'package:flutter/material.dart';

import 'colors.dart';

@immutable
class AdminThemeExtension extends ThemeExtension<AdminThemeExtension> {
  const AdminThemeExtension({
    required this.sidebarBackground,
    required this.sidebarSelectedItem,
    required this.sidebarHoverItem,
    required this.sidebarText,
    required this.sidebarSelectedText,
    required this.chartColors,
  });

  final Color sidebarBackground;
  final Color sidebarSelectedItem;
  final Color sidebarHoverItem;
  final Color sidebarText;
  final Color sidebarSelectedText;
  final List<Color> chartColors;

  @override
  AdminThemeExtension copyWith({
    Color? sidebarBackground,
    Color? sidebarSelectedItem,
    Color? sidebarHoverItem,
    Color? sidebarText,
    Color? sidebarSelectedText,
    List<Color>? chartColors,
  }) {
    return AdminThemeExtension(
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      sidebarSelectedItem: sidebarSelectedItem ?? this.sidebarSelectedItem,
      sidebarHoverItem: sidebarHoverItem ?? this.sidebarHoverItem,
      sidebarText: sidebarText ?? this.sidebarText,
      sidebarSelectedText: sidebarSelectedText ?? this.sidebarSelectedText,
      chartColors: chartColors ?? this.chartColors,
    );
  }

  @override
  AdminThemeExtension lerp(
    ThemeExtension<AdminThemeExtension>? other,
    double t,
  ) {
    if (other is! AdminThemeExtension) {
      return this;
    }
    return AdminThemeExtension(
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
      sidebarSelectedItem:
          Color.lerp(sidebarSelectedItem, other.sidebarSelectedItem, t)!,
      sidebarHoverItem:
          Color.lerp(sidebarHoverItem, other.sidebarHoverItem, t)!,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t)!,
      sidebarSelectedText:
          Color.lerp(sidebarSelectedText, other.sidebarSelectedText, t)!,
      chartColors: chartColors, // Colors don't lerp well in lists
    );
  }

  static const AdminThemeExtension light = AdminThemeExtension(
    sidebarBackground: AppColors.sidebarBackground,
    sidebarSelectedItem: AppColors.sidebarSelectedItem,
    sidebarHoverItem: AppColors.sidebarHoverItem,
    sidebarText: AppColors.sidebarText,
    sidebarSelectedText: AppColors.sidebarSelectedText,
    chartColors: AppColors.chartColors,
  );

  static const AdminThemeExtension dark = AdminThemeExtension(
    sidebarBackground: AppColors.darkBackground,
    sidebarSelectedItem: AppColors.primaryDark,
    sidebarHoverItem: AppColors.darkSurfaceContainer,
    sidebarText: AppColors.darkOnBackground,
    sidebarSelectedText: AppColors.primaryLight,
    chartColors: AppColors.chartColors,
  );
}
