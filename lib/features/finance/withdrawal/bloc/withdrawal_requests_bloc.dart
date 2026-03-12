// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:safedrop_panel/core/services/network_services_api.dart';

// import '../../../../core/theme/colors.dart';
// import '../../../users/driver/model/general_api_response.dart';
// import '../model/withdrawal_request_response.dart';
// import 'withdrawal_requests_event.dart';
// import 'withdrawal_requests_state.dart';

// class WithdrawalRequestsBloc
//     extends Bloc<WithdrawalRequestsEvent, WithdrawalRequestsState> {
//   final List<String> filterOptions = ['all', 'pending', 'approved', 'rejected'];

//   WithdrawalRequestsBloc() : super(const WithdrawalRequestsState()) {
//     on<WithdrawalRequestsLoaded>(_onLoaded);
//     on<WithdrawalRequestsRefreshed>(_onRefreshed);
//     on<WithdrawalRequestsSearchQueryChanged>(_onSearchQueryChanged);
//     on<WithdrawalRequestsFilterChanged>(_onFilterChanged);
//     on<WithdrawalRequestApproved>(_onApproved);
//     on<WithdrawalRequestRejected>(_onRejected);

//     add(WithdrawalRequestsLoaded());
//   }

//   Future<void> _onLoaded(
//     WithdrawalRequestsLoaded event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) async {
//     await _fetchData(emit);
//   }

//   Future<void> _onRefreshed(
//     WithdrawalRequestsRefreshed event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) async {
//     await _fetchData(emit);
//   }

//   Future<void> _fetchData(Emitter<WithdrawalRequestsState> emit) async {
//     emit(state.copyWith(isLoading: true));

//     try {
//       final res = await NetworkServicesApi().getApi(path: 'getAllWithdrawals');
//       final response = withdrawalRequestResponseFromJson(res);

//       emit(state.copyWith(withdrawalRequests: response.requests ?? []));
//       _applyFilters(emit);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load withdrawal requests: $e',
//         backgroundColor: AppColors.error,
//         colorText: AppColors.onError,
//       );
//       emit(state.copyWith(isLoading: false));
//     }
//   }

//   void _onSearchQueryChanged(
//     WithdrawalRequestsSearchQueryChanged event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) {
//     emit(state.copyWith(searchQuery: event.query));
//     _applyFilters(emit);
//   }

//   void _onFilterChanged(
//     WithdrawalRequestsFilterChanged event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) {
//     emit(state.copyWith(selectedFilter: event.filter));
//     _applyFilters(emit);
//   }

//   void _applyFilters(Emitter<WithdrawalRequestsState> emit) {
//     List<Request> filtered = List.from(state.withdrawalRequests);

//     if (state.selectedFilter != 'all') {
//       filtered =
//           filtered
//               .where(
//                 (request) =>
//                     request.status?.toLowerCase() ==
//                     state.selectedFilter.toLowerCase(),
//               )
//               .toList();
//     }

//     if (state.searchQuery.isNotEmpty) {
//       final query = state.searchQuery.toLowerCase();
//       filtered =
//           filtered
//               .where(
//                 (request) =>
//                     request.id.toString().contains(query) ||
//                     request.driverId.toString().contains(query) ||
//                     (request.note?.toLowerCase().contains(query) ?? false),
//               )
//               .toList();
//     }

//     filtered.sort(
//       (a, b) =>
//           (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
//     );

//     emit(state.copyWith(filteredRequests: filtered, isLoading: false));
//   }

//   Future<void> _onApproved(
//     WithdrawalRequestApproved event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) async {
//     if (event.request.id == null) return;

//     final request = event.request;
//     final newProcessingIds = Set<int>.from(state.processingIds)
//       ..add(request.id!);
//     emit(state.copyWith(processingIds: newProcessingIds));

//     try {
//       var payload = {'id': request.id, 'approve': true, 'note': ''};
//       final res = await NetworkServicesApi().postApi(
//         path: 'withdrawalAction',
//         data: payload,
//       );
//       final response = generalApiResponseFromJson(res);

//       if (response.success ?? false) {
//         final currentRequests = List<Request>.from(state.withdrawalRequests);
//         final index = currentRequests.indexWhere((r) => r.id == request.id);
//         if (index != -1) {
//           currentRequests[index] = request.copyWith(
//             status: 'approved',
//             updatedAt: DateTime.now(),
//           );
//           emit(state.copyWith(withdrawalRequests: currentRequests));
//           _applyFilters(emit);
//         }

//         Get.snackbar(
//           'Success',
//           'Withdrawal request #${request.id} approved successfully',
//           backgroundColor: AppColors.success,
//           colorText: AppColors.onSuccess,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to approve request: ${response.message}',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.onError,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to approve request: $e',
//         backgroundColor: AppColors.error,
//         colorText: AppColors.onError,
//       );
//     } finally {
//       final updatedProcessingIds = Set<int>.from(state.processingIds)
//         ..remove(request.id);
//       emit(state.copyWith(processingIds: updatedProcessingIds));
//     }
//   }

//   Future<void> _onRejected(
//     WithdrawalRequestRejected event,
//     Emitter<WithdrawalRequestsState> emit,
//   ) async {
//     if (event.request.id == null) return;

//     final request = event.request;
//     final reason = event.reason;
//     final newProcessingIds = Set<int>.from(state.processingIds)
//       ..add(request.id!);
//     emit(state.copyWith(processingIds: newProcessingIds));

//     try {
//       var payload = {'id': request.id, 'approve': false, 'note': reason};

//       final res = await NetworkServicesApi().postApi(
//         path: 'withdrawalAction',
//         data: payload,
//       );
//       final response = generalApiResponseFromJson(res);

//       if (response.success ?? false) {
//         final currentRequests = List<Request>.from(state.withdrawalRequests);
//         final index = currentRequests.indexWhere((r) => r.id == request.id);
//         if (index != -1) {
//           currentRequests[index] = request.copyWith(
//             status: 'rejected',
//             note: reason.isNotEmpty ? reason : request.note,
//             updatedAt: DateTime.now(),
//           );
//           emit(state.copyWith(withdrawalRequests: currentRequests));
//           _applyFilters(emit);
//         }

//         Get.snackbar(
//           'Success',
//           'Withdrawal request #${request.id} rejected',
//           backgroundColor: AppColors.warning,
//           colorText: AppColors.onWarning,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to reject request: ${response.message}',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.onError,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to reject request: $e',
//         backgroundColor: AppColors.error,
//         colorText: AppColors.onError,
//       );
//     } finally {
//       final updatedProcessingIds = Set<int>.from(state.processingIds)
//         ..remove(request.id);
//       emit(state.copyWith(processingIds: updatedProcessingIds));
//     }
//   }
// }
