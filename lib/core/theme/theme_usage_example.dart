// =============================================================================
// USAGE EXAMPLES AND UTILITIES
// =============================================================================

// Example of how to use the theme system in your widgets
import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme_helpers.dart';

class ThemeUsageExamples {
  // Status chip widget
  static Widget statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ThemeHelper.getStatusContainerColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: ThemeHelper.getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Priority indicator
  static Widget priorityIndicator(String priority) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: ThemeHelper.getPriorityColor(priority),
        shape: BoxShape.circle,
      ),
    );
  }

  // Gradient button
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    Gradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ThemeHelper.getElevationShadow(2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // Admin card with proper styling
  static Widget adminCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
