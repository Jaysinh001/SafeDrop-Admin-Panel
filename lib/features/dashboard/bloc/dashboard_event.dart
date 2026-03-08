import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardEvent {}

class DashboardRefreshed extends DashboardEvent {}

class DashboardTimeRangeChanged extends DashboardEvent {
  final String timeRange;

  const DashboardTimeRangeChanged(this.timeRange);

  @override
  List<Object?> get props => [timeRange];
}
