// =============================================================================
// SNACKBAR UTILITY
// SafeDrop Organization Admin Panel
//
// Platform-aware, responsive snackbar system.
//
// Positioning logic:
//   Desktop (Windows / macOS) → top-right corner overlay
//   Tablet  (width ≥ Breakpoints.tablet)  → top-center overlay
//   Mobile  (iOS / Android)   → bottom-center (system SnackBar)
//
// Usage:
//   AppSnackbar.success(context, 'Student enrolled successfully.');
//   AppSnackbar.error(context, 'Failed to fetch billing cycles.');
//   AppSnackbar.warning(context, 'Penalty rule already exists.');
//   AppSnackbar.info(context, 'Live tracking session started.');
//   AppSnackbar.show(
//     context,
//     message: 'Custom message',
//     type: SnackbarType.success,
//     action: SnackbarAction(label: 'Undo', onPressed: () {}),
//   );
// =============================================================================

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';



// -----------------------------------------------------------------------------
// ENUMS
// -----------------------------------------------------------------------------

enum SnackbarType { success, error, warning, info }

enum _SnackbarPlatform { desktopOverlay, tabletOverlay, mobileSystem }

// -----------------------------------------------------------------------------
// ACTION MODEL
// -----------------------------------------------------------------------------

class SnackbarAction {
  final String label;
  final VoidCallback onPressed;

  const SnackbarAction({
    required this.label,
    required this.onPressed,
  });
}

// -----------------------------------------------------------------------------
// INTERNAL CONFIG
// Maps SnackbarType → AppColors tokens (light + dark)
// -----------------------------------------------------------------------------

class _SnackbarConfig {
  final Color background;
  final Color foreground;
  final Color accent; // left bar + icon + action text
  final Color subtleBorder; // thin border on top/right/bottom

  const _SnackbarConfig({
    required this.background,
    required this.foreground,
    required this.accent,
    required this.subtleBorder,
  });

  static _SnackbarConfig resolve(SnackbarType type, bool isDark) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          background: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.successContainer,
          foreground: isDark ? AppColors.successLight : AppColors.successDark,
          accent: isDark ? AppColors.success : AppColors.success,
          subtleBorder: (isDark ? AppColors.success : AppColors.success)
              .withOpacity(0.25),
        );

      case SnackbarType.error:
        return _SnackbarConfig(
          background: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.errorContainer,
          foreground: isDark ? AppColors.errorLight : AppColors.errorDark,
          accent: AppColors.error,
          subtleBorder: AppColors.error.withOpacity(0.25),
        );

      case SnackbarType.warning:
        return _SnackbarConfig(
          background: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.warningContainer,
          foreground: isDark ? AppColors.warningLight : AppColors.warningDark,
          accent: AppColors.warning,
          subtleBorder: AppColors.warning.withOpacity(0.25),
        );

      case SnackbarType.info:
        return _SnackbarConfig(
          background: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.infoContainer,
          foreground: isDark ? AppColors.infoLight : AppColors.infoDark,
          accent: AppColors.info,
          subtleBorder: AppColors.info.withOpacity(0.25),
        );
    }
  }

  static IconData iconFor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;
      case SnackbarType.error:
        return Icons.error_rounded;
      case SnackbarType.warning:
        return Icons.warning_rounded;
      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }
}

// -----------------------------------------------------------------------------
// SIZING CONSTANTS  (aligned to AppSpacing / AppRadius / Breakpoints)
// -----------------------------------------------------------------------------

class _SnackbarSizing {
  // Width
  static const double desktopWidth = 360.0;
  static const double desktopMaxWidth = 420.0;

  // Spacing
  static const double edgeOffset = AppSpacing.md;       // 16
  static const double paddingH = AppSpacing.md;         // 16
  static const double paddingV = AppSpacing.sm + 4;     // 12
  static const double iconGap = AppSpacing.sm + 2;      // 10
  static const double closeGap = AppSpacing.sm;         // 8
  static const double actionGap = AppSpacing.sm;        // 8
  static const double titleMessageGap = 2.0;

  // Left accent bar
  static const double accentBarWidth = 4.0;

  // Shape
  static const double borderRadius = AppRadius.lg;      // 12
  static const double borderThinWidth = 1.0;

  // Icons
  static const double iconSize = 18.0;
  static const double closeIconSize = 16.0;

  // Durations
  static const Duration short = Duration(seconds: 3);
  static const Duration medium = Duration(seconds: 5);
  static const Duration long = Duration(seconds: 8);
  static const Duration animIn = Duration(milliseconds: 280);
  static const Duration animOut = Duration(milliseconds: 220);
}

// -----------------------------------------------------------------------------
// MAIN UTILITY CLASS
// -----------------------------------------------------------------------------

