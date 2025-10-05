import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../../../core/theme/colors.dart';
import '../../widgets/screen_container.dart';
import 'admin_layout_appbar_view.dart';
import 'admin_layout_controller.dart';
import 'admin_sidebar_view.dart';

// =============================================================================
// MAIN ADMIN PANEL LAYOUT
// =============================================================================

class AdminPanelLayout extends GetView<AdminLayoutController> {
  final Widget child;

  const AdminPanelLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Update controller with current screen size
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.updateScreenSize();
        });

        return Scaffold(
          body: Row(
            children: [
              // Sidebar Navigation
              Obx(
                () =>
                    controller.isSidebarVisible
                        ? AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          width: controller.isSidebarExpanded ? 280 : 90,
                          child: AdminSideBar(
                            isExpanded: controller.isSidebarExpanded,
                            onToggleExpansion:
                                controller.toggleSidebarExpansion,
                            onNavigate: controller.navigateToPage,
                            currentPageIndex: controller.currentPageIndex,
                            screenSize: controller.currentScreenSize,
                          ),
                        )
                        : const SizedBox.shrink(),
              ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Top App Bar
                    AdminAppBar(
                      title: controller.currentPageTitle,
                      breadcrumbs: controller.breadcrumbs,
                      onMenuPressed: controller.toggleSidebarVisibility,
                      showMenuButton:
                          controller.currentScreenSize == ScreenSize.mobile,
                    ),

                    // Main Content
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
