import 'package:equatable/equatable.dart';

import '../model/transaction_details_model.dart' as detail_model;

class TransactionDetailsState extends Equatable {
  final detail_model.Transaction? transaction;
  final List<detail_model.PaymentLog> paymentLogs;
  final bool isLoading;
  final int transactionId;

  const TransactionDetailsState({
    this.transaction,
    this.paymentLogs = const [],
    this.isLoading = false,
    this.transactionId = 0,
  });

  TransactionDetailsState copyWith({
    detail_model.Transaction? transaction,
    List<detail_model.PaymentLog>? paymentLogs,
    bool? isLoading,
    int? transactionId,
  }) {
    return TransactionDetailsState(
      transaction: transaction ?? this.transaction,
      paymentLogs: paymentLogs ?? this.paymentLogs,
      isLoading: isLoading ?? this.isLoading,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  bool get canRefund {
    if (transaction == null) return false;
    final status = (transaction!.status ?? '').toLowerCase();
    return status == 'success';
  }

  bool get canRetry {
    if (transaction == null) return false;
    final status = (transaction!.status ?? '').toLowerCase();
    return status == 'failed';
  }

  @override
  List<Object?> get props => [
    transaction,
    paymentLogs,
    isLoading,
    transactionId,
  ];
}
