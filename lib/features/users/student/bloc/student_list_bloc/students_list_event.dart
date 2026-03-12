import 'package:equatable/equatable.dart';

abstract class StudentsListEvent extends Equatable {
  const StudentsListEvent();

  @override
  List<Object?> get props => [];
}

class StudentsListLoaded extends StudentsListEvent {}

class StudentsListSearchQueryChanged extends StudentsListEvent {
  final String query;
  const StudentsListSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class StudentsListFilterChanged extends StudentsListEvent {
  final String filter;
  const StudentsListFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class StudentsListSortChanged extends StudentsListEvent {
  final String sortBy;
  const StudentsListSortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class StudentsListRefreshRequested extends StudentsListEvent {}
