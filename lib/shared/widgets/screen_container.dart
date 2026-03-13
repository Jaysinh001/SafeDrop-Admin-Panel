import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// ============================================================================
// ENUMS
// ============================================================================

/// Enum to define screen size categories
enum ScreenSize { mobile, tablet, desktop }

/// Enum to define platform types
enum PlatformType { android, ios, web, windows, macos, linux }

// ============================================================================
// RESPONSIVE SCREEN CONTAINER - PRODUCTION READY
// ============================================================================

/// A comprehensive, production-ready responsive container that adapts layouts
/// based on screen size and platform type. Optimized for multi-screen deployment.
///
/// Features:
/// - Smart state caching to prevent unnecessary rebuilds
/// - Proper error handling with fallbacks
/// - SafeArea integration for notch/cutout safety
/// - Dark mode support
/// - Configurable breakpoints
/// - Input validation and assertions
/// - Comprehensive error boundaries
/// - Memory-efficient platform detection
/// - Support for all major platforms: Android, iOS, Web, Windows, macOS, Linux
///
/// Example:
/// ```dart
/// ResponsiveScreenContainer(
///   mobileLayout: MobileScreen(),
///   tabletLayout: TabletScreen(),
///   desktopLayout: DesktopScreen(),
///   child: DefaultScreen(),
///   backgroundColor: Colors.white,
/// )
/// ```
class ResponsiveScreenContainer extends StatefulWidget {
  /// Layout for mobile devices (width < mobileBreakpoint)
  final Widget? mobileLayout;

  /// Layout for tablet devices (width >= mobileBreakpoint && width < tabletBreakpoint)
  final Widget? tabletLayout;

  /// Layout for desktop devices (width >= tabletBreakpoint)
  final Widget? desktopLayout;

  /// Fallback/default layout when specific layout is not provided
  final Widget child;

  /// Custom padding for the container
  /// If null, uses responsive padding based on screen size
  final EdgeInsetsGeometry? padding;

  /// Background color for the container
  /// If null, uses theme-aware color (light mode: white, dark mode: grey[900])
  final Color? backgroundColor;

  /// Breakpoint width for mobile to tablet transition (default: 600)
  final double mobileBreakpoint;

  /// Breakpoint width for tablet to desktop transition (default: 1024)
  final double tabletBreakpoint;

  /// Whether to show debug info banner in debug mode
  /// Displays: platform, screen size, and dimensions
  final bool showDebugInfo;

  /// Called when screen size changes (useful for analytics)
  final Function(ScreenSize)? onScreenSizeChanged;

  /// Called when platform type is detected
  /// Useful for platform-specific initialization
  final Function(PlatformType)? onPlatformDetected;

  /// Whether to use SafeArea (recommended for mobile)
  final bool useSafeArea;

  /// Whether to automatically handle orientation changes
  final bool handleOrientationChanges;

  const ResponsiveScreenContainer({
    super.key,
    required this.child,
    this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
    this.padding,
    this.backgroundColor,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 1024,
    this.showDebugInfo = false,
    this.onScreenSizeChanged,
    this.onPlatformDetected,
    this.useSafeArea = true,
    this.handleOrientationChanges = true,
  })  : assert(
          mobileBreakpoint > 0,
          'mobileBreakpoint must be greater than 0',
        ),
        assert(
          tabletBreakpoint > mobileBreakpoint,
          'tabletBreakpoint must be greater than mobileBreakpoint',
        ),
        assert(
          mobileBreakpoint < 2560,
          'mobileBreakpoint must be less than 2560',
        ),
        assert(
          tabletBreakpoint < 2560,
          'tabletBreakpoint must be less than 2560',
        );

  @override
  State<ResponsiveScreenContainer> createState() =>
      _ResponsiveScreenContainerState();
}

// ============================================================================
// STATE IMPLEMENTATION
// ============================================================================

