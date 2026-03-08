import 'package:equatable/equatable.dart';
import '../model/transactions_list_model.dart' as list_model;

abstract class TransactionDetailsEvent extends Equatable {
  const TransactionDetailsEvent();

  @override
  List<Object?> get props => [];
}

class TransactionDetailsLoaded extends TransactionDetailsEvent {
  final list_model.Transaction? transaction;
  final int? transactionId;
  const TransactionDetailsLoaded({this.transaction, this.transactionId});

  @override
  List<Object?> get props => [transaction, transactionId];
}

class TransactionDetailsRefreshed extends TransactionDetailsEvent {}

class TransactionDetailsRefundRequested extends TransactionDetailsEvent {}

class TransactionDetailsRetryRequested extends TransactionDetailsEvent {}

class TransactionDetailsDownloadRequested extends TransactionDetailsEvent {}

class TransactionDetailsShareRequested extends TransactionDetailsEvent {}
