import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/local_storage/local_storage_service.dart';
import '../../repo/student_repository.dart';
import '../../model/students_list_response.dart';
import 'students_list_event.dart';
import 'students_list_state.dart';

class StudentsListBloc extends Bloc<StudentsListEvent, StudentsListState> {
  final StudentRepository studentRepository;
  final LocalStorageService storage;

  StudentsListBloc({required this.studentRepository, required this.storage})
      : super(const StudentsListState()) {
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
        final students = response.data?.items ?? [];
        emit(state.copyWith(
          students: students,
          status: StudentsListStatus.success,
        ));
        _applyFiltersAndSort(emit);
      } else {
        emit(state.copyWith(
          status: StudentsListStatus.error,
          errorMessage: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: StudentsListStatus.error,
        errorMessage: e.toString(),
      ));
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
    List<Item> filtered = List.from(state.students);

    // Apply enrollment status filter
    // Adjust the status string values to match your actual API enum values.
    switch (state.selectedFilter) {
      case 'active':
        filtered = filtered
            .where((s) => s.enrollmentStatus?.toLowerCase() == 'active')
            .toList();
        break;
      case 'inactive':
        filtered = filtered
            .where((s) => s.enrollmentStatus?.toLowerCase() == 'inactive')
            .toList();
        break;
      case 'enrolled':
        filtered = filtered
            .where((s) => s.enrollmentStatus?.toLowerCase() == 'enrolled')
            .toList();
        break;
      case 'unenrolled':
        filtered =
            filtered.where((s) => s.enrollmentStatus == null).toList();
        break;
      // 'all' — no filter applied
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((s) {
        return (s.name?.toLowerCase().contains(query) ?? false) ||
            (s.email?.toLowerCase().contains(query) ?? false) ||
            (s.phone?.contains(state.searchQuery) ?? false) ||
            (s.id?.toString().contains(state.searchQuery) ?? false) ||
            (s.userId?.toString().contains(state.searchQuery) ?? false) ||
            (s.enrollmentStatus?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (state.sortBy) {
        case 'name':
          comparison = (a.name ?? '').compareTo(b.name ?? '');
          break;
        case 'id':
          comparison = (a.id ?? 0).compareTo(b.id ?? 0);
          break;
        case 'admission_date':
          final aDate = a.admissionDate ?? DateTime(0);
          final bDate = b.admissionDate ?? DateTime(0);
          comparison = aDate.compareTo(bDate);
          break;
        case 'enrollment_status':
          comparison =
              (a.enrollmentStatus ?? '').compareTo(b.enrollmentStatus ?? '');
          break;
      }
      return state.sortAscending ? comparison : -comparison;
    });

    emit(state.copyWith(filteredStudents: filtered));
  }
}