// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// import '../../../../core/routes/app_routes.dart';
// import '../../../../shared/widgets/loading_view.dart';
// import '../../../../core/dependencies/injection_container.dart';
// import '../bloc/transactions_list_bloc.dart';
// import '../bloc/transactions_list_event.dart';
// import '../bloc/transactions_list_state.dart';
// import '../model/transactions_list_model.dart';

// class TransactionsListView extends StatelessWidget {
//   const TransactionsListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: sl<TransactionsListBloc>(),
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         body: BlocBuilder<TransactionsListBloc, TransactionsListState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 _buildHeader(context, state),
//                 _buildFilterAndSearch(context, state),
//                 Expanded(
//                   child: () {
//                     if (state.isLoading) {
//                       return const LoadingView(
//                         title: "Loading Transactions...",
//                       );
//                     }
//                     if (state.filteredTransactions.isEmpty) {
//                       return _buildEmptyState(context);
//                     }
//                     return _buildTransactionsList(context, state);
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
//                     () => context.read<TransactionsListBloc>().add(
//                       TransactionsListRefreshed(),
//                     ),
//                 tooltip: 'Refresh',
//                 child: const Icon(Icons.refresh),
//               ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, TransactionsListState state) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.all(width > 768 ? 24 : 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Transactions',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${state.filteredTransactions.length} transactions found',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           if (width > 768) _buildQuickStats(state),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats(TransactionsListState state) {
//     final stats = state.transactionStats;
//     return Row(
//       children: [
//         _buildStatChip('Total', stats['total'], Colors.blue),
//         const SizedBox(width: 8),
//         _buildStatChip('Success', stats['Success'], Colors.green),
//         const SizedBox(width: 8),
//         _buildStatChip('Pending', stats['Pending'], Colors.orange),
//         const SizedBox(width: 8),
//         _buildStatChip('Failed', stats['Failed'], Colors.red),
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
//     TransactionsListState state,
//   ) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: width > 768 ? 24 : 16,
//         vertical: 16,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
//       ),
//       child:
//           width > 768
//               ? _buildDesktopFilterBar(context, state)
//               : _buildMobileFilterBar(context, state),
//     );
//   }

//   Widget _buildDesktopFilterBar(
//     BuildContext context,
//     TransactionsListState state,
//   ) {
//     return Row(
//       children: [
//         // Search bar
//         Expanded(
//           flex: 2,
//           child: TextField(
//             onChanged:
//                 (val) => context.read<TransactionsListBloc>().add(
//                   TransactionsListSearchQueryChanged(val),
//                 ),
//             decoration: InputDecoration(
//               hintText: 'Search by ID, student name, or status...',
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: Colors.grey[100],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),

//         // Filter dropdown
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: state.selectedFilter,
//               hint: const Text('Filter'),
//               items: const [
//                 DropdownMenuItem(value: 'all', child: Text('All Transactions')),
//                 DropdownMenuItem(value: 'Success', child: Text('Success')),
//                 DropdownMenuItem(value: 'Pending', child: Text('Pending')),
//                 DropdownMenuItem(value: 'Created', child: Text('Created')),
//                 DropdownMenuItem(value: 'Failed', child: Text('Failed')),
//                 DropdownMenuItem(value: 'online', child: Text('Online')),
//                 DropdownMenuItem(value: 'cash', child: Text('Cash')),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   context.read<TransactionsListBloc>().add(
//                     TransactionsListFilterChanged(value),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),

//         const SizedBox(width: 16),

//         // Sort dropdown
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: state.sortBy,
//               hint: const Text('Sort'),
//               items: const [
//                 DropdownMenuItem(value: 'date', child: Text('Date')),
//                 DropdownMenuItem(value: 'amount', child: Text('Amount')),
//                 DropdownMenuItem(value: 'student', child: Text('Student')),
//                 DropdownMenuItem(value: 'status', child: Text('Status')),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   context.read<TransactionsListBloc>().add(
//                     TransactionsListSortChanged(value),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),

//         const SizedBox(width: 8),

