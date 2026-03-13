import 'package:get_it/get_it.dart';

import '../../features/auth/bloc/login_bloc.dart';

import '../../features/auth/repo/auth_repository.dart';
import '../../features/dashboard/bloc/dashboard_bloc.dart';

import '../../features/finance/transactions/bloc/transactions_list_bloc.dart';
import '../../features/finance/transactions/bloc/transaction_details_bloc.dart';
import '../../features/finance/withdrawal/bloc/withdrawal_requests_bloc.dart';

import '../../features/users/driver/bloc/driver_list_bloc/drivers_list_bloc.dart';
import '../../features/users/driver/bloc/driver_details_bloc/driver_details_bloc.dart';

import '../../features/users/driver/repo/driver_repository.dart';
import '../../features/users/employee/employee_list_bloc/employee_list_bloc.dart';
import '../../features/users/employee/repo/employee_repository.dart';
import '../../features/users/student/bloc/student_list_bloc/students_list_bloc.dart';
import '../../features/users/student/bloc/student_details_bloc/student_detail_bloc.dart';

import '../../features/users/student/repo/student_repository.dart';
import '../../shared/layout/bloc/admin_layout_bloc.dart';

import '../../features/rbac/bloc/rbac_bloc.dart';
import '../../features/rbac/data/repositories/rbac_repository.dart';
import '../../features/rbac/data/repositories/mock_rbac_repository.dart';

import '../data/local_storage/local_storage_service.dart';
import '../data/local_storage/local_storage_service_impl.dart';

import '../data/network/api_client.dart';

import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {

  /// Local Storage
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(),
  );

  /// API CLIENT
  sl.registerLazySingleton<ApiClient>(
  () => ApiClient(sl<LocalStorageService>()),
);

  /// REPOSITORIES

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<ApiClient>()),
  );

  sl.registerLazySingleton<DriverRepository>(
    () => DriverRepository(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepository(apiClient:  sl<ApiClient>()),
  );

  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepository(apiClient:  sl<ApiClient>()),
  );

  sl.registerLazySingleton<RbacRepository>(
    () => MockRbacRepository(sl<Dio>()),
  );

  /// CORE BLOCS
  sl.registerLazySingleton<AdminLayoutBloc>(
    () => AdminLayoutBloc(),
  );

  /// FEATURE BLOCS

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
      authRepository: sl<AuthRepository>(),
      storage: sl<LocalStorageService>(),
    ),
  );

  sl.registerFactory<DashboardBloc>(() => DashboardBloc());

  // sl.registerFactory<TransactionsListBloc>(() => TransactionsListBloc());
  // sl.registerFactory<TransactionDetailsBloc>(() => TransactionDetailsBloc());

  // sl.registerFactory<WithdrawalRequestsBloc>(() => WithdrawalRequestsBloc());

  sl.registerFactory<DriversListBloc>(() => DriversListBloc(driverRepository:  sl<DriverRepository>() , storage: sl<LocalStorageService>()));
  sl.registerFactory<DriverDetailsBloc>(() => DriverDetailsBloc(driverRepository:  sl<DriverRepository>() , storage: sl<LocalStorageService>()));

  sl.registerFactory<StudentsListBloc>(() => StudentsListBloc(studentRepository: sl<StudentRepository>(), storage: sl<LocalStorageService>()));
  sl.registerFactory<StudentDetailBloc>(() => StudentDetailBloc(studentRepository: sl<StudentRepository>(), storage: sl<LocalStorageService>()));

  sl.registerFactory<EmployeesListBloc>(() => EmployeesListBloc(employeeRepository: sl<EmployeeRepository>(), storage: sl<LocalStorageService>()));

  sl.registerFactory<RbacBloc>(
    () => RbacBloc(repository: sl<RbacRepository>()),
  );

  /// DIO (only if required elsewhere)
  sl.registerLazySingleton<Dio>(() => Dio());
}