import 'package:equatable/equatable.dart';

abstract class TransactionsListEvent extends Equatable {
  const TransactionsListEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsListLoaded extends TransactionsListEvent {}

class TransactionsListRefreshed extends TransactionsListEvent {}

class TransactionsListSearchQueryChanged extends TransactionsListEvent {
  final String query;
  const TransactionsListSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class TransactionsListFilterChanged extends TransactionsListEvent {
  final String filter;
  const TransactionsListFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class TransactionsListSortChanged extends TransactionsListEvent {
  final String sortBy;
  const TransactionsListSortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}
