import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../model/dashboard_data_models.dart';

// =============================================================================
// DASHBOARD CONTROLLER - GetX Controller for dashboard logic
// =============================================================================

class DashboardController extends GetxController {
  // Dashboard stats
  final _totalUsers = 0.obs;
  final _totalRevenue = 0.0.obs;
  final _totalOrders = 0.obs;
  final _totalProducts = 0.obs;
  final _isLoading = false.obs;
  final _selectedTimeRange = 'This Month'.obs;

  // Chart data
  final _revenueChartData = <ChartData>[].obs;
  final _userGrowthData = <ChartData>[].obs;
  final _orderStatusData = <PieChartData>[].obs;

  // Recent activities
  final _recentActivities = <ActivityItem>[].obs;
  final _topProducts = <ProductItem>[].obs;

  // Getters
  int get totalUsers => _totalUsers.value;
  double get totalRevenue => _totalRevenue.value;
  int get totalOrders => _totalOrders.value;
  int get totalProducts => _totalProducts.value;
  bool get isLoading => _isLoading.value;
  String get selectedTimeRange => _selectedTimeRange.value;
  List<ChartData> get revenueChartData => _revenueChartData.toList();
  List<ChartData> get userGrowthData => _userGrowthData.toList();
  List<PieChartData> get orderStatusData => _orderStatusData.toList();
  List<ActivityItem> get recentActivities => _recentActivities.toList();
  List<ProductItem> get topProducts => _topProducts.toList();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void changeTimeRange(String timeRange) {
    _selectedTimeRange.value = timeRange;
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Load stats
      _totalUsers.value = 1234;
      _totalRevenue.value = 45678.90;
      _totalOrders.value = 890;
      _totalProducts.value = 156;

      // Load chart data
      _loadChartData();
      _loadRecentActivities();
      _loadTopProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadChartData() {
    // Revenue chart data
    _revenueChartData.value = [
      ChartData('Jan', 12000),
      ChartData('Feb', 15000),
      ChartData('Mar', 18000),
      ChartData('Apr', 22000),
      ChartData('May', 25000),
      ChartData('Jun', 28000),
      ChartData('Jul', 32000),
    ];

    // User growth data
    _userGrowthData.value = [
      ChartData('Jan', 100),
      ChartData('Feb', 150),
      ChartData('Mar', 200),
      ChartData('Apr', 280),
      ChartData('May', 350),
      ChartData('Jun', 420),
      ChartData('Jul', 500),
    ];

    // Order status pie chart
    _orderStatusData.value = [
      PieChartData('Completed', 65, AppColors.success),
      PieChartData('Pending', 20, AppColors.warning),
      PieChartData('Cancelled', 10, AppColors.error),
      PieChartData('Processing', 5, AppColors.info),
    ];
  }

  void _loadRecentActivities() {
    _recentActivities.value = [
      ActivityItem(
        title: 'New user registered',
        subtitle: 'john.doe@email.com',
        time: '2 minutes ago',
        icon: Icons.person_add,
        iconColor: AppColors.success,
      ),
      ActivityItem(
        title: 'Order #1234 completed',
        subtitle: 'Payment received',
        time: '5 minutes ago',
        icon: Icons.shopping_bag,
        iconColor: AppColors.info,
      ),
      ActivityItem(
        title: 'Product stock low',
        subtitle: 'iPhone 15 Pro',
        time: '10 minutes ago',
        icon: Icons.warning,
        iconColor: AppColors.warning,
      ),
      ActivityItem(
        title: 'System backup completed',
        subtitle: 'All data backed up',
        time: '1 hour ago',
        icon: Icons.backup,
        iconColor: AppColors.success,
      ),
    ];
  }

  void _loadTopProducts() {
    _topProducts.value = [
      ProductItem(
        name: 'iPhone 15 Pro',
        sales: 234,
        revenue: 234000,
        trend: 12.5,
        image: 'assets/products/iphone.jpg',
      ),
      ProductItem(
        name: 'MacBook Air M3',
        sales: 156,
        revenue: 187200,
        trend: 8.3,
        image: 'assets/products/macbook.jpg',
      ),
      ProductItem(
        name: 'AirPods Pro',
        sales: 345,
        revenue: 86250,
        trend: -2.1,
        image: 'assets/products/airpods.jpg',
      ),
      ProductItem(
        name: 'iPad Pro',
        sales: 98,
        revenue: 117600,
        trend: 15.7,
        image: 'assets/products/ipad.jpg',
      ),
    ];
  }

  void refreshData() {
    loadDashboardData();
  }
}

// =============================================================================
// STAT CARD COMPONENT
// =============================================================================

class StatCardData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double trend;

  StatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

class StatCard extends StatelessWidget {
  final StatCardData data;

  const StatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(data.icon, color: data.color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, color: data.color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              data.value,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  data.trend >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: data.trend >= 0 ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  data.subtitle,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color:
                        data.trend >= 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ACTIVITY TILE COMPONENT
// =============================================================================

class ActivityTile extends StatelessWidget {
  final ActivityItem activity;

  const ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: activity.iconColor.withOpacity(0.1),
        child: Icon(activity.icon, color: activity.iconColor, size: 20),
      ),
      title: Text(
        activity.title,
        style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(activity.subtitle),
      trailing: Text(
        activity.time,
        style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
      ),
    );
  }
}

// =============================================================================
// PRODUCT TILE COMPONENT
// =============================================================================

class ProductTile extends StatelessWidget {
  final ProductItem product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.phone_iphone, color: AppColors.primary),
      ),
      title: Text(
        product.name,
        style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${product.sales} sales • ₹${product.revenue.toStringAsFixed(0)}',
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              product.trend >= 0
                  ? AppColors.successContainer
                  : AppColors.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${product.trend >= 0 ? '+' : ''}${product.trend.toStringAsFixed(1)}%',
          style: TextStyle(
            color: product.trend >= 0 ? AppColors.success : AppColors.error,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SIMPLE CHART COMPONENTS (Placeholder implementations)
// =============================================================================

class SimpleLineChart extends StatelessWidget {
  final List<ChartData> data;
  final Color color;

  const SimpleLineChart({super.key, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: color.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              'Revenue Chart',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '(Chart library implementation needed)',
              style: Get.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimplePieChart extends StatelessWidget {
  final List<PieChartData> data;

  const SimplePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart,
                    size: 48,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order Status Chart',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '(Chart library implementation needed)',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children:
              data
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.label} (${item.percentage.toInt()}%)',
                          style: Get.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
