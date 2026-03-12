// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/colors.dart';
// import '../../../../shared/widgets/loading_view.dart';
// import '../../../../core/dependencies/injection_container.dart';
// import '../bloc/withdrawal_requests_bloc.dart';
// import '../bloc/withdrawal_requests_event.dart';
// import '../bloc/withdrawal_requests_state.dart';
// import '../model/withdrawal_request_response.dart';

// class WithdrawalRequestsView extends StatelessWidget {
//   const WithdrawalRequestsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: sl<WithdrawalRequestsBloc>(),
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         body: BlocBuilder<WithdrawalRequestsBloc, WithdrawalRequestsState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 _buildHeader(context, state),
//                 _buildFilterAndSearch(context, state),
//                 Expanded(
//                   child: () {
//                     if (state.isLoading) {
//                       return const LoadingView(
//                         title: "Loading withdrawal requests...",
//                       );
//                     }

//                     if (state.filteredRequests.isEmpty) {
//                       return _buildEmptyState(context);
//                     }

//                     return _buildRequestsList(context, state);
//                   }(),
//                 ),
//               ],
//             );
//           },
//         ),
//         floatingActionButton: Builder(
//           builder:
//               (context) => FloatingActionButton(
//                 onPressed:
//                     () => context.read<WithdrawalRequestsBloc>().add(
//                       WithdrawalRequestsRefreshed(),
//                     ),
//                 tooltip: 'Refresh',
//                 child: const Icon(Icons.refresh),
//               ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, WithdrawalRequestsState state) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.all(width > 768 ? 24 : 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Withdrawal Requests',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${state.filteredRequests.length} requests found',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (width > 768) _buildQuickStats(state),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats(WithdrawalRequestsState state) {
//     final pending =
//         state.withdrawalRequests.where((r) => r.status == 'pending').length;
//     final approved =
//         state.withdrawalRequests.where((r) => r.status == 'approved').length;
//     final rejected =
//         state.withdrawalRequests.where((r) => r.status == 'rejected').length;

//     return Row(
//       children: [
//         _buildStatChip('Pending', pending, AppColors.warning),
//         const SizedBox(width: 8),
//         _buildStatChip('Approved', approved, AppColors.success),
//         const SizedBox(width: 8),
//         _buildStatChip('Rejected', rejected, AppColors.error),
//       ],
//     );
//   }

//   Widget _buildStatChip(String label, int count, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             '$label ($count)',
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterAndSearch(
//     BuildContext context,
//     WithdrawalRequestsState state,
//   ) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: width > 768 ? 24 : 16,
//         vertical: 12,
//       ),
//       child:
//           width > 768
//               ? _buildDesktopFilterBar(context, state)
//               : _buildMobileFilterBar(context, state),
//     );
//   }

//   Widget _buildDesktopFilterBar(
//     BuildContext context,
//     WithdrawalRequestsState state,
//   ) {
//     final bloc = context.read<WithdrawalRequestsBloc>();
//     return Row(
//       children: [
//         // Search bar
//         Expanded(
//           flex: 2,
//           child: TextField(
//             onChanged:
//                 (val) => bloc.add(WithdrawalRequestsSearchQueryChanged(val)),
//             decoration: InputDecoration(
//               hintText: 'Search by ID, Driver ID, or note...',
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: AppColors.surface,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),

