// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:safedrop_panel/core/services/network_services_api.dart';

// import '../model/transaction_details_model.dart';
// import 'transaction_details_event.dart';
// import 'transaction_details_state.dart';

// class TransactionDetailsBloc
//     extends Bloc<TransactionDetailsEvent, TransactionDetailsState> {
//   TransactionDetailsBloc() : super(const TransactionDetailsState()) {
//     on<TransactionDetailsLoaded>(_onLoaded);
//     on<TransactionDetailsRefreshed>(_onRefreshed);
//     on<TransactionDetailsRefundRequested>(_onRefundRequested);
//     on<TransactionDetailsRetryRequested>(_onRetryRequested);
//     on<TransactionDetailsDownloadRequested>(_onDownloadRequested);
//     on<TransactionDetailsShareRequested>(_onShareRequested);
//   }

//   Future<void> _onLoaded(
//     TransactionDetailsLoaded event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     int id = 0;
//     if (event.transaction != null) {
//       id = event.transaction!.id ?? 0;
//     } else if (event.transactionId != null) {
//       id = event.transactionId!;
//     }
//     emit(state.copyWith(transactionId: id));
//     await _fetchData(emit, id);
//   }

//   Future<void> _onRefreshed(
//     TransactionDetailsRefreshed event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     await _fetchData(emit, state.transactionId);
//   }

//   Future<void> _fetchData(Emitter<TransactionDetailsState> emit, int id) async {
//     if (id == 0) {
//       Get.snackbar(
//         'Error',
//         'Invalid transaction ID',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     emit(state.copyWith(isLoading: true));

//     try {
//       final res = await NetworkServicesApi().getApi(
//         path: 'transaction/details/$id',
//       );
//       final response = transactionDetailsResponseFromJson(res);

//       if (response.success == true) {
//         emit(
//           state.copyWith(
//             transaction: response.transaction,
//             paymentLogs: response.paymentLogs ?? [],
//             isLoading: false,
//           ),
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to load transaction: ${response.message}',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         emit(state.copyWith(isLoading: false));
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load transaction: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       emit(state.copyWith(isLoading: false));
//     }
//   }

//   Future<void> _onRefundRequested(
//     TransactionDetailsRefundRequested event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     if (!state.canRefund) {
//       Get.snackbar(
//         'Error',
//         'This transaction cannot be refunded',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final confirm = await Get.dialog<bool>(
//       AlertDialog(
//         title: const Text('Confirm Refund'),
//         content: Text(
//           'Are you sure you want to refund ₹${state.transaction?.amount} for this transaction?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(result: false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Get.back(result: true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Refund'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       Get.snackbar(
//         'Refund',
//         'Processing refund for transaction #${state.transaction?.id}',
//         duration: const Duration(seconds: 2),
//       );
//     }
//   }

//   Future<void> _onRetryRequested(
//     TransactionDetailsRetryRequested event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     if (!state.canRetry) {
//       Get.snackbar(
//         'Error',
//         'This transaction cannot be retried',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     Get.snackbar(
//       'Retry',
//       'Retrying transaction #${state.transaction?.id}',
//       duration: const Duration(seconds: 2),
//     );
//   }

//   Future<void> _onDownloadRequested(
//     TransactionDetailsDownloadRequested event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     if (state.transaction == null) return;
//     Get.snackbar(
//       'Download',
//       'Downloading receipt for transaction #${state.transaction?.id}',
//       duration: const Duration(seconds: 2),
//     );
//   }

//   Future<void> _onShareRequested(
//     TransactionDetailsShareRequested event,
//     Emitter<TransactionDetailsState> emit,
//   ) async {
//     if (state.transaction == null) return;
//     Get.snackbar(
//       'Share',
//       'Sharing transaction #${state.transaction?.id}',
//       duration: const Duration(seconds: 2),
//     );
//   }
// }
