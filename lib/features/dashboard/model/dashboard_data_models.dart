// =============================================================================
// DATA MODELS
// =============================================================================

import 'package:flutter/material.dart';

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class PieChartData {
  final String label;
  final double percentage;
  final Color color;

  PieChartData(this.label, this.percentage, this.color);
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class ProductItem {
  final String name;
  final int sales;
  final double revenue;
  final double trend;
  final String image;

  ProductItem({
    required this.name,
    required this.sales,
    required this.revenue,
    required this.trend,
    required this.image,
  });
}
