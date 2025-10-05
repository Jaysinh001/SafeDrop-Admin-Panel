// =============================================================================
// ADMIN LAYOUT CONTROLLER - GetX Controller for layout state
// =============================================================================

import 'package:get/get.dart';

import '../../widgets/screen_container.dart';

class AdminLayoutController extends GetxController {
  // Sidebar state management
  final _isSidebarExpanded = true.obs;
  final _isSidebarVisible = true.obs;
  final _currentPageIndex = 0.obs;
  final _currentPageTitle = 'Dashboard'.obs;
  final _breadcrumbs = <String>['Home', 'Dashboard'].obs;

  // Getters
  bool get isSidebarExpanded => _isSidebarExpanded.value;
  bool get isSidebarVisible => _isSidebarVisible.value;
  int get currentPageIndex => _currentPageIndex.value;
  String get currentPageTitle => _currentPageTitle.value;
  List<String> get breadcrumbs => _breadcrumbs.toList();

  // Screen size detection
  ScreenSize get currentScreenSize {
    final width = Get.width;
    if (width < 768) return ScreenSize.mobile;
    if (width < 1024) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  // Auto-manage sidebar based on screen size
  void updateScreenSize() {
    switch (currentScreenSize) {
      case ScreenSize.mobile:
        _isSidebarVisible.value = false;
        _isSidebarExpanded.value = false;
        break;
      case ScreenSize.tablet:
        _isSidebarVisible.value = true;
        _isSidebarExpanded.value = false;
        break;
      case ScreenSize.desktop:
        _isSidebarVisible.value = true;
        _isSidebarExpanded.value = true;
        break;
    }
  }

  // Toggle sidebar visibility (mobile)
  void toggleSidebarVisibility() {
    _isSidebarVisible.value = !_isSidebarVisible.value;
  }

  // Toggle sidebar expansion (tablet/desktop)
  void toggleSidebarExpansion() {
    if (currentScreenSize != ScreenSize.mobile) {
      _isSidebarExpanded.value = !_isSidebarExpanded.value;
    }
  }

  // Navigate to page
  void navigateToPage(
    int index,
    String title,
    String route, {
    List<String>? breadcrumbs,
  }) {
    _currentPageIndex.value = index;
    _currentPageTitle.value = title;
    _breadcrumbs.value = breadcrumbs ?? ['Home', title];

    // Close sidebar on mobile after navigation
    if (currentScreenSize == ScreenSize.mobile) {
      _isSidebarVisible.value = false;
    }

    // Navigate using GetX
    Get.toNamed(route);
  }

  @override
  void onInit() {
    super.onInit();
    updateScreenSize();
  }
}
