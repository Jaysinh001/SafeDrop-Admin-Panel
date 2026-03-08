import 'package:get_it/get_it.dart';

import '../../features/auth/bloc/login_bloc.dart';
import '../../features/dashboard/bloc/dashboard_bloc.dart';
import '../../features/finance/transactions/bloc/transactions_list_bloc.dart';
import '../../features/finance/transactions/bloc/transaction_details_bloc.dart';
import '../../features/finance/withdrawal/bloc/withdrawal_requests_bloc.dart';
import '../../features/users/driver/bloc/drivers_list_bloc.dart';
import '../../features/users/driver/bloc/driver_details_bloc.dart';
import '../../features/users/student/bloc/students_list_bloc.dart';
import '../../features/users/student/bloc/student_detail_bloc.dart';
import '../../shared/layout/bloc/admin_layout_bloc.dart';
import '../../features/rbac/bloc/rbac_bloc.dart';
import '../../features/rbac/data/repositories/rbac_repository.dart';
import '../../features/rbac/data/repositories/mock_rbac_repository.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> initLocator() async {
  // Core/Shared Blocs
  sl.registerLazySingleton(() => AdminLayoutBloc());

  // Feature Blocs
  sl.registerFactory(() => LoginBloc());
  sl.registerFactory(() => DashboardBloc());
  sl.registerFactory(() => TransactionsListBloc());
  sl.registerFactory(() => TransactionDetailsBloc());
  sl.registerFactory(() => WithdrawalRequestsBloc());

  // User Feature Blocs
  sl.registerFactory(() => DriversListBloc());
  sl.registerFactory(() => DriverDetailsBloc());
  sl.registerFactory(() => StudentsListBloc());
  sl.registerFactory(() => StudentDetailBloc());

  // RBAC Feature
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<RbacRepository>(() => MockRbacRepository(sl<Dio>()));
  sl.registerFactory(() => RbacBloc(repository: sl<RbacRepository>()));
}