//         // Sort direction
//         IconButton(
//           onPressed:
//               () => context.read<TransactionsListBloc>().add(
//                 TransactionsListSortChanged(state.sortBy),
//               ),
//           icon: Icon(
//             state.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
//           ),
//           tooltip: state.sortAscending ? 'Ascending' : 'Descending',
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileFilterBar(
//     BuildContext context,
//     TransactionsListState state,
//   ) {
//     final bloc = context.read<TransactionsListBloc>();
//     return Column(
//       children: [
//         // Search bar
//         TextField(
//           onChanged: (val) => bloc.add(TransactionsListSearchQueryChanged(val)),
//           decoration: InputDecoration(
//             hintText: 'Search transactions...',
//             prefixIcon: const Icon(Icons.search),
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Filter and Sort chips
//         Row(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children:
//                       bloc.filterOptions.map((filter) {
//                         final isSelected = state.selectedFilter == filter;
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: FilterChip(
//                             label: Text(_getFilterDisplayName(filter)),
//                             selected: isSelected,
//                             onSelected: (selected) {
//                               if (selected)
//                                 bloc.add(TransactionsListFilterChanged(filter));
//                             },
//                             selectedColor: Colors.blue.withOpacity(0.2),
//                             checkmarkColor: Colors.blue,
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),

//             // Sort button
//             PopupMenuButton<String>(
//               onSelected: (val) => bloc.add(TransactionsListSortChanged(val)),
//               icon: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.sort),
//                   Icon(
//                     state.sortAscending
//                         ? Icons.arrow_upward
//                         : Icons.arrow_downward,
//                     size: 16,
//                   ),
//                 ],
//               ),
//               itemBuilder:
//                   (context) => const [
//                     PopupMenuItem(value: 'date', child: Text('Sort by Date')),
//                     PopupMenuItem(
//                       value: 'amount',
//                       child: Text('Sort by Amount'),
//                     ),
//                     PopupMenuItem(
//                       value: 'student',
//                       child: Text('Sort by Student'),
//                     ),
//                     PopupMenuItem(
//                       value: 'status',
//                       child: Text('Sort by Status'),
//                     ),
//                   ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   String _getFilterDisplayName(String filter) {
//     switch (filter) {
//       case 'all':
//         return 'All';
//       case 'Success':
//         return 'Success';
//       case 'Pending':
//         return 'Pending';
//       case 'Created':
//         return 'Created';
//       case 'Failed':
//         return 'Failed';
//       case 'online':
//         return 'Online';
//       case 'cash':
//         return 'Cash';
//       default:
//         return filter.capitalizeFirst ?? filter;
//     }
//   }

//   Widget _buildTransactionsList(
//     BuildContext context,
//     TransactionsListState state,
//   ) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<TransactionsListBloc>().add(TransactionsListRefreshed());
//       },
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 1200) {
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

//   Widget _buildDesktopTable(BuildContext context, TransactionsListState state) {
//     return SingleChildScrollView(
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: DataTable(
//           columnSpacing: 24,
//           horizontalMargin: 24,
//           headingRowHeight: 56,
//           dataRowMinHeight: 72,
//           dataRowMaxHeight: 72,
//           columns: const [
//             DataColumn(
//               label: Text(
//                 'Transaction',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Student',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Amount',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Status',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Mode',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Date',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             DataColumn(
//               label: Text(
//                 'Actions',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//           rows:
//               state.filteredTransactions.map((transaction) {
//                 return DataRow(
//                   cells: [
//                     DataCell(
//                       Text(
//                         '#${transaction.id}',
//                         style: const TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     DataCell(
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             transaction.studentName ?? 'Unknown',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             'ID: ${transaction.studentId}',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     DataCell(
//                       Text(
//                         '₹${transaction.amount ?? 0}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     DataCell(_buildStatusChip(transaction.status ?? '')),
//                     DataCell(_buildModeChip(transaction.transactionMode ?? '')),
//                     DataCell(Text(_formatDate(transaction.updatedAt))),
//                     DataCell(
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             onPressed:
//                                 () => _viewTransactionDetails(
//                                   context,
//                                   transaction,
//                                 ),
//                             icon: const Icon(Icons.visibility, size: 20),
//                             tooltip: 'View Details',
//                           ),
//                           IconButton(
//                             onPressed:
//                                 () => _viewStudentDetails(context, transaction),
//                             icon: const Icon(Icons.person, size: 20),
//                             tooltip: 'View Student',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabletGrid(BuildContext context, TransactionsListState state) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 1.3,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: state.filteredTransactions.length,
//       itemBuilder: (context, index) {
//         final transaction = state.filteredTransactions[index];
//         return _TransactionCard(
//           transaction: transaction,
//           onTapTransaction: () => _viewTransactionDetails(context, transaction),
//           onTapStudent: () => _viewStudentDetails(context, transaction),
//         );
//       },
//     );
//   }

//   Widget _buildMobileList(BuildContext context, TransactionsListState state) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: state.filteredTransactions.length,
//       itemBuilder: (context, index) {
//         final transaction = state.filteredTransactions[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _TransactionCard(
//             transaction: transaction,
//             onTapTransaction:
//                 () => _viewTransactionDetails(context, transaction),
//             onTapStudent: () => _viewStudentDetails(context, transaction),
//             isMobile: true,
//           ),
//         );
//       },
//     );
//   }

//   void _viewTransactionDetails(BuildContext context, Transaction transaction) {
//     Get.toNamed(AppRoutes.transactionDetails, arguments: transaction);
//   }

//   void _viewStudentDetails(BuildContext context, Transaction transaction) {
//     Get.toNamed(
//       AppRoutes.studentDetails,
//       arguments: {'id': transaction.studentId},
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color;
//     IconData icon;

//     switch (status.toLowerCase()) {
//       case 'success':
//         color = Colors.green;
//         icon = Icons.check_circle;
//         break;
//       case 'pending':
//         color = Colors.orange;
//         icon = Icons.schedule;
//         break;
//       case 'created':
//         color = Colors.blue;
//         icon = Icons.fiber_new;
//         break;
//       case 'failed':
//         color = Colors.red;
//         icon = Icons.cancel;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.help;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
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

//   Widget _buildModeChip(String mode) {
//     Color color = mode.toLowerCase() == 'online' ? Colors.blue : Colors.green;
//     IconData icon =
//         mode.toLowerCase() == 'online' ? Icons.language : Icons.money;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             mode.capitalizeFirst ?? mode,
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

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No transactions found',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try adjusting your search or filter criteria',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () {
//               context.read<TransactionsListBloc>().add(
//                 const TransactionsListSearchQueryChanged(''),
//               );
//               context.read<TransactionsListBloc>().add(
//                 const TransactionsListFilterChanged('all'),
//               );
//             },
//             icon: const Icon(Icons.clear_all),
//             label: const Text('Clear Filters'),
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
// // TRANSACTION CARD COMPONENT
// // =============================================================================

// class _TransactionCard extends StatelessWidget {
//   final Transaction transaction;
//   final VoidCallback onTapTransaction;
//   final VoidCallback onTapStudent;
//   final bool isMobile;

//   const _TransactionCard({
//     required this.transaction,
//     required this.onTapTransaction,
//     required this.onTapStudent,
//     this.isMobile = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTapTransaction,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor().withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       _getStatusIcon(),
//                       color: _getStatusColor(),
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Transaction #${transaction.id}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           _formatDate(transaction.updatedAt),
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   _buildStatusChip(transaction.status ?? ''),
//                 ],
//               ),

//               const SizedBox(height: 12),
//               const Divider(),
//               const SizedBox(height: 12),

//               // Amount
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green.withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.currency_rupee,
//                       color: Colors.green,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${transaction.amount ?? 0}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                     const Spacer(),
//                     _buildModeChip(transaction.transactionMode ?? ''),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Student Info
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.blue.withOpacity(0.2),
//                       child: Text(
//                         (transaction.studentName ?? 'U')
//                             .substring(0, 1)
//                             .toUpperCase(),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             transaction.studentName ?? 'Unknown',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             'Student ID: ${transaction.studentId}',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: onTapStudent,
//                       icon: const Icon(Icons.arrow_forward_ios, size: 16),
//                       tooltip: 'View Student',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor() {
//     switch ((transaction.status ?? '').toLowerCase()) {
//       case 'success':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'created':
//         return Colors.blue;
//       case 'failed':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon() {
//     switch ((transaction.status ?? '').toLowerCase()) {
//       case 'success':
//         return Icons.check_circle;
//       case 'pending':
//         return Icons.schedule;
//       case 'created':
//         return Icons.fiber_new;
//       case 'failed':
//         return Icons.cancel;
//       default:
//         return Icons.help;
//     }
//   }

//   Widget _buildStatusChip(String status) {
//     Color color = _getStatusColor();
//     IconData icon = _getStatusIcon();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
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

//   Widget _buildModeChip(String mode) {
//     Color color = mode.toLowerCase() == 'online' ? Colors.blue : Colors.green;
//     IconData icon =
//         mode.toLowerCase() == 'online' ? Icons.language : Icons.money;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             mode.capitalizeFirst ?? mode,
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
