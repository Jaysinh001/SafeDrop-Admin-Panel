// =============================================================================
// TRANSACTIONS LIST CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../../../../core/routes/app_routes.dart';
import '../model/transactions_list_model.dart';

class TransactionsListController extends GetxController {
  // Reactive variables
  final _transactions = <Transaction>[].obs;
  final _filteredTransactions = <Transaction>[].obs;
  final _isLoading = false.obs;
  final _selectedFilter = 'all'.obs;
  final _searchQuery = ''.obs;
  final _sortBy = 'date'.obs;
  final _sortAscending = false.obs;

  // Getters
  List<Transaction> get transactions => _transactions.toList();
  List<Transaction> get filteredTransactions => _filteredTransactions.toList();
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;
  String get searchQuery => _searchQuery.value;
  String get sortBy => _sortBy.value;
  bool get sortAscending => _sortAscending.value;

  // Filter options
  final List<String> filterOptions = [
    'all',
    'Success',
    'Pending',
    'Created'
        'Failed',
    'online',
    'cash',
  ];

  // Sort options
  final List<String> sortOptions = ['date', 'amount', 'student', 'status'];

  @override
  void onInit() {
    super.onInit();
    loadTransactions();

    // Watch for changes
    debounce(
      _searchQuery,
      (_) => _applyFiltersAndSort(),
      time: const Duration(milliseconds: 500),
    );
    ever(_selectedFilter, (_) => _applyFiltersAndSort());
    ever(_sortBy, (_) => _applyFiltersAndSort());
    ever(_sortAscending, (_) => _applyFiltersAndSort());
  }

  // Load transactions from API
  Future<void> loadTransactions() async {
    _isLoading.value = true;

    try {
      final res = await NetworkServicesApi().getApi(path: 'allTransactions');

      final response = transactionsListResponseFromJson(res);

      if (response.success == true) {
        _transactions.value = response.transactions ?? [];
        _applyFiltersAndSort();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load transactions: ${response.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transactions: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Apply filters and search
  void _applyFiltersAndSort() {
    List<Transaction> filtered = _transactions;

    // Apply status/mode filter
    switch (_selectedFilter.value) {
      case 'Success':
      case 'Pending':
      case 'Created':
      case 'Failed':
        filtered =
            filtered
                .where(
                  (t) =>
                      t.status?.toLowerCase() ==
                      _selectedFilter.value.toLowerCase(),
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
                      _selectedFilter.value.toLowerCase(),
                )
                .toList();
        break;
      default:
        // 'all' - no filter
        break;
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered =
          filtered
              .where(
                (t) =>
                    t.id.toString().contains(_searchQuery.value) ||
                    (t.studentName?.toLowerCase().contains(query) ?? false) ||
                    t.studentId.toString().contains(_searchQuery.value) ||
                    (t.status?.toLowerCase().contains(query) ?? false) ||
                    (t.transactionMode?.toLowerCase().contains(query) ?? false),
              )
              .toList();
    }

    // Apply sorting
    filtered = _sortTransactions(filtered);

    _filteredTransactions.value = filtered;
  }

  List<Transaction> _sortTransactions(List<Transaction> transactions) {
    transactions.sort((a, b) {
      int comparison = 0;

      switch (_sortBy.value) {
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

      return _sortAscending.value ? comparison : -comparison;
    });

    return transactions;
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  // Set sort
  void setSortBy(String sortBy) {
    if (_sortBy.value == sortBy) {
      _sortAscending.value = !_sortAscending.value;
    } else {
      _sortBy.value = sortBy;
      _sortAscending.value = sortBy == 'date' ? false : true;
    }
  }

  // View transaction details
  void viewTransactionDetails(Transaction transaction) {
    // Navigate to transaction details or show details dialog

    Get.toNamed(AppRoutes.transactionDetails, arguments: transaction);



    Get.snackbar(
      'Transaction Details',
      'Opening details for transaction #${transaction.id}',
      duration: const Duration(seconds: 2),
    );
  }

  // View student details
  void viewStudentDetails(Transaction transaction) {
    // Navigate to student details
    Get.snackbar(
      'Student Details',
      'Opening details for ${transaction.studentName}',
      duration: const Duration(seconds: 2),
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadTransactions();
  }

  // Get transaction statistics
  Map<String, dynamic> get transactionStats {
    return {
      'total': _transactions.length,
      'Success':
          _transactions
              .where((t) => t.status?.toLowerCase() == 'success')
              .length,
      'Pending':
          _transactions
              .where((t) => t.status?.toLowerCase() == 'pending')
              .length,
      'Created':
          _transactions
              .where((t) => t.status?.toLowerCase() == 'created')
              .length,
      'Failed':
          _transactions
              .where((t) => t.status?.toLowerCase() == 'failed')
              .length,
      'totalAmount': _transactions.fold<int>(
        0,
        (sum, t) => sum + (t.amount ?? 0),
      ),
      'completedAmount': _transactions
          .where((t) => t.status?.toLowerCase() == 'completed')
          .fold<int>(0, (sum, t) => sum + (t.amount ?? 0)),
    };
  }
}
