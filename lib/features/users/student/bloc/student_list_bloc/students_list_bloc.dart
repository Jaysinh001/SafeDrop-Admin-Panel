import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../model/students_list_response.dart';
import '../../repo/student_repository.dart';
import 'students_list_event.dart';
import 'students_list_state.dart';

class StudentsListBloc extends Bloc<StudentsListEvent, StudentsListState> {

  final StudentRepository studentRepository;
  final LocalStorageService storage;

  StudentsListBloc({required this.studentRepository, required this.storage}) : super(const StudentsListState()) {
    on<StudentsListLoaded>(_onLoaded);
    on<StudentsListSearchQueryChanged>(_onSearchQueryChanged);
    on<StudentsListFilterChanged>(_onFilterChanged);
    on<StudentsListSortChanged>(_onSortChanged);
    on<StudentsListRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoaded(
    StudentsListLoaded event,
    Emitter<StudentsListState> emit,
  ) async {
    await _loadStudents(emit);
  }

  Future<void> _onRefreshRequested(
    StudentsListRefreshRequested event,
    Emitter<StudentsListState> emit,
  ) async {
    await _loadStudents(emit);
  }

  Future<void> _loadStudents(Emitter<StudentsListState> emit) async {
    emit(state.copyWith(status: StudentsListStatus.loading, clearError: true));

    try {

      final response = await studentRepository.getStudentsList();

      if (response.success == true) {
        final students = response.data?.students ?? [];
        emit(state.copyWith(students: students, status: StudentsListStatus.success));
        _applyFiltersAndSort(emit);
      } else {
        emit(
          state.copyWith(
            status: StudentsListStatus.error,
            errorMessage: response.message ?? 'Failed to load students',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: StudentsListStatus.error, errorMessage: e.toString()));
    }
  }

  void _onSearchQueryChanged(
    StudentsListSearchQueryChanged event,
    Emitter<StudentsListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFiltersAndSort(emit);
  }

  void _onFilterChanged(
    StudentsListFilterChanged event,
    Emitter<StudentsListState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
    _applyFiltersAndSort(emit);
  }

  void _onSortChanged(
    StudentsListSortChanged event,
    Emitter<StudentsListState> emit,
  ) {
    if (state.sortBy == event.sortBy) {
      emit(state.copyWith(sortAscending: !state.sortAscending));
    } else {
      emit(state.copyWith(sortBy: event.sortBy, sortAscending: true));
    }
    _applyFiltersAndSort(emit);
  }

  void _applyFiltersAndSort(Emitter<StudentsListState> emit) {
    List<Student> filtered = List.from(state.students);

    // Apply status filter
    switch (state.selectedFilter) {
      case 'active':
        filtered = filtered.where((s) => s.accountActive == true).toList();
        break;
      case 'inactive':
        filtered = filtered.where((s) => s.accountActive == false).toList();
        break;
      case 'assigned':
        filtered = filtered.where((s) => s.driverId != null).toList();
        break;
      case 'unassigned':
        filtered = filtered.where((s) => s.driverId == null).toList();
        break;
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((s) {
            return (s.studentName?.toLowerCase().contains(query) ?? false) ||
                (s.email?.toLowerCase().contains(query) ?? false) ||
                (s.phoneNumber?.contains(state.searchQuery) ?? false) ||
                s.studentId.toString().contains(state.searchQuery) ||
                (s.driverName?.toLowerCase().contains(query) ?? false) ||
                (s.driverCode?.toLowerCase().contains(query) ?? false);
          }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (state.sortBy) {
        case 'name':
          comparison = (a.studentName ?? '').compareTo(b.studentName ?? '');
          break;
        case 'fee':
          comparison = (a.proposedFee ?? 0).compareTo(b.proposedFee ?? 0);
          break;
        case 'student_id':
          comparison = (a.studentId ?? 0).compareTo(b.studentId ?? 0);
          break;
        case 'driver':
          comparison = (a.driverName ?? '').compareTo(b.driverName ?? '');
          break;
      }
      return state.sortAscending ? comparison : -comparison;
    });

    emit(state.copyWith(filteredStudents: filtered));
  }
}
