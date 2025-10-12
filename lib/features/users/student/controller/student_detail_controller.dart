// =============================================================================
// DRIVER DETAILS CONTROLLER
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safedrop_panel/core/services/network_services_api.dart';

import '../../driver/model/drivers_list_response.dart' as dlr;
import '../model/student_details_response.dart';
import '../model/students_list_response.dart' as dlr;

class DriverDetailsController extends GetxController {
  // Reactive variables
  final _driverDetails = Rx<Data?>(null);
  final _isLoading = false.obs;
  final _selectedTab = 0.obs;
  final _driverId = 0.obs;

  // Getters
  Data? get driverDetails => _driverDetails.value;
  Driver? get driver => _driverDetails.value?.driver;
  Wallet? get wallet => _driverDetails.value?.wallet;
  List<BankDetail> get bankDetails => _driverDetails.value?.bankDetails ?? [];
  List<Vehicle> get vehicles => _driverDetails.value?.vehicles ?? [];
  UniqueCode? get uniqueCode => _driverDetails.value?.uniqueCode;
  FcmToken? get fcmToken => _driverDetails.value?.fcmToken;
  bool get isLoading => _isLoading.value;
  int get selectedTab => _selectedTab.value;
  int get driverId => _driverId.value;

  // Tab titles
  final List<String> tabTitles = [
    'Overview',
    'Wallet',
    'Bank Details',
    'Vehicles',
    'Activity',
  ];

  @override
  void onInit() {
    super.onInit();
    // Get driver ID from arguments or route parameters
    final args = Get.arguments;
    if (args is dlr.Driver) {
      _driverId.value = args.id ?? 0;
    } else if (args is Map && args['id'] != null) {
      _driverId.value = args['id'];
    }
    loadDriverDetails();
  }

  // Load driver details from API
  Future<void> loadDriverDetails() async {
    _isLoading.value = true;

    try {
      final res = await NetworkServicesApi().getApi(
        path: 'driver/details/${_driverId.value}',
        // path: 'driver/details/1',
      );

      final response = driversDetailsResponseFromJson(res);

      _driverDetails.value = response.data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load driver details: $e',
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

  // Refresh data
  Future<void> refreshData() async {
    await loadDriverDetails();
  }

  // Actions
  void editDriver() {
    Get.snackbar('Edit Driver', 'Edit functionality coming soon!');
  }

  void suspendDriver() {
    Get.defaultDialog(
      title: 'Suspend Driver',
      middleText: 'Are you sure you want to suspend this driver?',
      textConfirm: 'Suspend',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.snackbar('Success', 'Driver suspended successfully');
      },
    );
  }

  void contactDriver() {
    final phoneNumber = driver?.phoneNumber;
    Get.snackbar('Contact', 'Calling $phoneNumber...');
  }

  void sendNotification() {
    Get.snackbar('Notification', 'Notification sent to driver');
  }

  // Get driver status
  String get driverStatus {
    if (driver?.hasBankDetails == true && driver?.mpinSet == true) {
      return 'Active';
    } else if (driver?.hasBankDetails == true || driver?.mpinSet == true) {
      return 'Incomplete Setup';
    } else {
      return 'Inactive';
    }
  }

  Color get statusColor {
    switch (driverStatus) {
      case 'Active':
        return Colors.green;
      case 'Incomplete Setup':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
