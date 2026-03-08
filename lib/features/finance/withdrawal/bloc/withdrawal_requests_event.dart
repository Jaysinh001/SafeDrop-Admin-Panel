import 'package:equatable/equatable.dart';
import '../model/withdrawal_request_response.dart';

abstract class WithdrawalRequestsEvent extends Equatable {
  const WithdrawalRequestsEvent();

  @override
  List<Object?> get props => [];
}

class WithdrawalRequestsLoaded extends WithdrawalRequestsEvent {}

class WithdrawalRequestsRefreshed extends WithdrawalRequestsEvent {}

class WithdrawalRequestsSearchQueryChanged extends WithdrawalRequestsEvent {
  final String query;
  const WithdrawalRequestsSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class WithdrawalRequestsFilterChanged extends WithdrawalRequestsEvent {
  final String filter;
  const WithdrawalRequestsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class WithdrawalRequestApproved extends WithdrawalRequestsEvent {
  final Request request;
  const WithdrawalRequestApproved(this.request);

  @override
  List<Object?> get props => [request];
}

class WithdrawalRequestRejected extends WithdrawalRequestsEvent {
  final Request request;
  final String reason;
  const WithdrawalRequestRejected(this.request, this.reason);

  @override
  List<Object?> get props => [request, reason];
}
