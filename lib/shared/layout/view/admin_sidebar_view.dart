// =============================================================================
// ADMIN SIDEBAR COMPONENT
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../widgets/screen_container.dart';
import '../data/admin_layout_data.dart';
import '../model/admin_navigation_item_model.dart';

class AdminSideBar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final Function(int, String, String, {List<String>? breadcrumbs}) onNavigate;
  final int currentPageIndex;
  final ScreenSize screenSize;

  const AdminSideBar({
    super.key,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onNavigate,
    required this.currentPageIndex,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.sidebarBackground, Color(0xFF0f172a)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Header
          _buildLogoHeader(),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...AdminNavigationItems.items.map(
                  (item) => _buildNavigationItem(context, item),
                ),
              ],
            ),
          ),

          // Footer with toggle button
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Admin Panel',
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: AppColors.sidebarSelectedText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'v1.0.0',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppColors.sidebarText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationItem(BuildContext context, NavigationItem item) {
    final isSelected = currentPageIndex == item.id;
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;

    if (hasSubItems) {
      return _buildExpandableNavigationItem(context, item, isSelected);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              () => onNavigate(
                item.id,
                item.title,
                item.route,
                breadcrumbs: item.breadcrumbs,
              ),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.sidebarSelectedItem
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  item.icon,
                  color:
                      isSelected
                          ? AppColors.sidebarSelectedText
                          : AppColors.sidebarText,
                  size: 20,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected
                                ? AppColors.sidebarSelectedText
                                : AppColors.sidebarText,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge!,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppColors.onError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableNavigationItem(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
  ) {
    return ExpansionTile(
      leading: Icon(
        item.icon,
        color:
            isSelected ? AppColors.sidebarSelectedText : AppColors.sidebarText,
        size: 20,
      ),
      title:
          isExpanded
              ? Text(
                item.title,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected
                          ? AppColors.sidebarSelectedText
                          : AppColors.sidebarText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              )
              : SizedBox(),
      iconColor: AppColors.sidebarText,
      collapsedIconColor: AppColors.sidebarText,
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      children:
          item.subItems!
              .map(
                (subItem) => Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _buildNavigationItem(context, subItem),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (screenSize != ScreenSize.mobile)
            IconButton(
              onPressed: onToggleExpansion,
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: AppColors.sidebarText,
              ),
              tooltip: isExpanded ? 'Collapse Sidebar' : 'Expand Sidebar',
            ),
          if (isExpanded) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.sidebarHoverItem,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Admin User',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.sidebarText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
