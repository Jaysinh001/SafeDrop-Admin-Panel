import 'package:equatable/equatable.dart';
import '../../model/drivers_list_response.dart';

enum DriversListStatus { initial, loading, success, error }

class DriversListState extends Equatable {
  final List<Item> drivers;
  final List<Item> filteredDrivers;
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
    List<Item>? drivers,
    List<Item>? filteredDrivers,
    DriversListStatus? status,
    String? selectedFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DriversListState(
      drivers: drivers ?? this.drivers,
      filteredDrivers: filteredDrivers ?? this.filteredDrivers,
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  // ---------------------------------------------------------------------------
  // Statistics — derived from actual Item fields
  // ---------------------------------------------------------------------------

  // Adjust the employment status string values to match your actual API enum.
  static const String _employedStatus = 'employed';

  Map<String, int> get driverStats => {
        'total': drivers.length,
        'independent': drivers.where((d) => d.isIndependent == true).length,
        'employed': drivers
            .where((d) =>
                d.employmentStatus?.toLowerCase() == _employedStatus)
            .length,
        'active': drivers.where((d) => d.employmentStatus != null).length,
      };

  int get totalDrivers => drivers.length;
  int get independentDrivers =>
      drivers.where((d) => d.isIndependent == true).length;
  int get employedDrivers =>
      drivers.where((d) => d.isIndependent == false).length;

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