import 'package:equatable/equatable.dart';

abstract class AdminLayoutEvent extends Equatable {
  const AdminLayoutEvent();

  @override
  List<Object?> get props => [];
}

class AdminLayoutScreenSizeUpdated extends AdminLayoutEvent {
  final double width;
  const AdminLayoutScreenSizeUpdated(this.width);

  @override
  List<Object> get props => [width];
}

class AdminLayoutSidebarVisibilityToggled extends AdminLayoutEvent {}

class AdminLayoutSidebarExpansionToggled extends AdminLayoutEvent {}

class AdminLayoutPageNavigated extends AdminLayoutEvent {
  final int index;
  final String title;
  final String route;
  final List<String>? breadcrumbs;

  const AdminLayoutPageNavigated({
    required this.index,
    required this.title,
    required this.route,
    this.breadcrumbs,
  });

  @override
  List<Object?> get props => [index, title, route, breadcrumbs];
}
