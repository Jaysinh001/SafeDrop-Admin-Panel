import 'package:flutter/material.dart';

// =============================================================================
// APP COLORS
// Centralized, semantically complete color palette for both light and dark mode.
//
// STRUCTURE
// ─────────────────────────────────────────────────────────────────────────────
// 1.  Primary
// 2.  Secondary / Accent
// 3.  Surface (light)
// 4.  Background (light)
// 5.  Text (light)
// 6.  Status — Success / Warning / Error / Info
// 7.  Neutral — Outline / Shadow / Scrim
// 8.  Sidebar (light)
// 9.  Card (light)
// 10. Chart palette
// 11. Gradients (light)
// 12. Dark mode — Surface & Background
// 13. Dark mode — Text hierarchy
// 14. Dark mode — Card & Border
// 15. Dark mode — Button onColors
// 16. Dark mode — Status containers & onContainer
// 17. Dark mode — Scrim / Overlay
// 18. Dark mode — Sidebar
// =============================================================================

class AppColors {
  AppColors._();

  // =========================================================================
  // 1. PRIMARY
  // =========================================================================

  static const Color primary          = Color(0xFF667eea);
  static const Color primaryDark      = Color(0xFF5a67d8);
  static const Color primaryLight     = Color(0xFF7c3aed);
  static const Color primaryContainer = Color(0xFFe0e7ff);
  static const Color onPrimary        = Color(0xFFffffff);

  // =========================================================================
  // 2. SECONDARY / ACCENT
  // =========================================================================

  static const Color secondary          = Color(0xFF764ba2);
  static const Color secondaryDark      = Color(0xFF6b46c1);
  static const Color secondaryLight     = Color(0xFF8b5cf6);
  static const Color secondaryContainer = Color(0xFFede9fe);
  static const Color onSecondary        = Color(0xFFffffff);

  // =========================================================================
  // 3. SURFACE (light)
  // =========================================================================

  static const Color surface                  = Color(0xFFffffff);
  static const Color surfaceDim               = Color(0xFFf8fafc);
  static const Color surfaceBright            = Color(0xFFffffff);
  static const Color surfaceContainer         = Color(0xFFf1f5f9);
  static const Color surfaceContainerHigh     = Color(0xFFe2e8f0);
  static const Color surfaceContainerHighest  = Color(0xFFcbd5e1);
  static const Color onSurface               = Color(0xFF0f172a);
  static const Color onSurfaceVariant        = Color(0xFF64748b);

  // =========================================================================
  // 4. BACKGROUND (light)
  // =========================================================================

  static const Color background          = Color(0xFFfafafa);
  static const Color backgroundSecondary = Color(0xFFf5f5f5);
  static const Color onBackground        = Color(0xFF1e293b);

  // =========================================================================
  // 5. TEXT (light)
  // =========================================================================

  static const Color textPrimary   = Color(0xFF1e293b);
  static const Color textSecondary = Color(0xFF64748b);
  static const Color textTertiary  = Color(0xFF94a3b8);
  static const Color textDisabled  = Color(0xFFcbd5e1);

  // =========================================================================
  // 6. STATUS
  // ─── Each status has: base, light, dark, container, onBase, onContainer ──
  // =========================================================================

  // ── Success ──────────────────────────────────────────────────────────────
  static const Color success            = Color(0xFF10b981);
  static const Color successLight       = Color(0xFF34d399);
  static const Color successDark        = Color(0xFF059669);
  static const Color successContainer   = Color(0xFFd1fae5); // light surfaces
  static const Color onSuccess          = Color(0xFFffffff);
  static const Color onSuccessContainer = Color(0xFF064e3b); // text on light container

