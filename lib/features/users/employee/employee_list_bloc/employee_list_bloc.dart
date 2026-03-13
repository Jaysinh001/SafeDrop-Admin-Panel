import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/local_storage/local_storage_service.dart';
import '../model/employee_list_response.dart';
import '../repo/employee_repository.dart';
part 'employee_list_event.dart';
part 'employee_list_state.dart';

class EmployeesListBloc extends Bloc<EmployeesListEvent, EmployeesListState> {

  final EmployeeRepository employeeRepository;
  final LocalStorageService storage;

 

  final List<String> filterOptions = [
    'all',
    'active',
    'inactive',
    'on_leave',
    'full_time',
    'part_time',
  ];

  final List<String> sortOptions = [
    'name',
    'email',
    'join_date',
    'department',
    'designation',
  ];

  // Mock data
  static final List<Datum> mockEmployees = [
    Datum(
      id: 1,
      firstName: 'Rajesh',
      lastName: 'Kumar',
      email: 'rajesh.kumar@company.com',
      phoneNumber: '+919876543210',
      departmentName: 'Engineering',
      designation: 'Senior Developer',
      employmentType: 'Full-time',
      status: 'Active',
      joinDate: DateTime(2020, 5, 15),
      dateOfBirth: DateTime(1990, 3, 22),
      gender: 'Male',
      address: '123 Tech Street',
      city: 'Bangalore',
      state: 'Karnataka',
      pinCode: '560001',
      createdAt: DateTime(2020, 5, 15),
      updatedAt: DateTime(2024, 1, 10),
    ),
    Datum(
      id: 2,
      firstName: 'Priya',
      lastName: 'Singh',
      email: 'priya.singh@company.com',
      phoneNumber: '+919876543211',
      departmentName: 'HR',
      designation: 'HR Manager',
      employmentType: 'Full-time',
      status: 'Active',
      joinDate: DateTime(2021, 2, 20),
      dateOfBirth: DateTime(1992, 7, 14),
      gender: 'Female',
      address: '456 Business Ave',
      city: 'Mumbai',
      state: 'Maharashtra',
      pinCode: '400001',
      createdAt: DateTime(2021, 2, 20),
      updatedAt: DateTime(2024, 1, 12),
    ),
    Datum(
      id: 3,
      firstName: 'Amit',
      lastName: 'Patel',
      email: 'amit.patel@company.com',
      phoneNumber: '+919876543212',
      departmentName: 'Engineering',
      designation: 'Junior Developer',
      employmentType: 'Full-time',
      status: 'On Leave',
      joinDate: DateTime(2022, 8, 10),
      dateOfBirth: DateTime(1995, 11, 5),
      gender: 'Male',
      address: '789 Innovation Park',
      city: 'Hyderabad',
      state: 'Telangana',
      pinCode: '500001',
      createdAt: DateTime(2022, 8, 10),
      updatedAt: DateTime(2024, 1, 5),
    ),
    Datum(
      id: 4,
      firstName: 'Neha',
      lastName: 'Sharma',
      email: 'neha.sharma@company.com',
      phoneNumber: '+919876543213',
      departmentName: 'Marketing',
      designation: 'Marketing Executive',
      employmentType: 'Full-time',
      status: 'Active',
      joinDate: DateTime(2021, 11, 15),
      dateOfBirth: DateTime(1993, 6, 18),
      gender: 'Female',
      address: '321 Creative Lane',
      city: 'Delhi',
      state: 'Delhi',
      pinCode: '110001',
      createdAt: DateTime(2021, 11, 15),
      updatedAt: DateTime(2024, 1, 11),
    ),
    Datum(
      id: 5,
      firstName: 'Rohan',
      lastName: 'Gupta',
      email: 'rohan.gupta@company.com',
      phoneNumber: '+919876543214',
      departmentName: 'Finance',
      designation: 'Finance Analyst',
      employmentType: 'Part-time',
      status: 'Active',
      joinDate: DateTime(2023, 3, 1),
      dateOfBirth: DateTime(1998, 9, 12),
      gender: 'Male',
      address: '654 Financial District',
      city: 'Pune',
      state: 'Maharashtra',
      pinCode: '411001',
      createdAt: DateTime(2023, 3, 1),
      updatedAt: DateTime(2024, 1, 8),
    ),
    Datum(
      id: 6,
      firstName: 'Divya',
      lastName: 'Nair',
      email: 'divya.nair@company.com',
      phoneNumber: '+919876543215',
      departmentName: 'Engineering',
      designation: 'QA Engineer',
      employmentType: 'Full-time',
      status: 'Inactive',
      joinDate: DateTime(2019, 6, 10),
      dateOfBirth: DateTime(1991, 2, 28),
      gender: 'Female',
      address: '987 Quality Street',
      city: 'Chennai',
      state: 'Tamil Nadu',
      pinCode: '600001',
      createdAt: DateTime(2019, 6, 10),
      updatedAt: DateTime(2024, 1, 9),
    ),
    Datum(
      id: 7,
      firstName: 'Vikram',
      lastName: 'Singh',
      email: 'vikram.singh@company.com',
      phoneNumber: '+919876543216',
      departmentName: 'Sales',
      designation: 'Sales Executive',
      employmentType: 'Full-time',
      status: 'Active',
      joinDate: DateTime(2022, 1, 15),
      dateOfBirth: DateTime(1994, 5, 10),
      gender: 'Male',
      address: '147 Sales Tower',
      city: 'Bangalore',
      state: 'Karnataka',
      pinCode: '560020',
      createdAt: DateTime(2022, 1, 15),
      updatedAt: DateTime(2024, 1, 13),
    ),
    Datum(
      id: 8,
      firstName: 'Anjali',
      lastName: 'Reddy',
      email: 'anjali.reddy@company.com',
      phoneNumber: '+919876543217',
      departmentName: 'Operations',
      designation: 'Operations Manager',
      employmentType: 'Full-time',
      status: 'Active',
      joinDate: DateTime(2020, 9, 5),
      dateOfBirth: DateTime(1989, 12, 30),
      gender: 'Female',
      address: '258 Operations Hub',
      city: 'Hyderabad',
      state: 'Telangana',
      pinCode: '500020',
      createdAt: DateTime(2020, 9, 5),
      updatedAt: DateTime(2024, 1, 7),
    ),
  ];

