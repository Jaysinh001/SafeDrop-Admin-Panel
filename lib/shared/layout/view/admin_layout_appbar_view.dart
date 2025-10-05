// =============================================================================
// ADMIN APP BAR COMPONENT
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import 'admin_panel_layout.dart';

class AdminAppBar extends StatelessWidget {
  final String title;
  final List<String> breadcrumbs;
  final VoidCallback onMenuPressed;
  final bool showMenuButton;

  const AdminAppBar({
    super.key,
    required this.title,
    required this.breadcrumbs,
    required this.onMenuPressed,
    required this.showMenuButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outline, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (showMenuButton) ...[
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu),
                tooltip: 'Toggle Sidebar',
              ),
              const SizedBox(width: 8),
            ],

            // Breadcrumbs and Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildBreadcrumbs(),
                ],
              ),
            ),

            // Action Buttons
            _buildAppBarActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children:
          breadcrumbs.asMap().entries.map((entry) {
            final index = entry.key;
            final breadcrumb = entry.value;
            final isLast = index == breadcrumbs.length - 1;

            return Row(
              children: [
                Text(
                  breadcrumb,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: isLast ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                ],
              ],
            );
          }).toList(),
    );
  }

  Widget _buildAppBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        IconButton(
          onPressed: () => Get.toNamed('/notifications'),
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_outlined),
          ),
          tooltip: 'Notifications',
        ),

        // Search
        IconButton(
          onPressed: () => Get.toNamed('/search'),
          icon: const Icon(Icons.search),
          tooltip: 'Search',
        ),

        // Profile Menu
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                Get.toNamed('/profile');
                break;
              case 'settings':
                Get.toNamed('/settings');
                break;
              case 'logout':
                _handleLogout();
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                'A',
                style: Get.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: AppColors.onError,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        // Handle logout logic
        Get.offAllNamed('/login');
      },
    );
  }
}
