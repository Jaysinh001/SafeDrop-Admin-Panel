// =============================================================================
// WITHDRAWAL REQUESTS CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../users/driver/model/drivers_list_response.dart';
import '../model/withdrawal_request_response.dart';

class WithdrawalRequestsController extends GetxController {
  // Reactive variables
  final _withdrawalRequests = <Request>[].obs;
  final _filteredRequests = <Request>[].obs;
  final _isLoading = false.obs;
  final _selectedFilter = 'pending'.obs;
  final _searchQuery = ''.obs;
  final _isProcessing = <int>{}.obs;

  // Getters
  List<Request> get withdrawalRequests => _withdrawalRequests.toList();
  List<Request> get filteredRequests => _filteredRequests.toList();
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;
  String get searchQuery => _searchQuery.value;
  Set<int> get processingIds => _isProcessing.toSet();

  // Filter options
  final List<String> filterOptions = ['all', 'pending', 'approved', 'rejected'];

  @override
  void onInit() {
    super.onInit();
    loadWithdrawalRequests();

    // Watch for changes in search query and filter
    debounce(
      _searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 500),
    );
    ever(_selectedFilter, (_) => _applyFilters());
  }

  // Load withdrawal requests from API
  Future<void> loadWithdrawalRequests() async {
    _isLoading.value = true;

    try {
      // Simulate API call - Replace with your actual API call
      // await Future.delayed(const Duration(milliseconds: 1000));

      final res = await NetworkServicesApi().getApi(path: 'getAllWithdrawals');

      final response = withdrawalRequestResponseFromJson(res);

      _withdrawalRequests.value = response.requests ?? [];
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load withdrawal requests: $e',
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Apply filters and search
  void _applyFilters() {
    List<Request> filtered = _withdrawalRequests;

    // Apply status filter
    if (_selectedFilter.value != 'all') {
      filtered =
          filtered
              .where(
                (request) =>
                    request.status?.toLowerCase() ==
                    _selectedFilter.value.toLowerCase(),
              )
              .toList();
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (request) =>
                    request.id.toString().contains(_searchQuery.value) ||
                    request.driverId.toString().contains(_searchQuery.value) ||
                    (request.note?.toLowerCase().contains(
                          _searchQuery.value.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
    }

    // Sort by creation date (newest first)
    filtered.sort(
      (a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
    );

    _filteredRequests.value = filtered;
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  // Approve withdrawal request
  Future<void> approveRequest(Request request) async {
    if (request.id == null) return;

    _isProcessing.add(request.id!);
    update();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Update local data
      final index = _withdrawalRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _withdrawalRequests[index] = request.copyWith(
          status: 'approved',
          updatedAt: DateTime.now(),
        );
        _applyFilters();
      }

      Get.snackbar(
        'Success',
        'Withdrawal request #${request.id} approved successfully',
        backgroundColor: AppColors.success,
        colorText: AppColors.onSuccess,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve request: $e',
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
    } finally {
      _isProcessing.remove(request.id!);
      update();
    }
  }

  // Reject withdrawal request
  Future<void> rejectRequest(Request request, String rejectionReason) async {
    if (request.id == null) return;

    _isProcessing.add(request.id!);
    update();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Update local data
      final index = _withdrawalRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _withdrawalRequests[index] = request.copyWith(
          status: 'rejected',
          note: rejectionReason.isNotEmpty ? rejectionReason : request.note,
          updatedAt: DateTime.now(),
        );
        _applyFilters();
      }

      Get.snackbar(
        'Success',
        'Withdrawal request #${request.id} rejected',
        backgroundColor: AppColors.warning,
        colorText: AppColors.onWarning,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject request: $e',
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
    } finally {
      _isProcessing.remove(request.id!);
      update();
    }
  }

  // Show rejection dialog
  void showRejectionDialog(Request request) {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Reject Withdrawal Request'),
          ],
        ),
        content: SizedBox(
          width: Get.width > 600 ? 400 : Get.width * 0.9,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Details:',
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Request ID: #${request.id}'),
                      Text('Driver ID: ${request.driverId}'),
                      Text('Amount: ₹${request.amount}'),
                      Text('Note: ${request.note ?? 'No note'}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rejection Reason:',
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Please provide a reason for rejection...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide a rejection reason';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                rejectRequest(request, reasonController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Reject Request'),
          ),
        ],
      ),
    );
  }

  // Navigate to driver details
  void openDriverDetails(int driverID) {
    // Navigate to driver details view
    Get.toNamed(AppRoutes.driverDetails, arguments: {'id' : driverID});
    Get.snackbar(
      'Driver Selected',
      'Opening details for Driver ID : $driverID',
      duration: const Duration(seconds: 2),
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadWithdrawalRequests();
  }
}
