// // =============================================================================
// // NAVIGATION ITEMS CONFIGURATION
// // =============================================================================

// import 'package:flutter/material.dart';

// import '../model/admin_navigation_item_model.dart';

// class AdminNavigationItems {
//   static const List<NavigationItem> items = [
//     NavigationItem(
//       id: 0,
//       title: 'Dashboard',
//       icon: Icons.dashboard,
//       route: '/dashboard',
//       breadcrumbs: ['Home', 'Dashboard'],
//     ),
//     NavigationItem(
//       id: 1,
//       title: 'Users',
//       icon: Icons.people,
//       route: '/users',
//       breadcrumbs: ['Home', 'Users'],
//       subItems: [
//         NavigationItem(
//           id: 11,
//           title: "Drivers",
//           icon: Icons.personal_injury_outlined,
//           route: '/driversList',
//           breadcrumbs: ['Home', 'Users', 'Drivers'],
//         ),
//         NavigationItem(
//           id: 12,
//           title: 'Students',
//           icon: Icons.person_4_outlined,
//           route: '/studentsList',
//           breadcrumbs: ['Home', 'Users', 'Students'],
//         ),
//       ],
//     ),
//     NavigationItem(
//       id: 2,
//       title: 'Finance',
//       icon: Icons.article,
//       route: '/finance',
//       breadcrumbs: ['Home', 'Finance'],
//       subItems: [
//         NavigationItem(
//           id: 21,
//           title: 'Withdrawals',
//           icon: Icons.arrow_circle_down,
//           route: '/withdrawals',
//           breadcrumbs: ['Home', 'Finance', 'Withdrawals'],
//         ),
//         NavigationItem(
//           id: 22,
//           title: 'Transactions',
//           icon: Icons.currency_exchange_rounded,
//           route: '/transactions',
//           breadcrumbs: ['Home', 'Finance', 'Transactions'],
//         ),
//       ],
//     ),
//     NavigationItem(
//       id: 3,
//       title: 'Content',
//       icon: Icons.article,
//       route: '/content',
//       breadcrumbs: ['Home', 'Content'],
//       subItems: [
//         NavigationItem(
//           id: 31,
//           title: 'All Content',
//           icon: Icons.list,
//           route: '/content/list',
//           breadcrumbs: ['Home', 'Content', 'All Content'],
//         ),
//         NavigationItem(
//           id: 32,
//           title: 'Create New',
//           icon: Icons.add,
//           route: '/content/create',
//           breadcrumbs: ['Home', 'Content', 'Create'],
//         ),
//         NavigationItem(
//           id: 33,
//           title: 'Media Library',
//           icon: Icons.photo_library,
//           route: '/content/media',
//           breadcrumbs: ['Home', 'Content', 'Media'],
//         ),
//       ],
//     ),
//     NavigationItem(
//       id: 4,
//       title: 'Analytics',
//       icon: Icons.analytics,
//       route: '/admin/analytics',
//       breadcrumbs: ['Home', 'Analytics'],
//     ),
//     NavigationItem(
//       id: 5,
//       title: 'Settings',
//       icon: Icons.settings,
//       route: '/admin/settings',
//       breadcrumbs: ['Home', 'Settings'],
//       subItems: [
//         NavigationItem(
//           id: 51,
//           title: 'System Settings',
//           icon: Icons.tune,
//           route: '/admin/settings/system',
//           breadcrumbs: ['Home', 'Settings', 'System'],
//         ),
//         NavigationItem(
//           id: 52,
//           title: 'User Roles',
//           icon: Icons.admin_panel_settings,
//           route: '/admin/roles',
//           breadcrumbs: ['Home', 'Settings', 'Roles'],
//         ),
//       ],
//     ),
//     NavigationItem(
//       id: 6,
//       title: 'Reports',
//       icon: Icons.assessment,
//       route: '/admin/reports',
//       breadcrumbs: ['Home', 'Reports'],
//     ),
//     NavigationItem(
//       id: 7,
//       title: 'RBAC',
//       icon: Icons.security,
//       route: '/admin/rbac',
//       breadcrumbs: ['Home', 'RBAC'],
//     ),
//   ];
// }



// =============================================================================
// NAVIGATION ITEMS CONFIGURATION
// SafeDrop Organization Admin Panel
// =============================================================================

import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../model/admin_navigation_item_model.dart';

class AdminNavigationItems {
  static const List<NavigationItem> items = [
    // -------------------------------------------------------------------------
    // DASHBOARD
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 0,
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: '/dashboard',
      breadcrumbs: ['Home', 'Dashboard'],
    ),

