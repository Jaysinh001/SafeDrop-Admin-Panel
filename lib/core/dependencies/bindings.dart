// =============================================================================
// Binding Class for Dependency Injection
// =============================================================================

import 'package:get/get.dart';

import '../../features/auth/controller/login_controller.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/driver/controller/driver_detail_controller.dart';
import '../../features/driver/controller/drivers_list_controller.dart';
import '../../features/withdrawal/controller/withdrawal_request_controller.dart';
import '../../shared/layout/view/admin_layout_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

// =============================================================================
// ADMIN LAYOUT BINDING
// =============================================================================

class AdminLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminLayoutController>(() => AdminLayoutController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

// =============================================================================
// DASHBOARD BINDING
// =============================================================================

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<AdminLayoutController>(() => AdminLayoutController());
  }
}

// =============================================================================
// WITHDRAWAL REQUESTS BINDING
// =============================================================================

class WithdrawalRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawalRequestsController>(
      () => WithdrawalRequestsController(),
    );
    Get.lazyPut<AdminLayoutController>(() => AdminLayoutController());
  }
}

// =============================================================================
// DRIVERS LIST BINDING
// =============================================================================

class DriversListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriversListController>(() => DriversListController());
    Get.lazyPut<AdminLayoutController>(() => AdminLayoutController());
  }
}

// =============================================================================
// DRIVER DETAILS BINDING
// =============================================================================

class DriverDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDetailsController>(() => DriverDetailsController());
    Get.lazyPut<AdminLayoutController>(() => AdminLayoutController());
  }
}
