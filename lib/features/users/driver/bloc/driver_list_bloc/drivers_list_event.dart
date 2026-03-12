import 'package:equatable/equatable.dart';

abstract class DriversListEvent extends Equatable {
  const DriversListEvent();

  @override
  List<Object?> get props => [];
}

class DriversListLoaded extends DriversListEvent {}

class DriversListRefreshed extends DriversListEvent {}

class DriversListSearchQueryChanged extends DriversListEvent {
  final String query;
  const DriversListSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class DriversListFilterChanged extends DriversListEvent {
  final String filter;
  const DriversListFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class DriversListSortByChanged extends DriversListEvent {
  final String sortBy;
  const DriversListSortByChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}
