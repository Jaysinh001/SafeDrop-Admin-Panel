import 'package:equatable/equatable.dart';
import '../model/drivers_list_response.dart';

class DriversListState extends Equatable {
  final List<Driver> drivers;
  final List<Driver> filteredDrivers;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final String sortBy;
  final bool sortAscending;

  const DriversListState({
    this.drivers = const [],
    this.filteredDrivers = const [],
    this.isLoading = false,
    this.selectedFilter = 'all',
    this.searchQuery = '',
    this.sortBy = 'name',
    this.sortAscending = true,
  });

  DriversListState copyWith({
    List<Driver>? drivers,
    List<Driver>? filteredDrivers,
    bool? isLoading,
    String? selectedFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
  }) {
    return DriversListState(
      drivers: drivers ?? this.drivers,
      filteredDrivers: filteredDrivers ?? this.filteredDrivers,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  Map<String, int> get driverStats {
    return {
      'total': drivers.length,
      'with_bank_details':
          drivers.where((d) => d.hasBankDetails == true).length,
      'mpin_set': drivers.where((d) => d.mpinSet == true).length,
      'active':
          drivers
              .where((d) => d.hasBankDetails == true && d.mpinSet == true)
              .length,
    };
  }

  @override
  List<Object?> get props => [
    drivers,
    filteredDrivers,
    isLoading,
    selectedFilter,
    searchQuery,
    sortBy,
    sortAscending,
  ];
}
