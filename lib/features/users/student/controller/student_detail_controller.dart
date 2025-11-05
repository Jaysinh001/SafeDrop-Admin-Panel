// =============================================================================
// STUDENT DETAILS CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/network_services_api.dart';
import '../model/student_details_response.dart';
import '../model/students_list_response.dart' as slr;

class StudentDetailsController extends GetxController {
  // Reactive variables
  final _studentDetails = Rx<Details?>(null);
  final _isLoading = false.obs;
  final _selectedTab = 0.obs;
  final _studentId = 0.obs;
  final _transactionFilter = 'all'.obs;

  // Getters
  Details? get studentDetails => _studentDetails.value;
  Student? get student => _studentDetails.value?.student;
  Driver? get driver => _studentDetails.value?.driver;
  List<Transaction> get transactions => _studentDetails.value?.transactions ?? [];
  StudentCreditBalance? get creditBalance => _studentDetails.value?.studentCreditBalance;
  UniqueCode? get uniqueCode => _studentDetails.value?.uniqueCode;
  FcmToken? get fcmToken => _studentDetails.value?.fcmToken;
  bool get isLoading => _isLoading.value;
  int get selectedTab => _selectedTab.value;
  int get studentId => _studentId.value;
  String get transactionFilter => _transactionFilter.value;

  // Tab titles
  final List<String> tabTitles = [
    'Overview',
    'Transactions',
    'Credit Balance',
    'Activity'
  ];

  @override
  void onInit() {
    super.onInit();
    // Get student ID from arguments
    final args = Get.arguments;
    if (args is slr.Student) {
      _studentId.value = args.studentId ?? 0;
    } else if (args is Map && args['id'] != null) {
      _studentId.value = args['id'];
    }
    loadStudentDetails();
  }

  // Load student details from API
  Future<void> loadStudentDetails() async {
    _isLoading.value = true;
    
    try {
      
     final res = await NetworkServicesApi().getApi(
        path: 'student/details/${_studentId.value}',
        // path: 'driver/details/1',
      );

      final response = studentDetailsResponseFromJson(res);

      _studentDetails.value = response.details;
      
     
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load student details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Set selected tab
  void setSelectedTab(int index) {
    _selectedTab.value = index;
  }

  // Set transaction filter
  void setTransactionFilter(String filter) {
    _transactionFilter.value = filter;
  }

  // Get filtered transactions
  List<Transaction> get filteredTransactions {
    if (_transactionFilter.value == 'all') {
      return transactions;
    }
    return transactions.where((t) => 
      t.status?.toLowerCase() == _transactionFilter.value.toLowerCase()
    ).toList();
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadStudentDetails();
  }

  // Actions
  void editStudent() {
    Get.snackbar('Edit Student', 'Edit functionality coming soon!');
  }

  void suspendStudent() {
    Get.defaultDialog(
      title: 'Suspend Student',
      middleText: 'Are you sure you want to suspend this student account?',
      textConfirm: 'Suspend',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.snackbar('Success', 'Student account suspended');
      },
    );
  }

  void contactStudent() {
    Get.snackbar('Contact', 'Calling ${student?.phoneNumber}...');
  }

  void sendNotification() {
    Get.snackbar('Notification', 'Notification sent to student');
  }

  void viewDriverDetails() {
    if (driver != null) {
      
      Get.toNamed(AppRoutes.driverDetails, arguments: {"id": driver?.id});
      Get.snackbar('Driver Details', 'Opening details for ${driver?.driverName}');
    }
  }

  void recordPayment() {
    Get.snackbar('Record Payment', 'Payment recording functionality coming soon!');
  }

  void sendPaymentReminder() {
    Get.snackbar('Payment Reminder', 'Payment reminder sent to student');
  }

  // Get student status
  String get studentStatus {
    if (student?.accountActive == true && driver != null) {
      return 'Active';
    } else if (student?.accountActive == true) {
      return 'Active (No Driver)';
    } else {
      return 'Inactive';
    }
  }

  Color get statusColor {
    if (student?.accountActive == true && driver != null) {
      return Colors.green;
    } else if (student?.accountActive == true) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Calculate statistics
  int get totalPaid {
    return transactions
        .where((t) => t.status?.toLowerCase() == 'completed')
        .fold(0, (sum, t) => sum + (t.amount ?? 0));
  }

  int get totalPending {
    return transactions
        .where((t) => t.status?.toLowerCase() == 'pending')
        .fold(0, (sum, t) => sum + (t.amount ?? 0));
  }

  int get completedTransactions {
    return transactions.where((t) => t.status?.toLowerCase() == 'completed').length;
  }

  int get pendingTransactions {
    return transactions.where((t) => t.status?.toLowerCase() == 'pending').length;
  }

  int get failedTransactions {
    return transactions.where((t) => t.status?.toLowerCase() == 'failed').length;
  }

  // Get due amount (proposed fee - credit balance)
  int get dueAmount {
    return (student?.proposedFee ?? 0) - (creditBalance?.credit ?? 0);
  }
}