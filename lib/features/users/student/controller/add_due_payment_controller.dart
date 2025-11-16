// =============================================================================
// ADD DUE PAYMENT CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../model/student_details_response.dart';

class AddDuePaymentController extends GetxController {
  // Text Controllers
  final amountController = TextEditingController();

  // Reactive variables
  final _selectedMonth = 0.obs;
  final _selectedYear = 0.obs;
  final _selectedStatus = 'pending'.obs;
  final _amountError = ''.obs;
  final _isSubmitting = false.obs;
  final _isValid = false.obs;

  // Student data (passed as arguments)
  final _student = Rxn<Student>();
  final _driver = Rxn<Driver>();
  final _latestAmount = 0.obs;
  final _studentId = 0.obs;

  // Getters
  int get selectedMonth => _selectedMonth.value;
  int get selectedYear => _selectedYear.value;
  String get selectedStatus => _selectedStatus.value;
  String get amountError => _amountError.value;
  bool get isSubmitting => _isSubmitting.value;
  bool get isValid => _isValid.value;
  Student? get student => _student.value;
  Driver? get driver => _driver.value;
  int get latestAmount => _latestAmount.value;

  // Available years (current year - 1 to current year + 2)
  List<int> get availableYears {
    final currentYear = DateTime.now().year;
    return List.generate(4, (index) => currentYear - 1 + index);
  }

  // Status options with icons and colors
  final List<Map<String, dynamic>> statusOptions = [
    {
      'value': 'pending',
      'label': 'Pending',
      'icon': Icons.schedule,
      'color': Colors.orange,
    },
    {
      'value': 'paid',
      'label': 'Paid',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'value': 'overdue',
      'label': 'Overdue',
      'icon': Icons.warning,
      'color': Colors.red,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _setupListeners();
  }

  void _initializeData() {
    // Get data from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      
      _student.value = args['student'] as Student?;
      _driver.value = args['driver'] as Driver?;
      _latestAmount.value = args['latestAmount'] as int? ?? 0;
      _studentId.value = args['studentId'] as int? ?? 0;
    }

    // Initialize with current month and year
    final now = DateTime.now();
    _selectedMonth.value = now.month;
    _selectedYear.value = now.year;

    // Pre-fill amount with latest amount or proposed fee
    if (_latestAmount.value > 0) {
      amountController.text = _latestAmount.value.toString();
    } else if (_student.value?.proposedFee != null) {
      amountController.text = _student.value!.proposedFee.toString();
    }

    _validateForm();
  }

  void _setupListeners() {
    amountController.addListener(_validateForm);
    ever(_selectedMonth, (_) => _validateForm());
    ever(_selectedYear, (_) => _validateForm());
    ever(_selectedStatus, (_) => _validateForm());
  }

  // Set month
  void setMonth(int month) {
    _selectedMonth.value = month;
  }

  // Set year
  void setYear(int year) {
    _selectedYear.value = year;
  }

  // Set status
  void setStatus(String status) {
    _selectedStatus.value = status;
  }

  // Validate amount field
  void validateAmount(String value) {
    if (value.isEmpty) {
      _amountError.value = 'Amount is required';
    } else {
      final amount = int.tryParse(value);
      if (amount == null || amount <= 0) {
        _amountError.value = 'Please enter a valid amount';
      } else {
        _amountError.value = '';
      }
    }
    _validateForm();
  }

  // Validate entire form
  void _validateForm() {
    final amount = int.tryParse(amountController.text);
    _isValid.value = amount != null && 
                     amount > 0 && 
                     _selectedMonth.value > 0 && 
                     _selectedYear.value > 0 &&
                     _amountError.value.isEmpty;
  }

  // Submit due payment
  Future<void> submitDuePayment() async {
    if (!_isValid.value || _isSubmitting.value) return;

    // Validate inputs
    final amount = int.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedMonth.value < 1 || _selectedMonth.value > 12) {
      Get.snackbar(
        'Error',
        'Please select a valid month',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isSubmitting.value = true;

    try {
      // Prepare data
      final data = {
        'student_id': _studentId.value,
        'driver_id': _driver.value?.id,
        'amount': amount,
        'due_month': _selectedMonth.value,
        'due_year': _selectedYear.value,
        'status': _selectedStatus.value,
      };

      // Make API call
      final response = await NetworkServicesApi().postApi(
        path: 'due-payments',
        data: data,
      );

      // Handle response
      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Due payment added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        
        // Return true to indicate success
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to add due payment',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add due payment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}