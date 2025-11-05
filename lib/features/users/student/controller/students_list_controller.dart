import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../../../../core/routes/app_routes.dart';
import '../model/students_list_response.dart';

// =============================================================================
// STUDENTS LIST CONTROLLER
// =============================================================================

class StudentsListController extends GetxController {
  // Reactive variables
  final _students = <Student>[].obs;
  final _filteredStudents = <Student>[].obs;
  final _isLoading = false.obs;
  final _selectedFilter = 'all'.obs;
  final _searchQuery = ''.obs;
  final _sortBy = 'name'.obs;
  final _sortAscending = true.obs;

  // Getters
  List<Student> get students => _students.toList();
  List<Student> get filteredStudents => _filteredStudents.toList();
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;
  String get searchQuery => _searchQuery.value;
  String get sortBy => _sortBy.value;
  bool get sortAscending => _sortAscending.value;

  // Filter options
  final List<String> filterOptions = [
    'all',
    'active',
    'inactive',
    'assigned',
    'unassigned',
  ];

  // Sort options
  final List<String> sortOptions = ['name', 'fee', 'student_id', 'driver'];

  @override
  void onInit() {
    super.onInit();
    loadStudents();

    // Watch for changes
    debounce(
      _searchQuery,
      (_) => _applyFiltersAndSort(),
      time: const Duration(milliseconds: 500),
    );
    ever(_selectedFilter, (_) => _applyFiltersAndSort());
    ever(_sortBy, (_) => _applyFiltersAndSort());
    ever(_sortAscending, (_) => _applyFiltersAndSort());
  }

  // Load students from API
  Future<void> loadStudents() async {
    _isLoading.value = true;

    try {
      // Simulate API call - Replace with your actual API call
      final res = await NetworkServicesApi().getApi(path: "allStudents");

      final response = studentsListResponseFromJson(res);

      if (response.success == true) {
        _students.value = response.students ?? [];
      } else {
        Get.snackbar(
          'Error',
          'Failed to load students: ${response.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      _applyFiltersAndSort();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load students: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Apply filters and search
  void _applyFiltersAndSort() {
    List<Student> filtered = _students;

    // Apply status filter
    switch (_selectedFilter.value) {
      case 'active':
        filtered =
            filtered.where((student) => student.accountActive == true).toList();
        break;
      case 'inactive':
        filtered =
            filtered
                .where((student) => student.accountActive == false)
                .toList();
        break;
      case 'assigned':
        filtered =
            filtered.where((student) => student.driverId != null).toList();
        break;
      case 'unassigned':
        filtered =
            filtered.where((student) => student.driverId == null).toList();
        break;
      default:
        // 'all' - no filter
        break;
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered =
          filtered
              .where(
                (student) =>
                    (student.studentName?.toLowerCase().contains(query) ??
                        false) ||
                    (student.email?.toLowerCase().contains(query) ?? false) ||
                    (student.phoneNumber?.contains(_searchQuery.value) ??
                        false) ||
                    student.studentId.toString().contains(_searchQuery.value) ||
                    (student.driverName?.toLowerCase().contains(query) ??
                        false) ||
                    (student.driverCode?.toLowerCase().contains(query) ??
                        false),
              )
              .toList();
    }

    // Apply sorting
    filtered = _sortStudents(filtered);

    _filteredStudents.value = filtered;
  }

  List<Student> _sortStudents(List<Student> students) {
    students.sort((a, b) {
      int comparison = 0;

      switch (_sortBy.value) {
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

      return _sortAscending.value ? comparison : -comparison;
    });

    return students;
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  // Set sort
  void setSortBy(String sortBy) {
    if (_sortBy.value == sortBy) {
      _sortAscending.value = !_sortAscending.value;
    } else {
      _sortBy.value = sortBy;
      _sortAscending.value = true;
    }
  }

  // Navigate to student details
  void openStudentDetails(Student student) {

    log("opening student id : ${student.studentId}");
    // Navigate to student details view
    Get.toNamed(AppRoutes.studentDetails, arguments: student);
    Get.snackbar(
      'Student Selected',
      'Opening details for ${student.studentName}',
      duration: const Duration(seconds: 2),
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadStudents();
  }

  // Get student statistics
  Map<String, int> get studentStats {
    return {
      'total': _students.length,
      'active': _students.where((s) => s.accountActive == true).length,
      'inactive': _students.where((s) => s.accountActive == false).length,
      'assigned': _students.where((s) => s.driverId != null).length,
      'unassigned': _students.where((s) => s.driverId == null).length,
    };
  }

  // Get total fee
  int get totalProposedFee {
    return _students.fold(
      0,
      (sum, student) => sum + (student.proposedFee ?? 0),
    );
  }
}