   EmployeesListBloc({
    required this.employeeRepository,
    required this.storage,
  }) : super(const EmployeesListState()) {
    on<EmployeesListLoaded>(_onLoaded);
    on<EmployeesListRefreshRequested>(_onRefreshed);
    on<EmployeesListSearchQueryChanged>(_onSearchQueryChanged);
    on<EmployeesListFilterChanged>(_onFilterChanged);
    on<EmployeesListSortChanged>(_onSortChanged);
  }

  Future<void> _onLoaded(
    EmployeesListLoaded event,
    Emitter<EmployeesListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _onRefreshed(
    EmployeesListRefreshRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<EmployeesListState> emit) async {
    emit(state.copyWith(status: EmployeesListStatus.loading));

    try {
      // Simulating API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(state.copyWith(
        employees: mockEmployees,
        status: EmployeesListStatus.success,
        errorMessage: null,
      ));
      _applyFiltersAndSort(emit);
    } catch (e) {
      emit(state.copyWith(
        status: EmployeesListStatus.error,
        employees: [],
        errorMessage: 'Error: ${e.toString()}',
      ));
    }
  }

  void _onSearchQueryChanged(
    EmployeesListSearchQueryChanged event,
    Emitter<EmployeesListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFiltersAndSort(emit);
  }

  void _onFilterChanged(
    EmployeesListFilterChanged event,
    Emitter<EmployeesListState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
    _applyFiltersAndSort(emit);
  }

  void _onSortChanged(
    EmployeesListSortChanged event,
    Emitter<EmployeesListState> emit,
  ) {
    if (state.sortBy == event.sortBy) {
      emit(state.copyWith(sortAscending: !state.sortAscending));
    } else {
      emit(state.copyWith(sortBy: event.sortBy, sortAscending: true));
    }
    _applyFiltersAndSort(emit);
  }

  void _applyFiltersAndSort(Emitter<EmployeesListState> emit) {
    List<Datum> filtered = List.from(state.employees);

    // Apply filter
    switch (state.selectedFilter) {
      case 'active':
        filtered = filtered
            .where((e) => e.status?.toLowerCase() == 'active')
            .toList();
        break;
      case 'inactive':
        filtered = filtered
            .where((e) => e.status?.toLowerCase() == 'inactive')
            .toList();
        break;
      case 'on_leave':
        filtered = filtered
            .where((e) => e.status?.toLowerCase() == 'on leave')
            .toList();
        break;
      case 'full_time':
        filtered = filtered
            .where((e) => e.employmentType?.toLowerCase() == 'full-time')
            .toList();
        break;
      case 'part_time':
        filtered = filtered
            .where((e) => e.employmentType?.toLowerCase() == 'part-time')
            .toList();
        break;
      default:
        break;
    }

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (employee) =>
                (employee.firstName?.toLowerCase().contains(query) ?? false) ||
                (employee.lastName?.toLowerCase().contains(query) ?? false) ||
                (employee.email?.toLowerCase().contains(query) ?? false) ||
                (employee.phoneNumber?.contains(state.searchQuery) ?? false) ||
                (employee.designation?.toLowerCase().contains(query) ?? false) ||
                (employee.departmentName?.toLowerCase().contains(query) ??
                    false) ||
                employee.id.toString().contains(state.searchQuery),
          )
          .toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      int comparison = 0;

      switch (state.sortBy) {
        case 'name':
          comparison = (a.firstName ?? '').compareTo(b.firstName ?? '');
          break;
        case 'email':
          comparison = (a.email ?? '').compareTo(b.email ?? '');
          break;
        case 'join_date':
          comparison = (a.joinDate ?? DateTime(0))
              .compareTo(b.joinDate ?? DateTime(0));
          break;
        case 'department':
          comparison = (a.departmentName ?? '')
              .compareTo(b.departmentName ?? '');
          break;
        case 'designation':
          comparison =
              (a.designation ?? '').compareTo(b.designation ?? '');
          break;
      }

      return state.sortAscending ? comparison : -comparison;
    });

    emit(state.copyWith(
      filteredEmployees: filtered,
      status: EmployeesListStatus.success,
      errorMessage: null,
    ));
  }
}