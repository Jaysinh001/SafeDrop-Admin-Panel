// =============================================================================
// NAVIGATION ITEMS DATA CLASS
// =============================================================================

import 'package:flutter/material.dart';

class NavigationItem {
  final int id;
  final String title;
  final IconData icon;
  final String route;
  final List<String> breadcrumbs;
  final List<NavigationItem>? subItems;
  final String? badge;

  const NavigationItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.breadcrumbs,
    this.subItems,
    this.badge,
  });
}