  // ── Warning ───────────────────────────────────────────────────────────────
  static const Color warning            = Color(0xFFf59e0b);
  static const Color warningLight       = Color(0xFFfbbf24);
  static const Color warningDark        = Color(0xFFd97706);
  static const Color warningContainer   = Color(0xFFfef3c7);
  static const Color onWarning          = Color(0xFFffffff);
  static const Color onWarningContainer = Color(0xFF78350f);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error            = Color(0xFFef4444);
  static const Color errorLight       = Color(0xFFf87171);
  static const Color errorDark        = Color(0xFFdc2626);
  static const Color errorContainer   = Color(0xFFfee2e2);
  static const Color onError          = Color(0xFFffffff);
  static const Color onErrorContainer = Color(0xFF7f1d1d);

  // ── Info ──────────────────────────────────────────────────────────────────
  static const Color info            = Color(0xFF3b82f6);
  static const Color infoLight       = Color(0xFF60a5fa);
  static const Color infoDark        = Color(0xFF2563eb);
  static const Color infoContainer   = Color(0xFFdbeafe);
  static const Color onInfo          = Color(0xFFffffff);
  static const Color onInfoContainer = Color(0xFF1e3a5f);

  // =========================================================================
  // 7. NEUTRAL — Outline / Shadow / Scrim
  // =========================================================================

  static const Color outline        = Color(0xFFd1d5db);
  static const Color outlineVariant = Color(0xFFe5e7eb);
  static const Color shadow         = Color(0xFF000000);
  static const Color scrim          = Color(0xFF000000);

  /// 32 % black — light theme modal / bottom-sheet backdrop
  static const Color scrimLight = Color(0x52000000);

  /// 75 % black — dark theme modal / bottom-sheet backdrop
  static const Color scrimDark = Color(0xBF000000);

  static const Color inverseSurface   = Color(0xFF1e293b);
  static const Color onInverseSurface = Color(0xFFf1f5f9);

  // =========================================================================
  // 8. SIDEBAR (light)
  // =========================================================================

  static const Color sidebarBackground  = Color(0xFF1e293b);
  static const Color sidebarSelectedItem = Color(0xFF334155);
  static const Color sidebarHoverItem   = Color(0xFF475569);
  static const Color sidebarText        = Color(0xFFe2e8f0);
  static const Color sidebarSelectedText = Color(0xFFffffff);

  // =========================================================================
  // 9. CARD (light)
  // =========================================================================

  static const Color cardBackground = Color(0xFFffffff);
  static const Color cardBorder     = Color(0xFFe2e8f0);
  static const Color cardShadow     = Color(0x0f000000); // 6 % black

  // =========================================================================
  // 10. CHART PALETTE
  // Index map:
  //   [0] primary   #667eea    [4] error     #ef4444
  //   [1] secondary #764ba2    [5] info      #3b82f6
  //   [2] success   #10b981    [6] secLight  #8b5cf6
  //   [3] warning   #f59e0b    [7] pink      #ec4899
  // =========================================================================

  static const List<Color> chartColors = [
    Color(0xFF667eea), // [0] primary
    Color(0xFF764ba2), // [1] secondary
    Color(0xFF10b981), // [2] success
    Color(0xFFf59e0b), // [3] warning
    Color(0xFFef4444), // [4] error
    Color(0xFF3b82f6), // [5] info
    Color(0xFF8b5cf6), // [6] secondaryLight
    Color(0xFFec4899), // [7] pink
  ];

  // =========================================================================
  // 11. GRADIENTS (light)
  // =========================================================================

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

  // =========================================================================
  // 12. DARK MODE — Surface & Background
  // =========================================================================

  /// Deepest background — page scaffold
  static const Color darkBackground = Color(0xFF020617);

  /// Primary surface — top-level cards, app bar
  static const Color darkSurface = Color(0xFF0f172a);

  /// Elevated surface — nested cards, dialogs, drawers
  static const Color darkSurfaceContainer = Color(0xFF1e293b);

  /// Further elevated — inputs, chips, popovers
  static const Color darkSurfaceContainerHigh = Color(0xFF334155);

  /// Highest elevation — tooltips, menus
  static const Color darkSurfaceContainerHighest = Color(0xFF475569);

  static const Color darkOnSurface    = Color(0xFFf8fafc);
  static const Color darkOnBackground = Color(0xFFe2e8f0);

