// =============================================================================
// DASHBOARD VIEW - Responsive dashboard implementation
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingView(title: "Dashboard Loading ...");
        }
        return _buildDashboardContent(context);
      }),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(context),
          const SizedBox(height: 24),
          _buildStatsCards(context),
          const SizedBox(height: 32),
          _buildChartsSection(context),
          const SizedBox(height: 32),
          _buildBottomSection(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (context.width > 1200) return const EdgeInsets.all(32);
    if (context.width > 768) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back! Here\'s what\'s happening with your store today.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (context.width > 768) ...[
          const SizedBox(width: 16),
          _buildTimeRangeSelector(),
          const SizedBox(width: 16),
          _buildRefreshButton(),
        ],
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedTimeRange,
            items:
                ['Today', 'This Week', 'This Month', 'This Year']
                    .map(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.changeTimeRange(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return ElevatedButton.icon(
      onPressed: controller.refreshData,
      icon: const Icon(Icons.refresh, size: 16),
      label: const Text('Refresh'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Obx(() {
      final stats = [
        StatCardData(
          title: 'Total Users',
          value: controller.totalUsers.toString(),
          subtitle: '+12% from last month',
          icon: Icons.people,
          color: AppColors.primary,
          trend: 12.0,
        ),
        StatCardData(
          title: 'Revenue',
          value: '₹${controller.totalRevenue.toStringAsFixed(2)}',
          subtitle: '+8% from last month',
          icon: Icons.monetization_on,
          color: AppColors.success,
          trend: 8.0,
        ),
        StatCardData(
          title: 'Orders',
          value: controller.totalOrders.toString(),
          subtitle: '+15% from last month',
          icon: Icons.shopping_bag,
          color: AppColors.info,
          trend: 15.0,
        ),
        StatCardData(
          title: 'Products',
          value: controller.totalProducts.toString(),
          subtitle: '+3% from last month',
          icon: Icons.inventory,
          color: AppColors.warning,
          trend: 3.0,
        ),
      ];

      return LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double childAspectRatio;

          if (constraints.maxWidth > 1200) {
            crossAxisCount = 4;
            childAspectRatio = 1.2;
          } else if (constraints.maxWidth > 768) {
            crossAxisCount = 2;
            childAspectRatio = 1.3;
          } else {
            crossAxisCount = 1;
            childAspectRatio = 2.5;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) => StatCard(data: stats[index]),
          );
        },
      );
    });
  }

  Widget _buildChartsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRevenueChart()),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildOrderStatusChart()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRevenueChart(),
              const SizedBox(height: 24),
              _buildOrderStatusChart(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Revenue Overview',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.trending_up, color: AppColors.success, size: 20),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: Obx(
                () => SimpleLineChart(
                  data: controller.revenueChartData,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: Obx(
                () => SimplePieChart(data: controller.orderStatusData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildRecentActivity()),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildTopProducts()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRecentActivity(),
              const SizedBox(height: 24),
              _buildTopProducts(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Activity',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed('/admin/activities'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.recentActivities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = controller.recentActivities[index];
                  return ActivityTile(activity: activity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Top Products',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed('/admin/products'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.topProducts.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final product = controller.topProducts[index];
                  return ProductTile(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
