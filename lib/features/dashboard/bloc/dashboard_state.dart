import 'package:equatable/equatable.dart';
import '../model/dashboard_data_models.dart';

class DashboardState extends Equatable {
  final int totalUsers;
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final bool isLoading;
  final String selectedTimeRange;

  final List<ChartData> revenueChartData;
  final List<ChartData> userGrowthData;
  final List<PieChartData> orderStatusData;

  final List<ActivityItem> recentActivities;
  final List<ProductItem> topProducts;

  const DashboardState({
    this.totalUsers = 0,
    this.totalRevenue = 0.0,
    this.totalOrders = 0,
    this.totalProducts = 0,
    this.isLoading = false,
    this.selectedTimeRange = 'This Month',
    this.revenueChartData = const [],
    this.userGrowthData = const [],
    this.orderStatusData = const [],
    this.recentActivities = const [],
    this.topProducts = const [],
  });

  DashboardState copyWith({
    int? totalUsers,
    double? totalRevenue,
    int? totalOrders,
    int? totalProducts,
    bool? isLoading,
    String? selectedTimeRange,
    List<ChartData>? revenueChartData,
    List<ChartData>? userGrowthData,
    List<PieChartData>? orderStatusData,
    List<ActivityItem>? recentActivities,
    List<ProductItem>? topProducts,
  }) {
    return DashboardState(
      totalUsers: totalUsers ?? this.totalUsers,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalOrders: totalOrders ?? this.totalOrders,
      totalProducts: totalProducts ?? this.totalProducts,
      isLoading: isLoading ?? this.isLoading,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      revenueChartData: revenueChartData ?? this.revenueChartData,
      userGrowthData: userGrowthData ?? this.userGrowthData,
      orderStatusData: orderStatusData ?? this.orderStatusData,
      recentActivities: recentActivities ?? this.recentActivities,
      topProducts: topProducts ?? this.topProducts,
    );
  }

  @override
  List<Object?> get props => [
    totalUsers,
    totalRevenue,
    totalOrders,
    totalProducts,
    isLoading,
    selectedTimeRange,
    revenueChartData,
    userGrowthData,
    orderStatusData,
    recentActivities,
    topProducts,
  ];
}
