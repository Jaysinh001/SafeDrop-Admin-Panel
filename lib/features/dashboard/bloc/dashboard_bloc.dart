import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../model/dashboard_data_models.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardLoaded>(_onDashboardLoaded);
    on<DashboardRefreshed>(_onDashboardRefreshed);
    on<DashboardTimeRangeChanged>(_onTimeRangeChanged);

    // Auto load data initially
    add(DashboardLoaded());
  }

  Future<void> _onDashboardLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(emit);
  }

  Future<void> _onDashboardRefreshed(
    DashboardRefreshed event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(emit);
  }

  Future<void> _onTimeRangeChanged(
    DashboardTimeRangeChanged event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(selectedTimeRange: event.timeRange));
    await _loadDashboardData(emit);
  }

  Future<void> _loadDashboardData(Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));

      final revenueChartData = [
        ChartData('Jan', 12000),
        ChartData('Feb', 15000),
        ChartData('Mar', 18000),
        ChartData('Apr', 22000),
        ChartData('May', 25000),
        ChartData('Jun', 28000),
        ChartData('Jul', 32000),
      ];

      final userGrowthData = [
        ChartData('Jan', 100),
        ChartData('Feb', 150),
        ChartData('Mar', 200),
        ChartData('Apr', 280),
        ChartData('May', 350),
        ChartData('Jun', 420),
        ChartData('Jul', 500),
      ];

      final orderStatusData = [
        PieChartData('Completed', 65, AppColors.success),
        PieChartData('Pending', 20, AppColors.warning),
        PieChartData('Cancelled', 10, AppColors.error),
        PieChartData('Processing', 5, AppColors.info),
      ];

      final recentActivities = [
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

      final topProducts = [
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

      emit(
        state.copyWith(
          totalUsers: 1234,
          totalRevenue: 45678.90,
          totalOrders: 890,
          totalProducts: 156,
          revenueChartData: revenueChartData,
          userGrowthData: userGrowthData,
          orderStatusData: orderStatusData,
          recentActivities: recentActivities,
          topProducts: topProducts,
          isLoading: false,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
      emit(state.copyWith(isLoading: false));
    }
  }
}
