import 'package:equatable/equatable.dart';

abstract class DriverDetailsEvent extends Equatable {
  const DriverDetailsEvent();

  @override
  List<Object?> get props => [];
}

class DriverDetailsLoaded extends DriverDetailsEvent {
  final int? driverId;
  const DriverDetailsLoaded({this.driverId});

  @override
  List<Object?> get props => [driverId];
}

class DriverDetailsRefreshed extends DriverDetailsEvent {}

class DriverDetailsTabChanged extends DriverDetailsEvent {
  final int index;
  const DriverDetailsTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class DriverDetailsSuspendRequested extends DriverDetailsEvent {}

class DriverDetailsContactRequested extends DriverDetailsEvent {}

class DriverDetailsNotificationRequested extends DriverDetailsEvent {}
