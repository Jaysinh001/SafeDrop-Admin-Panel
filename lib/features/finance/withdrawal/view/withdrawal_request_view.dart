import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../controller/withdrawal_request_controller.dart';
import '../model/withdrawal_request_response.dart';

// =============================================================================
// WITHDRAWAL REQUESTS VIEW
// =============================================================================

class WithdrawalRequestsView extends GetView<WithdrawalRequestsController> {
  const WithdrawalRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterAndSearch(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const LoadingView(
                  title: "Loading withdrawal requests...",
                );
              }

              if (controller.filteredRequests.isEmpty) {
                return _buildEmptyState();
              }

              return _buildRequestsList(context);
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.refreshData,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Withdrawal Requests',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${controller.filteredRequests.length} requests found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (context.width > 768) _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Obx(() {
      final pending =
          controller.withdrawalRequests
              .where((r) => r.status == 'pending')
              .length;
      final approved =
          controller.withdrawalRequests
              .where((r) => r.status == 'approved')
              .length;
      final rejected =
          controller.withdrawalRequests
              .where((r) => r.status == 'rejected')
              .length;

      return Row(
        children: [
          _buildStatChip('Pending', pending, AppColors.warning),
          const SizedBox(width: 8),
          _buildStatChip('Approved', approved, AppColors.success),
          const SizedBox(width: 8),
          _buildStatChip('Rejected', rejected, AppColors.error),
        ],
      );
    });
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSearch(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width > 768 ? 24 : 16,
        vertical: 12,
      ),
      child:
          context.width > 768
              ? _buildDesktopFilterBar()
              : _buildMobileFilterBar(),
    );
  }

  Widget _buildDesktopFilterBar() {
    return Row(
      children: [
        // Search bar
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search by ID, Driver ID, or note...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Filter dropdown
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedFilter,
                items:
                    controller.filterOptions
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter.capitalizeFirst!),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) controller.setFilter(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFilterBar() {
    return Column(
      children: [
        // Search bar
        TextField(
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search requests...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Filter chips
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  controller.filterOptions.map((filter) {
                    final isSelected = controller.selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter.capitalizeFirst!),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) controller.setFilter(filter);
                        },
                        selectedColor: AppColors.primaryContainer,
                        checkmarkColor: AppColors.primary,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1024) {
            return _buildDesktopTable();
          } else if (constraints.maxWidth > 768) {
            return _buildTabletGrid();
          } else {
            return _buildMobileList();
          }
        },
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 24,
            columns: const [
              DataColumn(label: Text('Request ID')),
              DataColumn(label: Text('Driver ID')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Actions')),
            ],
            rows:
                controller.filteredRequests.map((request) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${request.id}')),
                      DataCell(Text('${request.driverId}')),
                      DataCell(Text('₹${request.amount}')),
                      DataCell(_buildStatusChip(request.status ?? '')),
                      DataCell(Text(_formatDate(request.createdAt))),
                      DataCell(_buildActionButtons(request)),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletGrid() {
    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.filteredRequests.length,
        itemBuilder: (context, index) {
          final request = controller.filteredRequests[index];
          return _WithdrawalRequestCard(
            request: request,
            onApprove: () => controller.approveRequest(request),
            onReject: () => controller.showRejectionDialog(request),
            onView: () => controller.openDriverDetails(request.driverId ?? 0),
            isProcessing: controller.processingIds.contains(request.id),
          );
        },
      ),
    );
  }

  Widget _buildMobileList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredRequests.length,
        itemBuilder: (context, index) {
          final request = controller.filteredRequests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _WithdrawalRequestCard(
              request: request,
              onApprove: () => controller.approveRequest(request),
              onReject: () => controller.showRejectionDialog(request),
              onView: () => controller.openDriverDetails(request.driverId ?? 0),
              isProcessing: controller.processingIds.contains(request.id),
              isMobile: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        icon = Icons.schedule;
        break;
      case 'approved':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = AppColors.error;
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.capitalizeFirst!,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Request request) {
    if (request.status?.toLowerCase() != 'pending') {
      return Text(
        'No actions available',
        style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
      );
    }

    final isProcessing = controller.processingIds.contains(request.id);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isProcessing) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ] else ...[
          IconButton(
            onPressed: () => controller.approveRequest(request),
            icon: const Icon(Icons.check, color: AppColors.success),
            tooltip: 'Approve',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => controller.showRejectionDialog(request),
            icon: const Icon(Icons.close, color: AppColors.error),
            tooltip: 'Reject',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed:
                () => controller.openDriverDetails(request.driverId ?? 0),
            icon: const Icon(
              Icons.remove_red_eye_outlined,
              color: AppColors.info,
            ),
            tooltip: 'View Driver',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No withdrawal requests found',
            style: Get.textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Withdrawal requests will appear here when available',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// =============================================================================
// WITHDRAWAL REQUEST CARD COMPONENT
// =============================================================================

class _WithdrawalRequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onView;
  final bool isProcessing;
  final bool isMobile;

  const _WithdrawalRequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onView,
    required this.isProcessing,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request #${request.id}',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Driver ID: ${request.driverId}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(request.status ?? ''),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.monetization_on, size: 20, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  '₹${request.amount}',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            if (request.note != null && request.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${request.note}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(request.createdAt),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),

            if (request.status?.toLowerCase() == 'pending') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              if (isProcessing) ...[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Processing...',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: FittedBox(child: const Text('Reject')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onApprove,
                        icon: const Icon(Icons.check, size: 18),
                        label: FittedBox(child: const Text('Approve')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: AppColors.onSuccess,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onView,
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                        ),
                        label: FittedBox(child: const Text('View Driver')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          foregroundColor: AppColors.infoContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        icon = Icons.schedule;
        break;
      case 'approved':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = AppColors.error;
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.capitalizeFirst!,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// =============================================================================
// USAGE EXAMPLE - How to integrate with your route system
// =============================================================================

/*
// In your app_routes.dart
abstract class AppRoutes {
  static const withdrawalRequests = '/admin/withdrawal-requests';
}

// In your route.dart
GetPage(
  name: AppRoutes.withdrawalRequests,
  page: () => AdminPanelLayout(
    child: const WithdrawalRequestsView(),
  ),
  binding: WithdrawalRequestsBinding(),
  transition: Transition.rightToLeft,
),

// Navigation from anywhere in your app:
Get.toNamed(AppRoutes.withdrawalRequests);

// Or add to your admin navigation items:
NavigationItem(
  id: 6,
  title: 'Withdrawals',
  icon: Icons.account_balance_wallet,
  route: AppRoutes.withdrawalRequests,
  breadcrumbs: ['Home', 'Admin', 'Withdrawals'],
  badge: '5', // Show pending count
),
*/
