import 'package:get/get.dart';
import 'package:safedrop_panel/features/users/driver/view/driver_detail_view.dart';

import '../../features/auth/view/login_view.dart';
import '../../features/dashboard/view/dashboard_view.dart';
import '../../features/finance/transactions/view/transaction_details_view.dart';
import '../../features/finance/transactions/view/transactions_list_view.dart';
import '../../features/users/driver/view/drivers_list_view.dart';
import '../../features/users/student/view/student_detail_view.dart';
import '../../features/users/student/view/students_list_view.dart';
import '../../features/finance/withdrawal/view/withdrawal_request_view.dart';
import '../../shared/layout/view/admin_panel_layout.dart';
import '../dependencies/bindings.dart';
import 'app_routes.dart';

class AppPages {
  // static const initial = AppRoutes.splash;
  static const initial = AppRoutes.login;

  static final routes = [
    // =======================================================================
    // AUTHENTICATION ROUTES
    // =======================================================================
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // =======================================================================
    // MAIN LAYOUT ROUTES - Protected by AdminLayoutBinding
    // =======================================================================
    GetPage(
      name: AppRoutes.dashboard,
      page: () => AdminPanelLayout(child: const DashboardView()),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.adminDashboard,
      page:
          () => AdminPanelLayout(
            child: const DashboardView(),
            // child: const AdminDashboardView(),
          ),

      binding: AdminLayoutBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.withdrawals,
      page: () => AdminPanelLayout(child: const WithdrawalRequestsView()),
      binding: WithdrawalRequestsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => AdminPanelLayout(child: const TransactionsListView()),
      binding: TransactionsListBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.transactionDetails,
      page: () => AdminPanelLayout(child: const TransactionDetailsView()),
      binding: TransactionDetailsBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.driversList,
      page: () => AdminPanelLayout(child: const DriversListView()),
      binding: DriversListBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.driverDetails,
      page: () => AdminPanelLayout(child: const DriverDetailsView()),
      binding: DriverDetailsBinding(),
      transition: Transition.rightToLeft,
      preventDuplicates: true,
    ),
    GetPage(
      name: AppRoutes.studentsList,
      page: () => AdminPanelLayout(child: const StudentsListView()),
      binding: StudentsListBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.studentDetails,
      page: () => AdminPanelLayout(child: const StudentDetailsView()),
      binding: StudentDetailsBinding(),
      transition: Transition.rightToLeft,
      preventDuplicates: true,
    ),

    // GetPage(
    //   name: AppRoutes.userManagement,
    //   page: () => AdminPanelLayout(
    //     child: const UserManagementView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.analytics,
    //   page: () => AdminPanelLayout(
    //     child: const AnalyticsView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.fadeIn,
    // ),

    // GetPage(
    //   name: AppRoutes.settings,
    //   page: () => AdminPanelLayout(
    //     child: const SettingsView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.reports,
    //   page: () => AdminPanelLayout(
    //     child: const ReportsView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.content,
    //   page: () => AdminPanelLayout(
    //     child: const ContentDashboardView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    // ),

    // GetPage(
    //   name: AppRoutes.contentList,
    //   page: () => AdminPanelLayout(
    //     child: const ContentListView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.createContent,
    //   page: () => AdminPanelLayout(
    //     child: const CreateContentView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.mediaLibrary,
    //   page: () => AdminPanelLayout(
    //     child: const MediaLibraryView(),
    //   ),
    //   binding: AdminLayoutBinding(),
    //   transition: Transition.downToUp,
    // ),

    // =======================================================================
    // ERROR ROUTES
    // =======================================================================
    // GetPage(
    //   name: AppRoutes.notFound,
    //   page: () => const NotFoundView(),
    //   transition: Transition.fadeIn,
    // ),

    // GetPage(
    //   name: AppRoutes.unauthorized,
    //   page: () => const UnauthorizedView(),
    //   transition: Transition.fadeIn,
    // ),

    // GetPage(
    //   name: AppRoutes.serverError,
    //   page: () => const ServerErrorView(),
    //   transition: Transition.fadeIn,
    // ),
  ];
}
