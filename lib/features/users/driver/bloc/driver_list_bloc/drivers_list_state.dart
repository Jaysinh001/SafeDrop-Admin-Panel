import 'package:equatable/equatable.dart';
import '../../model/drivers_list_response.dart';

enum DriversListStatus { initial, loading, success, error }

class DriversListState extends Equatable {
  final List<Driver> drivers;
  final List<Driver> filteredDrivers;
  final DriversListStatus status;
  final String selectedFilter;
  final String searchQuery;
  final String sortBy;
  final bool sortAscending;
  final String? errorMessage;

  const DriversListState({
    this.drivers = const [],
    this.filteredDrivers = const [],
    this.status = DriversListStatus.initial,
    this.selectedFilter = 'all',
    this.searchQuery = '',
    this.sortBy = 'name',
    this.sortAscending = true,
    this.errorMessage,
  });

  DriversListState copyWith({
    List<Driver>? drivers,
    List<Driver>? filteredDrivers,
    DriversListStatus? status,
    String? selectedFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
    String? errorMessage,
  }) {
    return DriversListState(
      drivers: drivers ?? this.drivers,
      filteredDrivers: filteredDrivers ?? this.filteredDrivers,
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, int> get driverStats {
    return {
      'total': drivers.length,
      'with_bank_details': drivers.where((d) => d.hasBankDetails == true).length,
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
    status,
    selectedFilter,
    searchQuery,
    sortBy,
    sortAscending,
    errorMessage,
  ];
}