  // =========================================================================
  // 13. DARK MODE — Text hierarchy
  // Mirrors the light textPrimary/Secondary/Tertiary/Disabled scale
  // but with values appropriate for dark surfaces.
  // =========================================================================

  /// Headings, labels, primary content — same as darkOnSurface
  static const Color darkTextPrimary = Color(0xFFf8fafc);

  /// Sub-headings, secondary labels, visible muted text
  static const Color darkTextSecondary = Color(0xFFcbd5e1);

  /// Captions, hints, placeholder text, metadata
  static const Color darkTextTertiary = Color(0xFF94a3b8);

  /// Disabled controls and non-interactive text
  static const Color darkTextDisabled = Color(0xFF475569);

  // =========================================================================
  // 14. DARK MODE — Card & Border
  // =========================================================================

  /// Default card background on dark (= darkSurfaceContainer)
  static const Color darkCardBackground = Color(0xFF1e293b);

  /// Mid-tone card border — more visible than darkOutline
  static const Color darkCardBorder = Color(0xFF334155);

  /// Card drop shadow on dark (25 % black)
  static const Color darkCardShadow = Color(0x40000000);

  /// Standard border / divider on dark surfaces
  static const Color darkOutline = Color(0xFF475569);

  /// Subtle border / divider — less prominent than darkOutline
  static const Color darkOutlineVariant = Color(0xFF334155);

  // =========================================================================
  // 15. DARK MODE — Button onColors
  // In dark theme, primary / secondary are lighter hues (#7c3aed / #8b5cf6)
  // so the foreground text must be dark, not white.
  // =========================================================================

  /// Text / icon on primaryLight buttons in dark mode
  static const Color darkOnPrimary = Color(0xFF0f172a);

  /// Text / icon on secondaryLight buttons in dark mode
  static const Color darkOnSecondary = Color(0xFF0f172a);

  // =========================================================================
  // 16. DARK MODE — Status containers & onContainer
  // Light containers (#d1fae5 etc.) are too bright for dark surfaces.
  // These deep-tinted containers maintain the semantic hue on dark bg.
  // =========================================================================

  // ── Success ──────────────────────────────────────────────────────────────
  static const Color darkSuccessContainer   = Color(0xFF064e3b);
  static const Color onDarkSuccessContainer = Color(0xFF6ee7b7);

  // ── Warning ───────────────────────────────────────────────────────────────
  static const Color darkWarningContainer   = Color(0xFF78350f);
  static const Color onDarkWarningContainer = Color(0xFFfcd34d);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color darkErrorContainer   = Color(0xFF7f1d1d);
  static const Color onDarkErrorContainer = Color(0xFFfca5a5);

  // ── Info ──────────────────────────────────────────────────────────────────
  static const Color darkInfoContainer   = Color(0xFF1e3a5f);
  static const Color onDarkInfoContainer = Color(0xFF93c5fd);

  // =========================================================================
  // 17. DARK MODE — Scrim / Overlay
  // Re-exported as named constants so widgets don't inline magic opacities.
  // scrimLight and scrimDark are already defined in section 7 above.
  // =========================================================================
  // Use AppColors.scrimLight for light-mode modals.
  // Use AppColors.scrimDark  for dark-mode modals.

  // =========================================================================
  // 18. DARK MODE — Sidebar
  // =========================================================================

  /// Main sidebar canvas on dark (deepest — = darkSurface)
  static const Color darkSidebarBackground = Color(0xFF0f172a);

  /// Selected nav item background (= darkSurfaceContainer)
  static const Color darkSidebarSelected = Color(0xFF1e293b);

  /// Hovered nav item background
  static const Color darkSidebarHover = Color(0xFF334155);

  /// Default sidebar label text (= darkTextSecondary)
  static const Color darkSidebarText = Color(0xFFcbd5e1);

  /// Active / selected sidebar label text (= darkTextPrimary)
  static const Color darkSidebarActiveText = Color(0xFFf8fafc);

  /// Sidebar accent indicator (active route line)
  static const Color darkSidebarAccent = Color(0xFF667eea); // = primary
}