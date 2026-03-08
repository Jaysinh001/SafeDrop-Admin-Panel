import 'package:equatable/equatable.dart';
import '../model/students_list_response.dart';

class StudentsListState extends Equatable {
  final List<Student> students;
  final List<Student> filteredStudents;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String selectedFilter;
  final String sortBy;
  final bool sortAscending;

  const StudentsListState({
    this.students = const [],
    this.filteredStudents = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.sortBy = 'name',
    this.sortAscending = true,
  });

  StudentsListState copyWith({
    List<Student>? students,
    List<Student>? filteredStudents,
    bool? isLoading,
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
      isLoading: isLoading ?? this.isLoading,
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
    isLoading,
    errorMessage,
    searchQuery,
    selectedFilter,
    sortBy,
    sortAscending,
  ];

  // Statistics
  int get totalStudents => students.length;
  int get activeStudents =>
      students.where((s) => s.accountActive == true).length;
  int get inactiveStudents =>
      students.where((s) => s.accountActive == false).length;
  int get assignedStudents => students.where((s) => s.driverId != null).length;
  int get unassignedStudents =>
      students.where((s) => s.driverId == null).length;

  int get totalProposedFee =>
      students.fold(0, (sum, student) => sum + (student.proposedFee ?? 0));
}
