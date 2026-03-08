import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../model/transactions_list_model.dart';
import 'transactions_list_event.dart';
import 'transactions_list_state.dart';

class TransactionsListBloc
    extends Bloc<TransactionsListEvent, TransactionsListState> {
  // Filter options
  final List<String> filterOptions = [
    'all',
    'Success',
    'Pending',
    'Created',
    'Failed',
    'online',
    'cash',
  ];

  // Sort options
  final List<String> sortOptions = ['date', 'amount', 'student', 'status'];

  TransactionsListBloc() : super(const TransactionsListState()) {
    on<TransactionsListLoaded>(_onLoaded);
    on<TransactionsListRefreshed>(_onRefreshed);
    on<TransactionsListSearchQueryChanged>(_onSearchQueryChanged);
    on<TransactionsListFilterChanged>(_onFilterChanged);
    on<TransactionsListSortChanged>(_onSortChanged);

    // Initial load
    add(TransactionsListLoaded());
  }

  Future<void> _onLoaded(
    TransactionsListLoaded event,
    Emitter<TransactionsListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _onRefreshed(
    TransactionsListRefreshed event,
    Emitter<TransactionsListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<TransactionsListState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final res = await NetworkServicesApi().getApi(path: 'allTransactions');
      final response = transactionsListResponseFromJson(res);

      if (response.success == true) {
        final transactions = response.transactions ?? [];
        emit(state.copyWith(transactions: transactions));
        _applyFiltersAndSort(emit);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load transactions: ${response.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transactions: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onSearchQueryChanged(
    TransactionsListSearchQueryChanged event,
    Emitter<TransactionsListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFiltersAndSort(emit);
  }

  void _onFilterChanged(
    TransactionsListFilterChanged event,
    Emitter<TransactionsListState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
    _applyFiltersAndSort(emit);
  }

  void _onSortChanged(
    TransactionsListSortChanged event,
    Emitter<TransactionsListState> emit,
  ) {
    if (state.sortBy == event.sortBy) {
      emit(state.copyWith(sortAscending: !state.sortAscending));
    } else {
      emit(
        state.copyWith(
          sortBy: event.sortBy,
          sortAscending: event.sortBy == 'date' ? false : true,
        ),
      );
    }
    _applyFiltersAndSort(emit);
  }

  void _applyFiltersAndSort(Emitter<TransactionsListState> emit) {
    List<Transaction> filtered = state.transactions;

    // Apply status/mode filter
    switch (state.selectedFilter) {
      case 'Success':
      case 'Pending':
      case 'Created':
      case 'Failed':
        filtered =
            filtered
                .where(
                  (t) =>
                      t.status?.toLowerCase() ==
                      state.selectedFilter.toLowerCase(),
                )
                .toList();
        break;
      case 'online':
      case 'cash':
        filtered =
            filtered
                .where(
                  (t) =>
                      t.transactionMode?.toLowerCase() ==
                      state.selectedFilter.toLowerCase(),
                )
                .toList();
        break;
      default:
        // 'all' - no filter
        break;
    }

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered =
          filtered
              .where(
                (t) =>
                    t.id.toString().contains(state.searchQuery) ||
                    (t.studentName?.toLowerCase().contains(query) ?? false) ||
                    t.studentId.toString().contains(state.searchQuery) ||
                    (t.status?.toLowerCase().contains(query) ?? false) ||
                    (t.transactionMode?.toLowerCase().contains(query) ?? false),
              )
              .toList();
    }

    // Apply sorting
    filtered = _sortTransactions(filtered, state.sortBy, state.sortAscending);

    emit(state.copyWith(filteredTransactions: filtered, isLoading: false));
  }

  List<Transaction> _sortTransactions(
    List<Transaction> transactions,
    String sortBy,
    bool ascending,
  ) {
    final sorted = List<Transaction>.from(transactions);
    sorted.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'date':
          comparison = (a.updatedAt ?? DateTime(0)).compareTo(
            b.updatedAt ?? DateTime(0),
          );
          break;
        case 'amount':
          comparison = (a.amount ?? 0).compareTo(b.amount ?? 0);
          break;
        case 'student':
          comparison = (a.studentName ?? '').compareTo(b.studentName ?? '');
          break;
        case 'status':
          comparison = (a.status ?? '').compareTo(b.status ?? '');
          break;
      }
      return ascending ? comparison : -comparison;
    });

    return sorted;
  }
}