class AppSnackbar {
  AppSnackbar._();

  // Convenience constructors ------------------------------------------------

  static void success(
    BuildContext context,
    String message, {
    String? title,
    SnackbarAction? action,
    Duration? duration,
  }) =>
      show(
        context,
        message: message,
        title: title,
        type: SnackbarType.success,
        action: action,
        duration: duration,
      );

  static void error(
    BuildContext context,
    String message, {
    String? title,
    SnackbarAction? action,
    Duration? duration,
  }) =>
      show(
        context,
        message: message,
        title: title ?? 'Something went wrong',
        type: SnackbarType.error,
        action: action,
        duration: duration ?? _SnackbarSizing.long,
      );

  static void warning(
    BuildContext context,
    String message, {
    String? title,
    SnackbarAction? action,
    Duration? duration,
  }) =>
      show(
        context,
        message: message,
        title: title,
        type: SnackbarType.warning,
        action: action,
        duration: duration,
      );

  static void info(
    BuildContext context,
    String message, {
    String? title,
    SnackbarAction? action,
    Duration? duration,
  }) =>
      show(
        context,
        message: message,
        title: title,
        type: SnackbarType.info,
        action: action,
        duration: duration,
      );

  // Core show method --------------------------------------------------------

  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? title,
    SnackbarAction? action,
    Duration? duration,
  }) {
    final platform = _resolvePlatform(context);
    final effectiveDuration = duration ?? _SnackbarSizing.medium;

    switch (platform) {
      case _SnackbarPlatform.desktopOverlay:
      case _SnackbarPlatform.tabletOverlay:
        _showOverlay(
          context,
          message: message,
          title: title,
          type: type,
          action: action,
          duration: effectiveDuration,
          platform: platform,
        );
        break;
      case _SnackbarPlatform.mobileSystem:
        _showMobileSnackbar(
          context,
          message: message,
          title: title,
          type: type,
          action: action,
          duration: effectiveDuration,
        );
        break;
    }
  }

  /// Programmatically dismiss any active overlay snackbar.
  static void dismiss(BuildContext context) {
    _OverlayRegistry.dismissActive(context);
  }

  // ---------------------------------------------------------------------------
  // PLATFORM RESOLUTION
  // ---------------------------------------------------------------------------

  static _SnackbarPlatform _resolvePlatform(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (kIsWeb) {
      if (width >= Breakpoints.tablet) return _SnackbarPlatform.desktopOverlay;
      if (width >= Breakpoints.mobile) return _SnackbarPlatform.tabletOverlay;
      return _SnackbarPlatform.mobileSystem;
    }

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return _SnackbarPlatform.desktopOverlay;
    }

    if (width >= Breakpoints.tablet) return _SnackbarPlatform.desktopOverlay;
    if (width >= Breakpoints.mobile) return _SnackbarPlatform.tabletOverlay;
    return _SnackbarPlatform.mobileSystem;
  }

  // ---------------------------------------------------------------------------
  // OVERLAY SNACKBAR  (Desktop & Tablet)
  // ---------------------------------------------------------------------------

  static void _showOverlay(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    required Duration duration,
    required _SnackbarPlatform platform,
    String? title,
    SnackbarAction? action,
  }) {
    _OverlayRegistry.dismissActive(context);

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _OverlaySnackbar(
        message: message,
        title: title,
        type: type,
        action: action,
        duration: duration,
        platform: platform,
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
    _OverlayRegistry.register(context, entry);
  }

  // ---------------------------------------------------------------------------
  // MOBILE SYSTEM SNACKBAR  (iOS & Android phones)
  // ---------------------------------------------------------------------------

  static void _showMobileSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    required Duration duration,
    String? title,
    SnackbarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _SnackbarConfig.resolve(type, isDark);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        padding: EdgeInsets.zero,
        content: _SnackbarContent(
          message: message,
          title: title,
          type: type,
          config: config,
          action: action,
          showClose: false,
          onClose: () =>
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// OVERLAY REGISTRY
// -----------------------------------------------------------------------------

class _OverlayRegistry {
  static final Map<BuildContext, OverlayEntry> _active = {};

  static void register(BuildContext ctx, OverlayEntry entry) {
    _active[ctx] = entry;
  }

  static void dismissActive(BuildContext ctx) {
    final entry = _active[ctx];
    if (entry != null && entry.mounted) entry.remove();
    _active.remove(ctx);
  }
}

// -----------------------------------------------------------------------------
// OVERLAY SNACKBAR WIDGET
// -----------------------------------------------------------------------------

class _OverlaySnackbar extends StatefulWidget {
  final String message;
  final String? title;
  final SnackbarType type;
  final SnackbarAction? action;
  final Duration duration;
  final _SnackbarPlatform platform;
  final VoidCallback onDismiss;

  const _OverlaySnackbar({
    required this.message,
    required this.title,
    required this.type,
    required this.action,
    required this.duration,
    required this.platform,
    required this.onDismiss,
  });

  @override
  State<_OverlaySnackbar> createState() => _OverlaySnackbarWidgetState();
}

class _OverlaySnackbarWidgetState extends State<_OverlaySnackbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: _SnackbarSizing.animIn,
      reverseDuration: _SnackbarSizing.animOut,
    );

    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    final isDesktop = widget.platform == _SnackbarPlatform.desktopOverlay;
    _slide = Tween<Offset>(
      begin: isDesktop ? const Offset(0.14, 0) : const Offset(0, -0.14),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );

    _ctrl.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _SnackbarConfig.resolve(widget.type, isDark);
    final isDesktop = widget.platform == _SnackbarPlatform.desktopOverlay;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    final snackWidth = isDesktop
        ? (screenWidth > Breakpoints.largeDesktop
            ? _SnackbarSizing.desktopMaxWidth
            : _SnackbarSizing.desktopWidth)
        : screenWidth - (_SnackbarSizing.edgeOffset * 2);

    return Positioned(
      top: topPadding + _SnackbarSizing.edgeOffset,
      right: isDesktop ? _SnackbarSizing.edgeOffset : null,
      left: isDesktop ? null : _SnackbarSizing.edgeOffset,
      width: snackWidth,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _slide,
            child: _SnackbarContent(
              message: widget.message,
              title: widget.title,
              type: widget.type,
              config: config,
              action: widget.action,
              showClose: true,
              onClose: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SNACKBAR CONTENT WIDGET
//
// FIX: Flutter's BoxDecoration throws when borderRadius is combined with a
// Border that has non-uniform colors (e.g. left = full opacity, others = 25%).
//
// Solution: Split into two layers using ClipRRect + Stack:
//   Layer 1 → outer Container: uniform thin border + shadow + rounded corners
//   Layer 2 → inner Stack: colored left accent bar (4px) drawn on top
//
// This avoids the non-uniform border entirely and gives the same visual result.
// -----------------------------------------------------------------------------

class _SnackbarContent extends StatelessWidget {
  final String message;
  final String? title;
  final SnackbarType type;
  final _SnackbarConfig config;
  final SnackbarAction? action;
  final bool showClose;
  final VoidCallback onClose;

  const _SnackbarContent({
    required this.message,
    required this.title,
    required this.type,
    required this.config,
    required this.action,
    required this.showClose,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(_SnackbarSizing.borderRadius);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        // ── Outer shell: uniform border + shadow + fill ──────────────────────
        // All four sides share the SAME color → no non-uniform border crash.
        decoration: BoxDecoration(
          color: config.background,
          borderRadius: radius,
          border: Border.all(
            color: config.subtleBorder,
            width: _SnackbarSizing.borderThinWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: config.accent.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Left accent bar drawn as a plain Positioned box ──────────────
            // Completely independent from the outer border → no Flutter
            // constraint violations.
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: _SnackbarSizing.accentBarWidth,
              child: ColoredBox(color: config.accent),
            ),

            // ── Main content row ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(
                // Extra left padding accounts for the 4px accent bar
                left: _SnackbarSizing.accentBarWidth + _SnackbarSizing.paddingH,
                right: _SnackbarSizing.paddingH,
                top: _SnackbarSizing.paddingV,
                bottom: _SnackbarSizing.paddingV,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading icon
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      _SnackbarConfig.iconFor(type),
                      size: _SnackbarSizing.iconSize,
                      color: config.accent,
                    ),
                  ),
                  SizedBox(width: _SnackbarSizing.iconGap),

                  // Text block
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null && title!.isNotEmpty) ...[
                          Text(
                            title!,
                            style: textTheme.titleSmall?.copyWith(
                              color: config.foreground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: _SnackbarSizing.titleMessageGap),
                        ],
                        Text(
                          message,
                          style: textTheme.bodySmall?.copyWith(
                            color: title != null
                                ? config.foreground.withOpacity(0.78)
                                : config.foreground,
                            fontWeight: title != null
                                ? FontWeight.w400
                                : FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (action != null) ...[
                          SizedBox(height: _SnackbarSizing.actionGap),
                          GestureDetector(
                            onTap: () {
                              action!.onPressed();
                              onClose();
                            },
                            child: Text(
                              action!.label,
                              style: textTheme.labelMedium?.copyWith(
                                color: config.accent,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: config.accent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Close button (overlay / desktop only)
                  if (showClose) ...[
                    SizedBox(width: _SnackbarSizing.closeGap),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close_rounded,
                        size: _SnackbarSizing.closeIconSize,
                        color: config.foreground.withOpacity(0.45),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}