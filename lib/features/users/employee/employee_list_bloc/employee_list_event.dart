part of 'employee_list_bloc.dart';

abstract class EmployeesListEvent extends Equatable {
  const EmployeesListEvent();

  @override
  List<Object?> get props => [];
}

class EmployeesListLoaded extends EmployeesListEvent {
  const EmployeesListLoaded();
}

class EmployeesListRefreshRequested extends EmployeesListEvent {
  const EmployeesListRefreshRequested();
}

class EmployeesListSearchQueryChanged extends EmployeesListEvent {
  final String query;

  const EmployeesListSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class EmployeesListFilterChanged extends EmployeesListEvent {
  final String filter;

  const EmployeesListFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class EmployeesListSortChanged extends EmployeesListEvent {
  final String sortBy;

  const EmployeesListSortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}