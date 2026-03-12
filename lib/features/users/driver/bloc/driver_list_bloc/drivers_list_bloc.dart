import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../model/drivers_list_response.dart';
import '../../repo/driver_repository.dart';
import 'drivers_list_event.dart';
import 'drivers_list_state.dart';

class DriversListBloc extends Bloc<DriversListEvent, DriversListState> {
  final DriverRepository driverRepository;
  final LocalStorageService storage;

  // Adjust filter/sort option values to match your actual API enum values.
  final List<String> filterOptions = [
    'all',
    'independent',
    'employed',
    'employed_status', // employment_status != null
    'no_status',       // employment_status == null
  ];

  final List<String> sortOptions = [
    'name',
    'email',
    'created_date',
    'employment_status',
  ];

  DriversListBloc({required this.driverRepository, required this.storage})
      : super(const DriversListState()) {
    on<DriversListLoaded>(_onLoaded);
    on<DriversListRefreshed>(_onRefreshed);
    on<DriversListSearchQueryChanged>(_onSearchQueryChanged);
    on<DriversListFilterChanged>(_onFilterChanged);
    on<DriversListSortByChanged>(_onSortByChanged);

    add(DriversListLoaded());
  }

  Future<void> _onLoaded(
    DriversListLoaded event,
    Emitter<DriversListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _onRefreshed(
    DriversListRefreshed event,
    Emitter<DriversListState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<DriversListState> emit) async {
    emit(state.copyWith(
      status: DriversListStatus.loading,
      clearError: true,
    ));

    try {
      final response = await driverRepository.getDriversList();

      if (response.success == true) {
        final drivers = response.data?.items ?? [];
        emit(state.copyWith(
          drivers: drivers,
          status: DriversListStatus.success,
          clearError: true,
        ));
        _applyFiltersAndSort(emit);
      } else {
        emit(state.copyWith(
          drivers: [],
          status: DriversListStatus.error,
          errorMessage: response.message ,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DriversListStatus.error,
        drivers: [],
        errorMessage: 'Error: ${e.toString()}',
      ));
    }
  }

  void _onSearchQueryChanged(
    DriversListSearchQueryChanged event,
    Emitter<DriversListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFiltersAndSort(emit);
  }

  void _onFilterChanged(
    DriversListFilterChanged event,
    Emitter<DriversListState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
    _applyFiltersAndSort(emit);
  }

  void _onSortByChanged(
    DriversListSortByChanged event,
    Emitter<DriversListState> emit,
  ) {
    if (state.sortBy == event.sortBy) {
      emit(state.copyWith(sortAscending: !state.sortAscending));
    } else {
      emit(state.copyWith(sortBy: event.sortBy, sortAscending: true));
    }
    _applyFiltersAndSort(emit);
  }

  void _applyFiltersAndSort(Emitter<DriversListState> emit) {
    List<Item> filtered = List.from(state.drivers);

    // Apply filter
    // Adjust string values to match your actual API employment_status enum.
    switch (state.selectedFilter) {
      case 'independent':
        filtered =
            filtered.where((d) => d.isIndependent == true).toList();
        break;
      case 'employed':
        filtered =
            filtered.where((d) => d.isIndependent == false).toList();
        break;
      case 'employed_status':
        filtered =
            filtered.where((d) => d.employmentStatus != null).toList();
        break;
      case 'no_status':
        filtered =
            filtered.where((d) => d.employmentStatus == null).toList();
        break;
      // 'all' — no filter applied
    }

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((d) {
        return (d.name?.toLowerCase().contains(query) ?? false) ||
            (d.email?.toLowerCase().contains(query) ?? false) ||
            (d.phone?.contains(state.searchQuery) ?? false) ||
            (d.id?.toString().contains(state.searchQuery) ?? false) ||
            (d.userId?.toString().contains(state.searchQuery) ?? false) ||
            (d.employmentStatus?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      int comparison = 0;
      switch (state.sortBy) {
        case 'name':
          comparison = (a.name ?? '').compareTo(b.name ?? '');
          break;
        case 'email':
          comparison = (a.email ?? '').compareTo(b.email ?? '');
          break;
        case 'created_date':
          comparison = (a.createdAt ?? DateTime(0))
              .compareTo(b.createdAt ?? DateTime(0));
          break;
        case 'employment_status':
          comparison = (a.employmentStatus ?? '')
              .compareTo(b.employmentStatus ?? '');
          break;
      }
      return state.sortAscending ? comparison : -comparison;
    });

    emit(state.copyWith(
      filteredDrivers: filtered,
      status: DriversListStatus.success,
      clearError: true,
    ));
  }
}