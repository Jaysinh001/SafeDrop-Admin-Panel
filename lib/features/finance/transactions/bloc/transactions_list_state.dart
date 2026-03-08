import 'package:equatable/equatable.dart';

import '../model/transactions_list_model.dart';

class TransactionsListState extends Equatable {
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final String sortBy;
  final bool sortAscending;

  const TransactionsListState({
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.isLoading = false,
    this.selectedFilter = 'all',
    this.searchQuery = '',
    this.sortBy = 'date',
    this.sortAscending = false,
  });

  TransactionsListState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    bool? isLoading,
    String? selectedFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  // Get transaction statistics
  Map<String, dynamic> get transactionStats {
    return {
      'total': transactions.length,
      'Success':
          transactions
              .where((t) => t.status?.toLowerCase() == 'success')
              .length,
      'Pending':
          transactions
              .where((t) => t.status?.toLowerCase() == 'pending')
              .length,
      'Created':
          transactions
              .where((t) => t.status?.toLowerCase() == 'created')
              .length,
      'Failed':
          transactions.where((t) => t.status?.toLowerCase() == 'failed').length,
      'totalAmount': transactions.fold<int>(
        0,
        (sum, t) => sum + (t.amount ?? 0),
      ),
      'completedAmount': transactions
          .where((t) => t.status?.toLowerCase() == 'completed')
          .fold<int>(0, (sum, t) => sum + (t.amount ?? 0)),
    };
  }

  @override
  List<Object?> get props => [
    transactions,
    filteredTransactions,
    isLoading,
    selectedFilter,
    searchQuery,
    sortBy,
    sortAscending,
  ];
}
