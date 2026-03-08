import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../widgets/screen_container.dart';
import '../bloc/admin_layout_bloc.dart';
import '../bloc/admin_layout_event.dart';
import '../bloc/admin_layout_state.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

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
            BlocBuilder<AdminLayoutBloc, AdminLayoutState>(
              buildWhen:
                  (previous, current) =>
                      previous.screenSize != current.screenSize ||
                      previous.isSidebarVisible != current.isSidebarVisible,
              builder: (context, state) {
                if (state.screenSize == ScreenSize.mobile) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed:
                            () => context.read<AdminLayoutBloc>().add(
                              AdminLayoutSidebarVisibilityToggled(),
                            ),
                        icon:
                            state.isSidebarVisible
                                ? const Icon(Icons.cancel_outlined)
                                : const Icon(Icons.menu),
                        tooltip: 'Toggle Sidebar',
                      ),
                      const SizedBox(width: 8),
                    ],
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
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                      fontWeight:
                                          isLast
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                    ),
                                  ),
                                  if (!isLast) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
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
                    },
                  ),
                ],
              ),
            ),

            // Action Buttons
            _buildAppBarActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        IconButton(
          onPressed:
              () => context.go(
                AppRoutes.dashboard,
              ), // Placeholder for notifications
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_outlined),
          ),
          tooltip: 'Notifications',
        ),

        // Search
        IconButton(
          onPressed:
              () => context.go(AppRoutes.dashboard), // Placeholder for search
          icon: const Icon(Icons.search),
          tooltip: 'Search',
        ),

        // Profile Menu
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                context.go(AppRoutes.dashboard); // Placeholder for profile
                break;
              case 'settings':
                context.go(AppRoutes.settings);
                break;
              case 'logout':
                _handleLogout(context);
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
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

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.login);
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
