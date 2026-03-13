part of 'employee_list_bloc.dart';
enum EmployeesListStatus { initial, loading, success, error }

class EmployeesListState extends Equatable {
  final List<Datum> employees;
  final List<Datum> filteredEmployees;
  final EmployeesListStatus status;
  final String selectedFilter;
  final String searchQuery;
  final String sortBy;
  final bool sortAscending;
  final String? errorMessage;

  const EmployeesListState({
    this.employees = const [],
    this.filteredEmployees = const [],
    this.status = EmployeesListStatus.initial,
    this.selectedFilter = 'all',
    this.searchQuery = '',
    this.sortBy = 'name',
    this.sortAscending = true,
    this.errorMessage,
  });

  EmployeesListState copyWith({
    List<Datum>? employees,
    List<Datum>? filteredEmployees,
    EmployeesListStatus? status,
    String? selectedFilter,
    String? searchQuery,
    String? sortBy,
    bool? sortAscending,
    String? errorMessage,
  }) {
    return EmployeesListState(
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, int> get employeeStats {
    return {
      'total': employees.length,
      'active': employees.where((e) => e.status?.toLowerCase() == 'active').length,
      'inactive': employees.where((e) => e.status?.toLowerCase() == 'inactive').length,
      'on_leave': employees.where((e) => e.status?.toLowerCase() == 'on leave').length,
      'full_time': employees.where((e) => e.employmentType?.toLowerCase() == 'full-time').length,
      'part_time': employees.where((e) => e.employmentType?.toLowerCase() == 'part-time').length,
    };
  }

  @override
  List<Object?> get props => [
    employees,
    filteredEmployees,
    status,
    selectedFilter,
    searchQuery,
    sortBy,
    sortAscending,
    errorMessage,
  ];
}