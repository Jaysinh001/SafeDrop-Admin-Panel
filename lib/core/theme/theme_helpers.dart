// =============================================================================
// THEME HELPER METHODS
// =============================================================================

import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme_extension.dart';

class ThemeHelper {
  ThemeHelper._();

  // Get admin theme extension
  static AdminThemeExtension getAdminTheme(BuildContext context) {
    return Theme.of(context).extension<AdminThemeExtension>() ??
        AdminThemeExtension.light;
  }

  // Status color helpers
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'completed':
        return AppColors.success;
      case 'warning':
      case 'pending':
        return AppColors.warning;
      case 'error':
      case 'failed':
      case 'cancelled':
        return AppColors.error;
      case 'info':
      case 'processing':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  // Get status container color
  static Color getStatusContainerColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'completed':
        return AppColors.successContainer;
      case 'warning':
      case 'pending':
        return AppColors.warningContainer;
      case 'error':
      case 'failed':
      case 'cancelled':
        return AppColors.errorContainer;
      case 'info':
      case 'processing':
        return AppColors.infoContainer;
      default:
        return AppColors.surfaceContainer;
    }
  }

  // Chart color helper
  static Color getChartColor(int index) {
    return AppColors.chartColors[index % AppColors.chartColors.length];
  }

  // Priority color helper
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return AppColors.error;
      case 'medium':
      case 'normal':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }

  // Get text color based on background
  static Color getContrastTextColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? Colors.white : Colors.black87;
  }

  // Elevation shadow helper
  static List<BoxShadow> getElevationShadow(double elevation) {
    return [
      BoxShadow(
        color: AppColors.shadow.withOpacity(0.1),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }
}
