import 'package:equatable/equatable.dart';
import '../model/withdrawal_request_response.dart';

class WithdrawalRequestsState extends Equatable {
  final List<Request> withdrawalRequests;
  final List<Request> filteredRequests;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final Set<int> processingIds;

  const WithdrawalRequestsState({
    this.withdrawalRequests = const [],
    this.filteredRequests = const [],
    this.isLoading = false,
    this.selectedFilter = 'pending',
    this.searchQuery = '',
    this.processingIds = const {},
  });

  WithdrawalRequestsState copyWith({
    List<Request>? withdrawalRequests,
    List<Request>? filteredRequests,
    bool? isLoading,
    String? selectedFilter,
    String? searchQuery,
    Set<int>? processingIds,
  }) {
    return WithdrawalRequestsState(
      withdrawalRequests: withdrawalRequests ?? this.withdrawalRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      processingIds: processingIds ?? this.processingIds,
    );
  }

  @override
  List<Object?> get props => [
    withdrawalRequests,
    filteredRequests,
    isLoading,
    selectedFilter,
    searchQuery,
    processingIds,
  ];
}
