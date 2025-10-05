// =============================================================================
// NAVIGATION ITEMS CONFIGURATION
// =============================================================================

import 'package:flutter/material.dart';

import '../model/admin_navigation_item_model.dart';

class AdminNavigationItems {
  static const List<NavigationItem> items = [
    NavigationItem(
      id: 0,
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
      breadcrumbs: ['Home', 'Dashboard'],
    ),
    NavigationItem(
      id: 1,
      title: 'Users',
      icon: Icons.people,
      route: '/users',
      breadcrumbs: ['Home', 'Users'],
      subItems: [
        NavigationItem(
          id: 11,
          title: "Drivers",
          icon: Icons.personal_injury_outlined,
          route: '/driversList',
          breadcrumbs: ['Home', 'Users', 'Drivers'],
        ),
        NavigationItem(
          id: 12,
          title: 'Students',
          icon: Icons.person_4_outlined,
          route: '/studentsList',
          breadcrumbs: ['Home', 'Users', 'Students'],
        ),
      ],
    ),
    NavigationItem(
      id: 2,
      title: 'Finance',
      icon: Icons.article,
      route: '/finance',
      breadcrumbs: ['Home', 'Finance'],
      subItems: [
        NavigationItem(
          id: 21,
          title: 'Withdrawals',
          icon: Icons.arrow_circle_down,
          route: '/withdrawals',
          breadcrumbs: ['Home', 'Finance', 'Withdrawals'],
        ),
      ],
    ),
    NavigationItem(
      id: 3,
      title: 'Content',
      icon: Icons.article,
      route: '/content',
      breadcrumbs: ['Home', 'Content'],
      subItems: [
        NavigationItem(
          id: 31,
          title: 'All Content',
          icon: Icons.list,
          route: '/content/list',
          breadcrumbs: ['Home', 'Content', 'All Content'],
        ),
        NavigationItem(
          id: 32,
          title: 'Create New',
          icon: Icons.add,
          route: '/content/create',
          breadcrumbs: ['Home', 'Content', 'Create'],
        ),
        NavigationItem(
          id: 33,
          title: 'Media Library',
          icon: Icons.photo_library,
          route: '/content/media',
          breadcrumbs: ['Home', 'Content', 'Media'],
        ),
      ],
    ),
    NavigationItem(
      id: 4,
      title: 'Analytics',
      icon: Icons.analytics,
      route: '/admin/analytics',
      breadcrumbs: ['Home', 'Analytics'],
    ),
    NavigationItem(
      id: 5,
      title: 'Settings',
      icon: Icons.settings,
      route: '/admin/settings',
      breadcrumbs: ['Home', 'Settings'],
      subItems: [
        NavigationItem(
          id: 51,
          title: 'System Settings',
          icon: Icons.tune,
          route: '/admin/settings/system',
          breadcrumbs: ['Home', 'Settings', 'System'],
        ),
        NavigationItem(
          id: 52,
          title: 'User Roles',
          icon: Icons.admin_panel_settings,
          route: '/admin/roles',
          breadcrumbs: ['Home', 'Settings', 'Roles'],
        ),
      ],
    ),
    NavigationItem(
      id: 6,
      title: 'Reports',
      icon: Icons.assessment,
      route: '/admin/reports',
      breadcrumbs: ['Home', 'Reports'],
    ),
  ];
}
