// =============================================================================
// DASHBOARD VIEW - Responsive dashboard implementation
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/loading_view.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../core/dependencies/injection_container.dart';
import '../model/dashboard_data_models.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<DashboardBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen:
              (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingView(title: "Dashboard Loading ...");
            }
            return _buildDashboardContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardState state) {
    return SingleChildScrollView(
      padding: _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(context, state),
          const SizedBox(height: 24),
          _buildStatsCards(context, state),
          const SizedBox(height: 32),
          _buildChartsSection(context, state),
          const SizedBox(height: 32),
          _buildBottomSection(context, state),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return const EdgeInsets.all(32);
    if (width > 768) return const EdgeInsets.all(24);
    return const EdgeInsets.all(16);
  }

  Widget _buildDashboardHeader(BuildContext context, DashboardState state) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back! Here\'s what\'s happening with your store today.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (width > 768) ...[
          const SizedBox(width: 16),
          _buildTimeRangeSelector(context, state),
          const SizedBox(width: 16),
          _buildRefreshButton(context),
        ],
      ],
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedTimeRange,
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
              context.read<DashboardBloc>().add(
                DashboardTimeRangeChanged(newValue),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.read<DashboardBloc>().add(DashboardRefreshed()),
      icon: const Icon(Icons.refresh, size: 16),
      label: const Text('Refresh'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    final stats = [
      StatCardData(
        title: 'Total Users',
        value: state.totalUsers.toString(),
        subtitle: '+12% from last month',
        icon: Icons.people,
        color: colorScheme.primary,
        trend: 12.0,
      ),
      StatCardData(
        title: 'Revenue',
        value: '₹${state.totalRevenue.toStringAsFixed(2)}',
        subtitle: '+8% from last month',
        icon: Icons.monetization_on,
        color: AppColors.success,
        trend: 8.0,
      ),
      StatCardData(
        title: 'Orders',
        value: state.totalOrders.toString(),
        subtitle: '+15% from last month',
        icon: Icons.shopping_bag,
        color: AppColors.info,
        trend: 15.0,
      ),
      StatCardData(
        title: 'Products',
        value: state.totalProducts.toString(),
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
  }

  Widget _buildChartsSection(BuildContext context, DashboardState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRevenueChart(context, state)),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildOrderStatusChart(context, state)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRevenueChart(context, state),
              const SizedBox(height: 24),
              _buildOrderStatusChart(context, state),
            ],
          );
        }
      },
    );
  }

  Widget _buildRevenueChart(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(Icons.trending_up, color: AppColors.success, size: 20),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: SimpleLineChart(
                data: state.revenueChartData,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusChart(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: SimplePieChart(data: state.orderStatusData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, DashboardState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildRecentActivity(context, state)),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildTopProducts(context, state)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRecentActivity(context, state),
              const SizedBox(height: 24),
              _buildTopProducts(context, state),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/admin/activities'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.recentActivities.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: colorScheme.outlineVariant, height: 1),
              itemBuilder: (context, index) {
                final activity = state.recentActivities[index];
                return ActivityTile(activity: activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/admin/products'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.topProducts.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: colorScheme.outlineVariant, height: 1),
              itemBuilder: (context, index) {
                final product = state.topProducts[index];
                return ProductTile(product: product);
              },
            ),
          ],
        ),
      ),
    );
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
    final colorScheme = Theme.of(context).colorScheme;

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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  data.trend >= 0 ? Icons.trending_up : Icons.trending_down,
                  color:
                      data.trend >= 0 ? AppColors.success : colorScheme.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  data.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        data.trend >= 0 ? AppColors.success : colorScheme.error,
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
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: activity.iconColor.withOpacity(0.1),
        child: Icon(activity.icon, color: activity.iconColor, size: 20),
      ),
      title: Text(
        activity.title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        activity.subtitle,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        activity.time,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
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
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.phone_iphone, color: colorScheme.primary),
      ),
      title: Text(
        product.name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        '${product.sales} sales • ₹${product.revenue.toStringAsFixed(0)}',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              product.trend >= 0
                  ? AppColors.successContainer
                  : colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${product.trend >= 0 ? '+' : ''}${product.trend.toStringAsFixed(1)}%',
          style: TextStyle(
            color: product.trend >= 0 ? AppColors.success : colorScheme.error,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '(Chart library implementation needed)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.6),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart,
                    size: 48,
                    color: colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order Status Chart',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '(Chart library implementation needed)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurface),
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