    // -------------------------------------------------------------------------
    // USERS & MEMBERS
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 1,
      title: 'Users',
      icon: Icons.people_alt_rounded,
      route: '/users',
      breadcrumbs: ['Home', 'Users'],
      subItems: [
        NavigationItem(
          id: 11,
          title: 'Members',
          icon: Icons.group_rounded,
          route: '/users/members',
          breadcrumbs: ['Home', 'Users', 'Members'],
        ),
        NavigationItem(
          id: 12,
          title: 'Drivers',
          icon: Icons.drive_eta_rounded,
          route: '/users/drivers',
          breadcrumbs: ['Home', 'Users', 'Drivers'],
        ),
        NavigationItem(
          id: 13,
          title: 'Students',
          icon: Icons.school_rounded,
          route: '/users/students',
          breadcrumbs: ['Home', 'Users', 'Students'],
        ),
        NavigationItem(
          id: 14,
          title: 'Employees',
          icon: Icons.badge_rounded,
          route: '/users/employees',
          breadcrumbs: ['Home', 'Users', 'Employees'],
        ),
        NavigationItem(
          id: 15,
          title: 'Invitations',
          icon: Icons.mail_rounded,
          route: '/users/invitations',
          breadcrumbs: ['Home', 'Users', 'Invitations'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // ROLES & PERMISSIONS (RBAC)
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 2,
      title: 'Roles & Permissions',
      icon: Icons.admin_panel_settings_rounded,
      route: '/rbac',
      breadcrumbs: ['Home', 'Roles & Permissions'],
      subItems: [
        NavigationItem(
          id: 21,
          title: 'Roles',
          icon: Icons.manage_accounts_rounded,
          route: '/rbac/roles',
          breadcrumbs: ['Home', 'Roles & Permissions', 'Roles'],
        ),
        NavigationItem(
          id: 22,
          title: 'Permission Groups',
          icon: Icons.security_rounded,
          route: '/rbac/permission-groups',
          breadcrumbs: ['Home', 'Roles & Permissions', 'Permission Groups'],
        ),
        NavigationItem(
          id: 23,
          title: 'User Overrides',
          icon: Icons.tune_rounded,
          route: '/rbac/user-overrides',
          breadcrumbs: ['Home', 'Roles & Permissions', 'User Overrides'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // ROUTES & VEHICLES
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 3,
      title: 'Routes & Vehicles',
      icon: Icons.alt_route_rounded,
      route: '/routes',
      breadcrumbs: ['Home', 'Routes & Vehicles'],
      subItems: [
        NavigationItem(
          id: 31,
          title: 'Routes',
          icon: Icons.route_rounded,
          route: '/routes/list',
          breadcrumbs: ['Home', 'Routes & Vehicles', 'Routes'],
        ),
        NavigationItem(
          id: 32,
          title: 'Route Stops',
          icon: Icons.place_rounded,
          route: '/routes/stops',
          breadcrumbs: ['Home', 'Routes & Vehicles', 'Route Stops'],
        ),
        NavigationItem(
          id: 33,
          title: 'Vehicles',
          icon: Icons.directions_bus_rounded,
          route: '/routes/vehicles',
          breadcrumbs: ['Home', 'Routes & Vehicles', 'Vehicles'],
        ),
        NavigationItem(
          id: 34,
          title: 'Driver Schedules',
          icon: Icons.calendar_month_rounded,
          route: '/routes/driver-schedules',
          breadcrumbs: ['Home', 'Routes & Vehicles', 'Driver Schedules'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // LIVE TRACKING
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 4,
      title: 'Live Tracking',
      icon: Icons.my_location_rounded,
      route: '/tracking',
      breadcrumbs: ['Home', 'Live Tracking'],
    ),

    // -------------------------------------------------------------------------
    // TRIP SESSIONS
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 5,
      title: 'Trip Sessions',
      icon: Icons.directions_rounded,
      route: '/trips',
      breadcrumbs: ['Home', 'Trip Sessions'],
      subItems: [
        NavigationItem(
          id: 51,
          title: 'Active Sessions',
          icon: Icons.play_circle_rounded,
          route: '/trips/active',
          breadcrumbs: ['Home', 'Trip Sessions', 'Active Sessions'],
        ),
        NavigationItem(
          id: 52,
          title: 'History',
          icon: Icons.history_rounded,
          route: '/trips/history',
          breadcrumbs: ['Home', 'Trip Sessions', 'History'],
        ),
        NavigationItem(
          id: 53,
          title: 'Attendance',
          icon: Icons.fact_check_rounded,
          route: '/trips/attendance',
          breadcrumbs: ['Home', 'Trip Sessions', 'Attendance'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // FINANCE
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 6,
      title: 'Finance',
      icon: Icons.account_balance_wallet_rounded,
      route: '/finance',
      breadcrumbs: ['Home', 'Finance'],
      subItems: [
        NavigationItem(
          id: 61,
          title: 'Billing Cycles',
          icon: Icons.receipt_long_rounded,
          route: '/finance/billing-cycles',
          breadcrumbs: ['Home', 'Finance', 'Billing Cycles'],
        ),
        NavigationItem(
          id: 62,
          title: 'Payments',
          icon: Icons.payments_rounded,
          route: '/finance/payments',
          breadcrumbs: ['Home', 'Finance', 'Payments'],
        ),
        NavigationItem(
          id: 63,
          title: 'Penalty Rules',
          icon: Icons.gavel_rounded,
          route: '/finance/penalty-rules',
          breadcrumbs: ['Home', 'Finance', 'Penalty Rules'],
        ),
        NavigationItem(
          id: 64,
          title: 'Wallet',
          icon: Icons.account_balance_rounded,
          route: '/finance/wallet',
          breadcrumbs: ['Home', 'Finance', 'Wallet'],
        ),
        NavigationItem(
          id: 65,
          title: 'Transactions',
          icon: Icons.currency_exchange_rounded,
          route: '/finance/transactions',
          breadcrumbs: ['Home', 'Finance', 'Transactions'],
        ),
        NavigationItem(
          id: 66,
          title: 'Withdrawals',
          icon: Icons.arrow_circle_down_rounded,
          route: '/finance/withdrawals',
          breadcrumbs: ['Home', 'Finance', 'Withdrawals'],
        ),
        NavigationItem(
          id: 67,
          title: 'Bank Accounts',
          icon: Icons.credit_card_rounded,
          route: '/finance/bank-accounts',
          breadcrumbs: ['Home', 'Finance', 'Bank Accounts'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // CORPORATE TRANSPORT
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 7,
      title: 'Corporate',
      icon: Icons.corporate_fare_rounded,
      route: '/corporate',
      breadcrumbs: ['Home', 'Corporate'],
      subItems: [
        NavigationItem(
          id: 71,
          title: 'Departments',
          icon: Icons.account_tree_rounded,
          route: '/corporate/departments',
          breadcrumbs: ['Home', 'Corporate', 'Departments'],
        ),
        NavigationItem(
          id: 72,
          title: 'Work Shifts',
          icon: Icons.access_time_rounded,
          route: '/corporate/work-shifts',
          breadcrumbs: ['Home', 'Corporate', 'Work Shifts'],
        ),
        NavigationItem(
          id: 73,
          title: 'Pickup Points',
          icon: Icons.location_on_rounded,
          route: '/corporate/pickup-points',
          breadcrumbs: ['Home', 'Corporate', 'Pickup Points'],
        ),
        NavigationItem(
          id: 74,
          title: 'Transport Contracts',
          icon: Icons.handshake_rounded,
          route: '/corporate/contracts',
          breadcrumbs: ['Home', 'Corporate', 'Transport Contracts'],
        ),
        NavigationItem(
          id: 75,
          title: 'Corporate Billing',
          icon: Icons.request_quote_rounded,
          route: '/corporate/billing',
          breadcrumbs: ['Home', 'Corporate', 'Corporate Billing'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // COMMUNICATION
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 8,
      title: 'Communication',
      icon: Icons.forum_rounded,
      route: '/communication',
      breadcrumbs: ['Home', 'Communication'],
      subItems: [
        NavigationItem(
          id: 81,
          title: 'Announcements',
          icon: Icons.campaign_rounded,
          route: '/communication/announcements',
          breadcrumbs: ['Home', 'Communication', 'Announcements'],
        ),
        NavigationItem(
          id: 82,
          title: 'Chat Threads',
          icon: Icons.chat_rounded,
          route: '/communication/chat',
          breadcrumbs: ['Home', 'Communication', 'Chat Threads'],
        ),
        NavigationItem(
          id: 83,
          title: 'Notifications',
          icon: Icons.notifications_rounded,
          route: '/communication/notifications',
          breadcrumbs: ['Home', 'Communication', 'Notifications'],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // AUDIT LOG
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 9,
      title: 'Audit Log',
      icon: Icons.policy_rounded,
      route: '/audit-log',
      breadcrumbs: ['Home', 'Audit Log'],
    ),

    // -------------------------------------------------------------------------
    // SETTINGS
    // -------------------------------------------------------------------------
    NavigationItem(
      id: 10,
      title: 'Settings',
      icon: Icons.settings_rounded,
      route: '/settings',
      breadcrumbs: ['Home', 'Settings'],
      subItems: [
        NavigationItem(
          id: 101,
          title: 'Organization Profile',
          icon: Icons.business_rounded,
          route: AppRoutes.organizationProfile,
          breadcrumbs: ['Home', 'Settings', 'Organization Profile'],
        ),
        NavigationItem(
          id: 102,
          title: 'Subscription Plan',
          icon: Icons.workspace_premium_rounded,
          route: '/settings/subscription',
          breadcrumbs: ['Home', 'Settings', 'Subscription Plan'],
        ),
        NavigationItem(
          id: 103,
          title: 'System Settings',
          icon: Icons.tune_rounded,
          route: '/settings/system',
          breadcrumbs: ['Home', 'Settings', 'System Settings'],
        ),
      ],
    ),
  ];
}