class _ResponsiveScreenContainerState extends State<ResponsiveScreenContainer>
    with WidgetsBindingObserver {
  /// Cached screen size to prevent unnecessary recalculations
  late ScreenSize _cachedScreenSize;

  /// Cached platform type (calculated once at init)
  late PlatformType _cachedPlatformType;

  /// Previous screen size to detect changes
  ScreenSize? _previousScreenSize;

  /// Whether we're in a layout error state
  bool _isInErrorState = false;

  /// Error message for the error state
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Initialize platform type once (expensive operation)
    _cachedPlatformType = _getPlatformType();

    // Notify listeners of platform detection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPlatformDetected?.call(_cachedPlatformType);
    });

    // Add observer for lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Handle orientation changes
    if (widget.handleOrientationChanges) {
      setState(() {
        // Trigger rebuild on metrics change
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Safely handle infinite constraints
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;

        // Calculate screen size based on width
        _cachedScreenSize = _getScreenSize(maxWidth);

        // Notify of screen size change if it changed
        if (_previousScreenSize != _cachedScreenSize) {
          _previousScreenSize = _cachedScreenSize;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onScreenSizeChanged?.call(_cachedScreenSize);
          });
        }

        // Get theme-aware background color
        final bgColor = widget.backgroundColor ??
            _getThemeAwareColor(context);

        // Get responsive padding
        final responsivePadding = widget.padding ??
            _getResponsivePadding(_cachedScreenSize, _cachedPlatformType);

        // Build the layout with error handling
        return Container(
          color: bgColor,
          child: _buildLayoutWithErrorHandling(
            context,
            maxWidth,
            maxHeight,
            responsivePadding,
          ),
        );
      },
    );
  }

  /// Builds layout with SafeArea and error boundary
  Widget _buildLayoutWithErrorHandling(
    BuildContext context,
    double maxWidth,
    double maxHeight,
    EdgeInsetsGeometry padding,
  ) {
    Widget content;

    if (_isInErrorState) {
      content = _buildErrorWidget();
    } else {
      try {
        content = _buildResponsiveLayout(_cachedScreenSize);
      } catch (e, stackTrace) {
        _handleLayoutError(e, stackTrace);
        content = _buildErrorWidget();
      }
    }

    // Wrap with SafeArea if enabled
    if (widget.useSafeArea) {
      content = SafeArea(
        child: content,
      );
    }

    // Add padding
    content = Padding(
      padding: padding,
      child: content,
    );

    // Add debug info if enabled
    if (widget.showDebugInfo && kDebugMode) {
      content = Column(
        children: [
          _buildDebugInfoBanner(maxWidth, maxHeight),
          Expanded(child: content),
        ],
      );
    }

    return content;
  }

  /// Determines screen size based on width
  ScreenSize _getScreenSize(double width) {
    if (width < widget.mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < widget.tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Detects platform type with proper error handling
  PlatformType _getPlatformType() {
    // Check web first (doesn't throw)
    if (kIsWeb) {
      return PlatformType.web;
    }

    // Try to detect native platforms
    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } on UnsupportedError catch (e) {
      // Expected when checking unavailable platforms
      if (kDebugMode) {
        debugPrint('Platform check unavailable: $e');
      }
      return PlatformType.web; // Fallback
    } catch (e) {
      // Unexpected error - log it
      if (kDebugMode) {
        debugPrint('Unexpected error in platform detection: $e');
      }
      return PlatformType.web; // Safe fallback
    }

    // Should never reach here, but fallback to web for safety
    return PlatformType.web;
  }

  /// Gets theme-aware background color
  Color _getThemeAwareColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark
        ? Colors.grey[900] ?? Colors.black
        : Colors.white;
  }

  /// Gets responsive padding based on screen size and platform
  EdgeInsetsGeometry _getResponsivePadding(
    ScreenSize screenSize,
    PlatformType platformType,
  ) {
    // Platform-specific adjustments
    const mobileBasePadding = 12.0;
    const tabletBasePadding = 20.0;
    const desktopBasePadding = 28.0;

    // Add extra padding for certain platforms
    double additionalPadding = 0;
    if (platformType == PlatformType.macos ||
        platformType == PlatformType.windows ||
        platformType == PlatformType.linux) {
      additionalPadding = 4.0; // Desktop OS gets slightly more padding
    }

    switch (screenSize) {
      case ScreenSize.mobile:
        return EdgeInsets.all(mobileBasePadding + additionalPadding);
      case ScreenSize.tablet:
        return EdgeInsets.all(tabletBasePadding + additionalPadding);
      case ScreenSize.desktop:
        return EdgeInsets.all(desktopBasePadding + additionalPadding);
    }
  }

  /// Builds the appropriate layout based on screen size
  Widget _buildResponsiveLayout(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return widget.mobileLayout ?? widget.child;
      case ScreenSize.tablet:
        return widget.tabletLayout ??
            widget.mobileLayout ??
            widget.child;
      case ScreenSize.desktop:
        return widget.desktopLayout ??
            widget.tabletLayout ??
            widget.mobileLayout ??
            widget.child;
    }
  }

  /// Handles layout errors gracefully
  void _handleLayoutError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Layout Error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    setState(() {
      _isInErrorState = true;
      _errorMessage = error.toString();
    });
  }

  /// Builds error widget for display
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Layout Error',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red[700],
                ),
          ),
          const SizedBox(height: 8),
          if (_errorMessage != null && kDebugMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[600],
                    ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isInErrorState = false;
                _errorMessage = null;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Builds debug info banner
  Widget _buildDebugInfoBanner(double maxWidth, double maxHeight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(200),
        border: Border(
          bottom: BorderSide(
            color: Colors.orange[800]!,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🐛 DEBUG | ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${_cachedPlatformType.name.toUpperCase()} | ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            Text(
              '${_cachedScreenSize.name.toUpperCase()} | ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            Text(
              '${maxWidth.toStringAsFixed(0)}×${maxHeight.toStringAsFixed(0)}px',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EXTENSION METHODS
// ============================================================================

/// Extension on BuildContext to easily access screen information
extension ScreenInfo on BuildContext {
  /// Gets the current screen size category
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) {
      return ScreenSize.mobile;
    } else if (width < 1024) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Gets the current platform type
  PlatformType get platformType {
    if (kIsWeb) return PlatformType.web;

    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } on UnsupportedError {
      return PlatformType.web;
    }

    return PlatformType.web;
  }

  /// Gets the current orientation
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// Checks if device is in portrait orientation
  bool get isPortrait => orientation == Orientation.portrait;

  /// Checks if device is in landscape orientation
  bool get isLandscape => orientation == Orientation.landscape;

  /// Checks if current screen size is mobile
  bool get isMobile => screenSize == ScreenSize.mobile;

  /// Checks if current screen size is tablet
  bool get isTablet => screenSize == ScreenSize.tablet;

  /// Checks if current screen size is desktop
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// Checks if platform is Android
  bool get isAndroid => platformType == PlatformType.android;

  /// Checks if platform is iOS
  bool get isIOS => platformType == PlatformType.ios;

  /// Checks if platform is web
  bool get isWeb => platformType == PlatformType.web;

  /// Checks if platform is Windows
  bool get isWindows => platformType == PlatformType.windows;

  /// Checks if platform is macOS
  bool get isMacOS => platformType == PlatformType.macos;

  /// Checks if platform is Linux
  bool get isLinux => platformType == PlatformType.linux;

  /// Checks if running on mobile platform (Android or iOS)
  bool get isMobilePlatform => isAndroid || isIOS;

  /// Checks if running on desktop platform (Windows, macOS, or Linux)
  bool get isDesktopPlatform =>
      isWindows || isMacOS || isLinux;

  /// Gets the device width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Gets the device height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Gets the device aspect ratio
  double get aspectRatio => screenWidth / screenHeight;

  /// Checks if device is in tablet-like size (both orientation)
  bool get isTabletLike {
    final shortestSide =
        MediaQuery.sizeOf(this).shortestSide;
    return shortestSide >= 600;
  }
}

// ============================================================================
// EXAMPLE USAGE WIDGET
// ============================================================================

/// Example widget demonstrating ResponsiveScreenContainer usage
class ExampleResponsiveScreen extends StatelessWidget {
  const ExampleResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Screen Example'),
        elevation: 0,
      ),
      body: ResponsiveScreenContainer(
        showDebugInfo: kDebugMode, // Shows debug info only in debug mode
        backgroundColor: Colors.grey[50],
        onScreenSizeChanged: (size) {
          debugPrint('Screen size changed to: ${size.name}');
        },
        onPlatformDetected: (platform) {
          debugPrint('Platform detected: ${platform.name}');
        },
        mobileLayout: _buildMobileLayout(context),
        tabletLayout: _buildTabletLayout(context),
        desktopLayout: _buildDesktopLayout(context),
        child: _buildDefaultLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android, size: 100, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            'Mobile Layout',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Single column, touch-optimized',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Width: ${context.screenWidth.toStringAsFixed(0)}px',
            'Height: ${context.screenHeight.toStringAsFixed(0)}px',
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.tablet, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'Tablet Layout',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Two column layout',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Optimized for medium screens',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            'Orientation: ${context.isPortrait ? 'Portrait' : 'Landscape'}',
            'Size: ${context.screenWidth.toStringAsFixed(0)}×${context.screenHeight.toStringAsFixed(0)}px',
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.computer, size: 100, color: Colors.purple),
              const SizedBox(height: 16),
              Text(
                'Desktop Layout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Multi-column layout',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Optimized for large screens',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Platform: ${context.platformType.name.toUpperCase()}',
                'Size: ${context.screenWidth.toStringAsFixed(0)}×${context.screenHeight.toStringAsFixed(0)}px',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLayout(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.devices, size: 100),
          const SizedBox(height: 24),
          Text(
            'Default Layout',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Size: ${context.screenSize.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}