//         // Filter dropdown
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: AppColors.outline),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: state.selectedFilter,
//               items:
//                   bloc.filterOptions
//                       .map(
//                         (filter) => DropdownMenuItem(
//                           value: filter,
//                           child: Text(filter.capitalizeFirst ?? filter),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (value) {
//                 if (value != null)
//                   bloc.add(WithdrawalRequestsFilterChanged(value));
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileFilterBar(
//     BuildContext context,
//     WithdrawalRequestsState state,
//   ) {
//     final bloc = context.read<WithdrawalRequestsBloc>();
//     return Column(
//       children: [
//         // Search bar
//         TextField(
//           onChanged:
//               (val) => bloc.add(WithdrawalRequestsSearchQueryChanged(val)),
//           decoration: InputDecoration(
//             hintText: 'Search requests...',
//             prefixIcon: const Icon(Icons.search),
//             filled: true,
//             fillColor: AppColors.surface,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Filter chips
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children:
//                 bloc.filterOptions.map((filter) {
//                   final isSelected = state.selectedFilter == filter;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: FilterChip(
//                       label: Text(filter.capitalizeFirst ?? filter),
//                       selected: isSelected,
//                       onSelected: (selected) {
//                         if (selected)
//                           bloc.add(WithdrawalRequestsFilterChanged(filter));
//                       },
//                       selectedColor: AppColors.primaryContainer,
//                       checkmarkColor: AppColors.primary,
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRequestsList(
//     BuildContext context,
//     WithdrawalRequestsState state,
//   ) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<WithdrawalRequestsBloc>().add(
//           WithdrawalRequestsRefreshed(),
//         );
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 1024) {
//             return _buildDesktopTable(context, state);
//           } else if (constraints.maxWidth > 768) {
//             return _buildTabletGrid(context, state);
//           } else {
//             return _buildMobileList(context, state);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildDesktopTable(
//     BuildContext context,
//     WithdrawalRequestsState state,
//   ) {
//     return SingleChildScrollView(
//       child: Container(
//         margin: const EdgeInsets.all(24),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.shadow.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: DataTable(
//           columnSpacing: 24,
//           horizontalMargin: 24,
//           columns: const [
//             DataColumn(label: Text('Request ID')),
//             DataColumn(label: Text('Driver ID')),
//             DataColumn(label: Text('Amount')),
//             DataColumn(label: Text('Status')),
//             DataColumn(label: Text('Date')),
//             DataColumn(label: Text('Actions')),
//           ],
//           rows:
//               state.filteredRequests.map((request) {
//                 return DataRow(
//                   cells: [
//                     DataCell(Text('#${request.id}')),
//                     DataCell(Text('${request.driverId}')),
//                     DataCell(Text('₹${request.amount}')),
//                     DataCell(_buildStatusChip(request.status ?? '')),
//                     DataCell(Text(_formatDate(request.createdAt))),
//                     DataCell(_buildActionButtons(context, request, state)),
//                   ],
//                 );
//               }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabletGrid(BuildContext context, WithdrawalRequestsState state) {
//     final bloc = context.read<WithdrawalRequestsBloc>();
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 1.2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: state.filteredRequests.length,
//       itemBuilder: (context, index) {
//         final request = state.filteredRequests[index];
//         return _WithdrawalRequestCard(
//           request: request,
//           onApprove: () => bloc.add(WithdrawalRequestApproved(request)),
//           onReject: () => _showRejectionDialog(context, request),
//           onView: () => _openDriverDetails(request.driverId ?? 0),
//           isProcessing: state.processingIds.contains(request.id),
//         );
//       },
//     );
//   }

//   Widget _buildMobileList(BuildContext context, WithdrawalRequestsState state) {
//     final bloc = context.read<WithdrawalRequestsBloc>();
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: state.filteredRequests.length,
//       itemBuilder: (context, index) {
//         final request = state.filteredRequests[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _WithdrawalRequestCard(
//             request: request,
//             onApprove: () => bloc.add(WithdrawalRequestApproved(request)),
//             onReject: () => _showRejectionDialog(context, request),
//             onView: () => _openDriverDetails(request.driverId ?? 0),
//             isProcessing: state.processingIds.contains(request.id),
//             isMobile: true,
//           ),
//         );
//       },
//     );
//   }

//   void _showRejectionDialog(BuildContext context, Request request) {
//     final TextEditingController reasonController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//     final bloc = context.read<WithdrawalRequestsBloc>();

//     Get.dialog(
//       AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.cancel_outlined, color: AppColors.error),
//             const SizedBox(width: 8),
//             const Text('Reject Withdrawal Request'),
//           ],
//         ),
//         content: SizedBox(
//           width: Get.width > 600 ? 400 : Get.width * 0.9,
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Request Details:',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.surfaceContainer,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Request ID: #${request.id}'),
//                       Text('Driver ID: ${request.driverId}'),
//                       Text('Amount: ₹${request.amount}'),
//                       Text('Note: ${request.note ?? 'No note'}'),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Rejection Reason:',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: reasonController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     hintText: 'Please provide a reason for rejection...',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please provide a rejection reason';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (formKey.currentState!.validate()) {
//                 Get.back();
//                 bloc.add(
//                   WithdrawalRequestRejected(
//                     request,
//                     reasonController.text.trim(),
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.error,
//               foregroundColor: AppColors.onError,
//             ),
//             child: const Text('Reject Request'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _openDriverDetails(int driverID) {
//     Get.toNamed(AppRoutes.driverDetails, arguments: {'id': driverID});
//     Get.snackbar(
//       'Driver Selected',
//       'Opening details for Driver ID : $driverID',
//       duration: const Duration(seconds: 2),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color;
//     IconData icon;

//     switch (status.toLowerCase()) {
//       case 'pending':
//         color = AppColors.warning;
//         icon = Icons.schedule;
//         break;
//       case 'approved':
//         color = AppColors.success;
//         icon = Icons.check_circle;
//         break;
//       case 'rejected':
//         color = AppColors.error;
//         icon = Icons.cancel;
//         break;
//       default:
//         color = AppColors.textSecondary;
//         icon = Icons.help;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 4),
//           Text(
//             status.capitalizeFirst ?? status,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(
//     BuildContext context,
//     Request request,
//     WithdrawalRequestsState state,
//   ) {
//     if (request.status?.toLowerCase() != 'pending') {
//       return Text(
//         'No actions available',
//         style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
//       );
//     }

//     final isProcessing = state.processingIds.contains(request.id);
//     final bloc = context.read<WithdrawalRequestsBloc>();

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (isProcessing) ...[
//           const SizedBox(
//             width: 16,
//             height: 16,
//             child: CircularProgressIndicator(strokeWidth: 2),
//           ),
//         ] else ...[
//           IconButton(
//             onPressed: () => bloc.add(WithdrawalRequestApproved(request)),
//             icon: const Icon(Icons.check, color: AppColors.success),
//             tooltip: 'Approve',
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//           ),
//           const SizedBox(width: 4),
//           IconButton(
//             onPressed: () => _showRejectionDialog(context, request),
//             icon: const Icon(Icons.close, color: AppColors.error),
//             tooltip: 'Reject',
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//           ),
//           const SizedBox(width: 4),
//           IconButton(
//             onPressed: () => _openDriverDetails(request.driverId ?? 0),
//             icon: const Icon(
//               Icons.remove_red_eye_outlined,
//               color: AppColors.info,
//             ),
//             tooltip: 'View Driver',
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.receipt_long_outlined,
//             size: 64,
//             color: AppColors.textTertiary,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No withdrawal requests found',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Withdrawal requests will appear here when available',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed:
//                 () => context.read<WithdrawalRequestsBloc>().add(
//                   WithdrawalRequestsRefreshed(),
//                 ),
//             icon: const Icon(Icons.refresh),
//             label: const Text('Refresh'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'N/A';

//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays == 0) {
//       if (difference.inHours == 0) {
//         return '${difference.inMinutes}m ago';
//       }
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
// }

// // =============================================================================
// // WITHDRAWAL REQUEST CARD COMPONENT
// // =============================================================================

// class _WithdrawalRequestCard extends StatelessWidget {
//   final Request request;
//   final VoidCallback onApprove;
//   final VoidCallback onReject;
//   final VoidCallback onView;
//   final bool isProcessing;
//   final bool isMobile;

//   const _WithdrawalRequestCard({
//     required this.request,
//     required this.onApprove,
//     required this.onReject,
//     required this.onView,
//     required this.isProcessing,
//     this.isMobile = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Request #${request.id}',
//                         style: Theme.of(context).textTheme.titleMedium
//                             ?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         'Driver ID: ${request.driverId}',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildStatusChip(request.status ?? ''),
//               ],
//             ),
//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Icon(Icons.monetization_on, size: 20, color: AppColors.success),
//                 const SizedBox(width: 8),
//                 Text(
//                   '₹${request.amount}',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.success,
//                   ),
//                 ),
//               ],
//             ),

//             if (request.note != null && request.note!.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Text(
//                 'Note: ${request.note}',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],

//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Icon(
//                   Icons.access_time,
//                   size: 16,
//                   color: AppColors.textTertiary,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   _formatDate(request.createdAt),
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppColors.textTertiary,
//                   ),
//                 ),
//               ],
//             ),

//             if (request.status?.toLowerCase() == 'pending') ...[
//               const SizedBox(height: 16),
//               const Divider(),
//               const SizedBox(height: 16),

//               if (isProcessing) ...[
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Processing...',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ] else ...[
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: onReject,
//                         icon: const Icon(Icons.close, size: 18),
//                         label: FittedBox(child: const Text('Reject')),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: AppColors.error,
//                           side: const BorderSide(color: AppColors.error),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: onApprove,
//                         icon: const Icon(Icons.check, size: 18),
//                         label: FittedBox(child: const Text('Approve')),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.success,
//                           foregroundColor: AppColors.onSuccess,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: onView,
//                         icon: const Icon(
//                           Icons.remove_red_eye_outlined,
//                           size: 18,
//                         ),
//                         label: FittedBox(child: const Text('View Driver')),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.info,
//                           foregroundColor: AppColors.infoContainer,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color;
//     IconData icon;

//     switch (status.toLowerCase()) {
//       case 'pending':
//         color = AppColors.warning;
//         icon = Icons.schedule;
//         break;
//       case 'approved':
//         color = AppColors.success;
//         icon = Icons.check_circle;
//         break;
//       case 'rejected':
//         color = AppColors.error;
//         icon = Icons.cancel;
//         break;
//       default:
//         color = AppColors.textSecondary;
//         icon = Icons.help;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             status.capitalizeFirst ?? status,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'N/A';

//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays == 0) {
//       if (difference.inHours == 0) {
//         return '${difference.inMinutes}m ago';
//       }
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
// }
