import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../model/drivers_list_response.dart';
import '../../repo/driver_repository.dart';
import 'drivers_list_event.dart';
import 'drivers_list_state.dart';

class DriversListBloc extends Bloc<DriversListEvent, DriversListState> {
  final DriverRepository driverRepository;
  final LocalStorageService storage;

  final List<String> filterOptions = [
    'all',
    'active',
    'with_bank_details',
    'without_bank_details',
    'mpin_set',
    'mpin_not_set',
  ];

  final List<String> sortOptions = [
    'name',
    'email',
    'created_date',
    'unique_code',
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
    emit(state.copyWith(status: DriversListStatus.loading));

    try {
      final response = await driverRepository.getDriversList();

      if (response.success) {
        emit(state.copyWith(
          drivers: response.data?.drivers ?? [],
          status: DriversListStatus.success,
          errorMessage: null,
        ));
        _applyFiltersAndSort(emit);
      } else {
        emit(state.copyWith(
          drivers: [],
          status: DriversListStatus.error,
          errorMessage: response.message ?? 'Failed to load drivers',
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
    List<Driver> filtered = List.from(state.drivers);

    switch (state.selectedFilter) {
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
        filtered =
            filtered
                .where(
                  (driver) =>
                      driver.hasBankDetails == true && driver.mpinSet == true,
                )
                .toList();
        break;
      default:
        break;
    }

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered =
          filtered
              .where(
                (driver) =>
                    (driver.driverName?.toLowerCase().contains(query) ??
                        false) ||
                    (driver.email?.toLowerCase().contains(query) ?? false) ||
                    (driver.phoneNumber?.contains(state.searchQuery) ??
                        false) ||
                    driver.id.toString().contains(state.searchQuery) ||
                    driver.uniqueCodeId.toString().contains(state.searchQuery),
              )
              .toList();
    }

    filtered.sort((a, b) {
      int comparison = 0;

      switch (state.sortBy) {
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

      return state.sortAscending ? comparison : -comparison;
    });

    emit(state.copyWith(
      filteredDrivers: filtered,
      status: DriversListStatus.success,
      errorMessage: null,
    ));
  }
}