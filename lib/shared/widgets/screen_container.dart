import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// Enum to define screen sizes
enum ScreenSize { mobile, tablet, desktop }

// Enum to define platform types
enum PlatformType { android, ios, web, windows, macos, linux }

class ResponsiveScreenContainer extends StatelessWidget {
  final Widget? mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showDebugInfo;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  const ResponsiveScreenContainer({
    super.key,
    this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showDebugInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(constraints.maxWidth);
        final platformType = _getPlatformType();

        return Container(
          padding: _getResponsivePadding(screenSize, platformType),
          color: backgroundColor,
          child: Column(
            children: [
              // Debug info banner (only shown in debug mode)
              if (showDebugInfo && kDebugMode)
                _buildDebugInfoBanner(screenSize, platformType, constraints),

              // Main content
              Expanded(child: _buildResponsiveLayout(screenSize)),
            ],
          ),
        );
      },
    );
  }

  // Determine screen size based on width
  ScreenSize _getScreenSize(double width) {
    if (width < mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  // Detect platform type
  PlatformType _getPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    }

    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } catch (e) {
      // Fallback for web or unsupported platforms
      return PlatformType.web;
    }

    return PlatformType.web;
  }

  // Get responsive padding based on screen size and platform
  EdgeInsetsGeometry _getResponsivePadding(
    ScreenSize screenSize,
    PlatformType platformType,
  ) {
    if (padding != null) return padding!;

    // Default padding based on screen size
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32.0);
    }
  }

  // Build the appropriate layout based on screen size
  Widget _buildResponsiveLayout(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobileLayout ?? child;
      case ScreenSize.tablet:
        return tabletLayout ?? mobileLayout ?? child;
      case ScreenSize.desktop:
        return desktopLayout ?? tabletLayout ?? mobileLayout ?? child;
    }
  }

  // Debug info banner
  Widget _buildDebugInfoBanner(
    ScreenSize screenSize,
    PlatformType platformType,
    BoxConstraints constraints,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange.withAlpha(160),
      child: Text(
        'Debug: ${platformType.name.toUpperCase()} | ${screenSize.name.toUpperCase()} | ${constraints.maxWidth.toInt()}x${constraints.maxHeight.toInt()}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Extension to easily access screen information from anywhere
extension ScreenInfo on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.of(this).size.width;
    if (width < ResponsiveScreenContainer.mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < ResponsiveScreenContainer.tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  PlatformType get platformType {
    if (kIsWeb) return PlatformType.web;

    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } catch (e) {
      return PlatformType.web;
    }

    return PlatformType.web;
  }

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktop => screenSize == ScreenSize.desktop;

  bool get isAndroid => platformType == PlatformType.android;
  bool get isIOS => platformType == PlatformType.ios;
  bool get isWeb => platformType == PlatformType.web;
}

// Example usage widget
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Screen Example')),
      body: ResponsiveScreenContainer(
        showDebugInfo: true, // Enable debug info in development
        backgroundColor: Colors.grey[100],
        mobileLayout: _buildMobileLayout(),
        tabletLayout: _buildTabletLayout(),
        desktopLayout: _buildDesktopLayout(),
        child: _buildDefaultLayout(), // Fallback layout
      ),
    );
  }

  Widget _buildMobileLayout() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android, size: 100),
          Text('Mobile Layout', style: TextStyle(fontSize: 24)),
          Text('Single column, touch-optimized'),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.tablet, size: 80), Text('Tablet Layout')],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Two column layout', style: TextStyle(fontSize: 20)),
              Text('Optimized for medium screens'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.computer, size: 80),
                Text('Desktop Layout'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Multi-column layout', style: TextStyle(fontSize: 24)),
                Text('Optimized for large screens'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('More content space'),
                Text('Enhanced navigation'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLayout() {
    return const Center(child: Text('Default Layout'));
  }
}
