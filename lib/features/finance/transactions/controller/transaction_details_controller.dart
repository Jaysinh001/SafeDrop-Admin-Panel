// =============================================================================
// TRANSACTION DETAILS CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../model/transaction_details_model.dart';
import '../model/transactions_list_model.dart' as tlm;

class TransactionDetailsController extends GetxController {
  // Reactive variables
  final _transaction = Rxn<Transaction>();
  final _paymentLogs = <PaymentLog>[].obs;
  final _isLoading = false.obs;
  final _transactionId = 0.obs;

  // Getters
  Transaction? get transaction => _transaction.value;
  List<PaymentLog> get paymentLogs => _paymentLogs.toList();
  bool get isLoading => _isLoading.value;
  int get transactionId => _transactionId.value;

  @override
  void onInit() {
    super.onInit();

    // Get transaction ID from arguments
    final args = Get.arguments;
    if (args is tlm.Transaction) {
      _transactionId.value = args.id ?? 0;
    } else if (args is Map && args['id'] != null) {
      _transactionId.value = args['id'];
    }
    loadTransactionDetails();
  }

  // Load transaction details from API
  Future<void> loadTransactionDetails() async {
    if (_transactionId.value == 0) {
      Get.snackbar(
        'Error',
        'Invalid transaction ID',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    try {
      final res = await NetworkServicesApi().getApi(
        path: 'transaction/details/${_transactionId.value}',
      );

      final response = transactionDetailsResponseFromJson(res);

      if (response.success == true) {
        _transaction.value = response.transaction;
        _paymentLogs.value = response.paymentLogs ?? [];
      } else {
        Get.snackbar(
          'Error',
          'Failed to load transaction: ${response.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transaction: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadTransactionDetails();
  }

  // View student details
  void viewStudentDetails() {
    if (_transaction.value?.studentId != null) {
      // Navigate to student details page
      // Get.toNamed('/student/${_transaction.value!.studentId}');

      Get.snackbar(
        'Student Details',
        'Opening details for ${_transaction.value?.studentName}',
        duration: const Duration(seconds: 2),
      );
    }
  }

  // View driver details
  void viewDriverDetails() {
    if (_transaction.value?.driverId != null) {
      // Navigate to driver details page
      // Get.toNamed('/driver/${_transaction.value!.driverId}');

      Get.snackbar(
        'Driver Details',
        'Opening details for ${_transaction.value?.driverName}',
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Download receipt (optional feature)
  Future<void> downloadReceipt() async {
    if (_transaction.value == null) return;

    Get.snackbar(
      'Download',
      'Downloading receipt for transaction #${_transaction.value!.id}',
      duration: const Duration(seconds: 2),
    );

    // Implement receipt download logic here
  }

  // Share transaction details (optional feature)
  void shareTransaction() {
    if (_transaction.value == null) return;

    Get.snackbar(
      'Share',
      'Sharing transaction #${_transaction.value!.id}',
      duration: const Duration(seconds: 2),
    );

    // Implement share logic here
  }

  // Get transaction status info
  Map<String, dynamic> get transactionStatusInfo {
    if (_transaction.value == null) {
      return {
        'status': 'Unknown',
        'color': Colors.grey,
        'icon': Icons.help,
        'message': 'No transaction data available',
      };
    }

    final status = (_transaction.value!.status ?? '').toLowerCase();

    switch (status) {
      case 'success':
        return {
          'status': 'Success',
          'color': Colors.green,
          'icon': Icons.check_circle,
          'message': 'Payment completed successfully',
        };
      case 'pending':
        return {
          'status': 'Pending',
          'color': Colors.orange,
          'icon': Icons.schedule,
          'message': 'Payment is being processed',
        };
      case 'created':
        return {
          'status': 'Created',
          'color': Colors.blue,
          'icon': Icons.fiber_new,
          'message': 'Transaction has been created',
        };
      case 'failed':
        return {
          'status': 'Failed',
          'color': Colors.red,
          'icon': Icons.cancel,
          'message': 'Payment failed',
        };
      default:
        return {
          'status': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help,
          'message': 'Status unknown',
        };
    }
  }

  // Check if transaction can be refunded
  bool get canRefund {
    if (_transaction.value == null) return false;
    final status = (_transaction.value!.status ?? '').toLowerCase();
    return status == 'success';
  }

  // Check if transaction can be retried
  bool get canRetry {
    if (_transaction.value == null) return false;
    final status = (_transaction.value!.status ?? '').toLowerCase();
    return status == 'failed';
  }

  // Refund transaction (placeholder)
  Future<void> refundTransaction() async {
    if (!canRefund) {
      Get.snackbar(
        'Error',
        'This transaction cannot be refunded',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Refund'),
        content: Text(
          'Are you sure you want to refund ₹${_transaction.value!.amount} for this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Refund'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Implement refund logic
      Get.snackbar(
        'Refund',
        'Processing refund for transaction #${_transaction.value!.id}',
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Retry transaction (placeholder)
  Future<void> retryTransaction() async {
    if (!canRetry) {
      Get.snackbar(
        'Error',
        'This transaction cannot be retried',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Retry',
      'Retrying transaction #${_transaction.value!.id}',
      duration: const Duration(seconds: 2),
    );

    // Implement retry logic
  }
}
