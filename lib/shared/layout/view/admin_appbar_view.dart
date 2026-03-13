import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/local_storage/local_storage_service.dart';
import '../../../core/dependencies/injection_container.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../widgets/screen_container.dart';
import '../bloc/admin_layout_bloc.dart';
import '../bloc/admin_layout_state.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark 
              ? AppColors.darkOutlineVariant 
              : AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            BlocBuilder<AdminLayoutBloc, AdminLayoutState>(
              buildWhen:
                  (previous, current) =>
                      previous.screenSize != current.screenSize ||
                      previous.isSidebarVisible != current.isSidebarVisible,
              builder: (context, state) {
                if (state.screenSize == ScreenSize.mobile) {
  return IconButton(
    onPressed: () {
      Scaffold.of(context).openDrawer();
    },
    icon: const Icon(Icons.menu),
  );
}
                return const SizedBox.shrink();
              },
            ),

            // Breadcrumbs and Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<AdminLayoutBloc, AdminLayoutState>(
                    buildWhen:
                        (previous, current) =>
                            previous.currentPageTitle !=
                            current.currentPageTitle,
                    builder: (context, state) {
                      return Text(
                        state.currentPageTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark 
                            ? AppColors.darkTextPrimary 
                            : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    },
                  ),
                  const SizedBox(height: 2),
                  BlocBuilder<AdminLayoutBloc, AdminLayoutState>(
                    buildWhen:
                        (previous, current) =>
                            previous.breadcrumbs != current.breadcrumbs,
                    builder: (context, state) {
                      return Row(
                        children:
                            state.breadcrumbs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final breadcrumb = entry.value;
                              final isLast =
                                  index == state.breadcrumbs.length - 1;

                              return Row(
                                children: [
                                  Text(
                                    breadcrumb,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          isLast
                                              ? (isDark 
                                                ? AppColors.primaryLight 
                                                : AppColors.primary)
                                              : (isDark 
                                                ? AppColors.darkTextSecondary 
                                                : AppColors.textSecondary),
                                      fontWeight:
                                          isLast
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                  ),
                                  if (!isLast) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 14,
                                      color: isDark 
                                        ? AppColors.darkOutlineVariant 
                                        : AppColors.outlineVariant,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ],
                              );
                            }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Action Buttons
            _buildAppBarActions(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions(BuildContext context, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        IconButton(
          onPressed:
              () => context.go(
                AppRoutes.dashboard,
              ),
          icon: Badge(
            label: const Text('3'),
            backgroundColor: isDark 
              ? AppColors.primaryLight 
              : AppColors.primary,
            textColor: isDark 
              ? AppColors.darkOnPrimary 
              : AppColors.onPrimary,
            child: Icon(
              Icons.notifications_outlined,
              color: isDark 
                ? AppColors.darkTextSecondary 
                : AppColors.textSecondary,
            ),
          ),
          tooltip: 'Notifications',
        ),

        // Search
        IconButton(
          onPressed:
              () => context.go(AppRoutes.dashboard),
          icon: Icon(
            Icons.search,
            color: isDark 
              ? AppColors.darkTextSecondary 
              : AppColors.textSecondary,
          ),
          tooltip: 'Search',
        ),

        // Profile Menu
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                context.go(AppRoutes.dashboard);
                break;
              case 'settings':
                context.go(AppRoutes.settings);
                break;
              case 'logout':
                _handleLogout(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.textSecondary,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: isDark 
                      ? AppColors.darkTextPrimary 
                      : AppColors.textPrimary,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.textSecondary,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: isDark 
                      ? AppColors.darkTextPrimary 
                      : AppColors.textPrimary,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppColors.error,
                ),
                title: const Text(
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
              backgroundColor: isDark 
                ? AppColors.primaryDark 
                : AppColors.primaryContainer,
              child: Text(
                'A',
                style: TextStyle(
                  color: isDark 
                    ? AppColors.primaryLight 
                    : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDark 
              ? AppColors.darkTextPrimary 
              : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDark 
              ? AppColors.darkTextSecondary 
              : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'No',
              style: TextStyle(
                color: isDark 
                  ? AppColors.primaryLight 
                  : AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = sl<LocalStorageService>();
              await storage.clearAll();

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}