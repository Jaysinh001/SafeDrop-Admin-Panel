// =============================================================================
// DRIVERS LIST CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/network_services_api.dart';
import '../model/drivers_list_response.dart';

class DriversListController extends GetxController {
  // Reactive variables
  final _drivers = <Driver>[].obs;
  final _filteredDrivers = <Driver>[].obs;
  final _isLoading = false.obs;
  final _selectedFilter = 'all'.obs;
  final _searchQuery = ''.obs;
  final _sortBy = 'name'.obs;
  final _sortAscending = true.obs;

  // Getters
  List<Driver> get drivers => _drivers.toList();
  List<Driver> get filteredDrivers => _filteredDrivers.toList();
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;
  String get searchQuery => _searchQuery.value;
  String get sortBy => _sortBy.value;
  bool get sortAscending => _sortAscending.value;

  // Filter options
  final List<String> filterOptions = [
    'all',
    'active',
    'with_bank_details',
    'without_bank_details',
    'mpin_set',
    'mpin_not_set',
  ];

  // Sort options
  final List<String> sortOptions = [
    'name',
    'email',
    'created_date',
    'unique_code',
  ];

  @override
  void onInit() {
    super.onInit();
    loadDrivers();

    // Watch for changes in search query and filter
    debounce(
      _searchQuery,
      (_) => _applyFiltersAndSort(),
      time: const Duration(milliseconds: 500),
    );
    ever(_selectedFilter, (_) => _applyFiltersAndSort());
    ever(_sortBy, (_) => _applyFiltersAndSort());
    ever(_sortAscending, (_) => _applyFiltersAndSort());
  }

  // Load drivers from API
  Future<void> loadDrivers() async {
    _isLoading.value = true;

    try {
      final res = await NetworkServicesApi().getApi(path: 'allDrivers');

      final response = driversListResponseFromJson(res);

      _drivers.value = response.drivers ?? [];
      _applyFiltersAndSort();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load drivers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Apply filters and search
  void _applyFiltersAndSort() {
    List<Driver> filtered = _drivers;

    // Apply status filter
    switch (_selectedFilter.value) {
      case 'with_bank_details':
        filtered =
            filtered.where((driver) => driver.hasBankDetails == true).toList();
        break;
      case 'without_bank_details':
        filtered =
            filtered.where((driver) => driver.hasBankDetails == false).toList();
        break;
      case 'mpin_set':
        filtered = filtered.where((driver) => driver.mpinSet == true).toList();
        break;
      case 'mpin_not_set':
        filtered = filtered.where((driver) => driver.mpinSet == false).toList();
        break;
      case 'active':
        // Define your own logic for active drivers
        filtered =
            filtered
                .where(
                  (driver) =>
                      driver.hasBankDetails == true && driver.mpinSet == true,
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
                (driver) =>
                    (driver.driverName?.toLowerCase().contains(query) ??
                        false) ||
                    (driver.email?.toLowerCase().contains(query) ?? false) ||
                    (driver.phoneNumber?.contains(_searchQuery.value) ??
                        false) ||
                    driver.id.toString().contains(_searchQuery.value) ||
                    driver.uniqueCodeId.toString().contains(_searchQuery.value),
              )
              .toList();
    }

    // Apply sorting
    filtered = _sortDrivers(filtered);

    _filteredDrivers.value = filtered;
  }

  List<Driver> _sortDrivers(List<Driver> drivers) {
    drivers.sort((a, b) {
      int comparison = 0;

      switch (_sortBy.value) {
        case 'name':
          comparison = (a.driverName ?? '').compareTo(b.driverName ?? '');
          break;
        case 'email':
          comparison = (a.email ?? '').compareTo(b.email ?? '');
          break;
        case 'created_date':
          comparison = (a.createdAt ?? DateTime(0)).compareTo(
            b.createdAt ?? DateTime(0),
          );
          break;
        case 'unique_code':
          comparison = (a.uniqueCodeId ?? 0).compareTo(b.uniqueCodeId ?? 0);
          break;
      }

      return _sortAscending.value ? comparison : -comparison;
    });

    return drivers;
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
      _sortAscending.value = true;
    }
  }

  // Navigate to driver details
  void openDriverDetails(Driver driver) {
    // Navigate to driver details view
    Get.toNamed(AppRoutes.driverDetails, arguments: driver);
    Get.snackbar(
      'Driver Selected',
      'Opening details for ${driver.driverName}',
      duration: const Duration(seconds: 2),
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadDrivers();
  }

  // Get driver statistics
  Map<String, int> get driverStats {
    return {
      'total': _drivers.length,
      'with_bank_details':
          _drivers.where((d) => d.hasBankDetails == true).length,
      'mpin_set': _drivers.where((d) => d.mpinSet == true).length,
      'active':
          _drivers
              .where((d) => d.hasBankDetails == true && d.mpinSet == true)
              .length,
    };
  }
}
