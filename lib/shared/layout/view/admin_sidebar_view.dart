// =============================================================================
// ADMIN SIDEBAR COMPONENT
// =============================================================================

import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
          ? AppColors.darkSidebarBackground 
          : AppColors.sidebarBackground,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Header
          _buildLogoHeader(context),

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
          _buildSidebarFooter(context),
        ],
      ),
    );
  }

  Widget _buildLogoHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  isDark ? AppColors.primaryLight : AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.admin_panel_settings,
              color: colorScheme.onPrimary,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark 
                        ? AppColors.darkSidebarActiveText 
                        : AppColors.sidebarSelectedText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark 
                        ? AppColors.darkSidebarText 
                        : AppColors.sidebarText,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = currentPageIndex == item.id;
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;

    if (hasSubItems) {
      return _buildExpandableNavigationItem(context, item, isSelected);
    }

    final selectedBgColor = isDark 
      ? AppColors.darkSidebarSelected 
      : AppColors.sidebarSelectedItem;
    final selectedTextColor = isDark 
      ? AppColors.darkSidebarActiveText 
      : AppColors.sidebarSelectedText;
    final unselectedTextColor = isDark 
      ? AppColors.darkSidebarText 
      : AppColors.sidebarText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
              color: isSelected ? selectedBgColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  item.icon,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  size: 20,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? selectedTextColor : unselectedTextColor,
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
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onError,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTextColor = isDark 
      ? AppColors.darkSidebarActiveText 
      : AppColors.sidebarSelectedText;
    final unselectedTextColor = isDark 
      ? AppColors.darkSidebarText 
      : AppColors.sidebarText;
    
    return ExpansionTile(
      leading: Icon(
        item.icon,
        color: isSelected ? selectedTextColor : unselectedTextColor,
        size: 20,
      ),
      title:
          isExpanded
              ? Text(
                item.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              )
              : const SizedBox(),
      iconColor: unselectedTextColor,
      collapsedIconColor: unselectedTextColor,
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

  Widget _buildSidebarFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final footerTextColor = isDark 
      ? AppColors.darkSidebarText 
      : AppColors.sidebarText;
    final hoverBgColor = isDark 
      ? AppColors.darkSidebarSelected 
      : AppColors.sidebarHoverItem;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // if (screenSize != ScreenSize.mobile)
            IconButton(
              onPressed: onToggleExpansion,
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: footerTextColor,
              ),
              tooltip: isExpanded ? 'Collapse Sidebar' : 'Expand Sidebar',
            ),
          if (isExpanded) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: hoverBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Admin User',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: footerTextColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}