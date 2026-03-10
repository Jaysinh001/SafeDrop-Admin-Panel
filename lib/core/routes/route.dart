import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/dashboard/view/dashboard_view.dart';
import '../../features/finance/transactions/view/transaction_details_view.dart';
import '../../features/finance/transactions/view/transactions_list_view.dart';
import '../../features/settings/organization_profile/view/organization_profile_view.dart';
import '../../features/users/driver/view/drivers_list_view.dart';
import '../../features/users/driver/view/driver_detail_view.dart';
import '../../features/users/student/view/student_detail_view.dart';
import '../../features/users/student/view/students_list_view.dart';
import '../../features/finance/withdrawal/view/withdrawal_request_view.dart';
import '../../shared/layout/view/admin_panel_layout.dart';
import '../../shared/widgets/error_screens.dart';
import '../../shared/widgets/placeholder_view.dart';
import '../../features/rbac/presentation/screens/rbac_dashboard_screen.dart';
import '../../features/rbac/bloc/rbac_bloc.dart';
import '../../features/rbac/data/repositories/rbac_repository.dart';
import '../dependencies/injection_container.dart';
import 'app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),

      // Main Admin Shell
      ShellRoute(
        builder: (context, state, child) {
          return AdminPanelLayout(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardView(),
          ),
          GoRoute(
            path: AppRoutes.withdrawals,
            builder: (context, state) => const WithdrawalRequestsView(),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            builder: (context, state) => const TransactionsListView(),
          ),
          GoRoute(
            path: AppRoutes.transactionDetails,
            builder: (context, state) => const TransactionDetailsView(),
          ),
          GoRoute(
            path: AppRoutes.driversList,
            builder: (context, state) => const DriversListView(),
          ),
          GoRoute(
            path: AppRoutes.driverDetails,
            builder: (context, state) => const DriverDetailsView(),
          ),
          GoRoute(
            path: AppRoutes.studentsList,
            builder: (context, state) => const StudentsListView(),
          ),
          GoRoute(
            path: AppRoutes.studentDetails,
            builder: (context, state) => const StudentDetailsView(),
          ),
          GoRoute(
            path: AppRoutes.organizationProfile,
            builder: (context, state) => const OrganizationDetailsView(),
          ),

          // Placeholder Routes for missing views
          GoRoute(
            path: '/users',
            builder: (context, state) => const PlaceholderView(title: 'Users'),
          ),
          GoRoute(
            path: '/finance',
            builder:
                (context, state) => const PlaceholderView(title: 'Finance'),
          ),
          GoRoute(
            path: AppRoutes.content,
            builder:
                (context, state) => const PlaceholderView(title: 'Content'),
          ),
          GoRoute(
            path: AppRoutes.contentList,
            builder:
                (context, state) =>
                    const PlaceholderView(title: 'Content List'),
          ),
          GoRoute(
            path: AppRoutes.createContent,
            builder:
                (context, state) =>
                    const PlaceholderView(title: 'Create Content'),
          ),
          GoRoute(
            path: AppRoutes.mediaLibrary,
            builder:
                (context, state) =>
                    const PlaceholderView(title: 'Media Library'),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder:
                (context, state) => const PlaceholderView(title: 'Analytics'),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder:
                (context, state) => const PlaceholderView(title: 'Settings'),
          ),
          GoRoute(
            path: '/admin/settings/system',
            builder:
                (context, state) =>
                    const PlaceholderView(title: 'System Settings'),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder:
                (context, state) => const PlaceholderView(title: 'Reports'),
          ),
          GoRoute(
            path: AppRoutes.rbac,
            builder:
                (context, state) => BlocProvider(
                  create:
                      (context) => RbacBloc(repository: sl<RbacRepository>()),
                  child: const RbacDashboardScreen(),
                ),
          ),
        ],
      ),
    ],
  );
}
