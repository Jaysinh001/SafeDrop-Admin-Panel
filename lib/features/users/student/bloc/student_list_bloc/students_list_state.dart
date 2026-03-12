import 'package:equatable/equatable.dart';
import '../../model/students_list_response.dart';

enum StudentsListStatus { initial, loading, success, error }

class StudentsListState extends Equatable {
  final List<Item> students;
  final List<Item> filteredStudents;
  final StudentsListStatus status;
  final String? errorMessage;
  final String searchQuery;
  final String selectedFilter;
  final String sortBy;
  final bool sortAscending;

  const StudentsListState({
    this.students = const [],
    this.filteredStudents = const [],
    this.status = StudentsListStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.sortBy = 'name',
    this.sortAscending = true,
  });

  StudentsListState copyWith({
    List<Item>? students,
    List<Item>? filteredStudents,
    StudentsListStatus? status,
    String? errorMessage,
    String? searchQuery,
    String? selectedFilter,
    String? sortBy,
    bool? sortAscending,
    bool clearError = false,
  }) {
    return StudentsListState(
      students: students ?? this.students,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  List<Object?> get props => [
        students,
        filteredStudents,
        status,
        errorMessage,
        searchQuery,
        selectedFilter,
        sortBy,
        sortAscending,
      ];

  // Enrollment status values from API: adjust these constants to match your
  // actual API enum values (e.g. 'active', 'inactive', 'enrolled', etc.)
  static const String _enrolledStatus = 'active';

  // Statistics
  int get totalStudents => students.length;

  int get activeStudents =>
      students.where((s) => s.enrollmentStatus == _enrolledStatus).length;

  int get inactiveStudents =>
      students.where((s) => s.enrollmentStatus != _enrolledStatus).length;

  // The Item model has no driver assignment fields, so these are placeholders.
  // Remove or replace once driver-assignment data is available in the response.
  int get enrolledStudents =>
      students.where((s) => s.enrollmentStatus != null).length;

  int get unenrolledStudents =>
      students.where((s) => s.enrollmentStatus == null).length;
}