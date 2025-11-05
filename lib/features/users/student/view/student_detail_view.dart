import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/loading_view.dart';
import '../controller/student_detail_controller.dart';
import '../model/student_details_response.dart';

// Note: Import your actual model classes and controller
// import 'package:your_app/models/student_details_response.dart';
// import 'package:your_app/controllers/student_details_controller.dart';

// =============================================================================
// STUDENT DETAILS VIEW
// =============================================================================

class StudentDetailsView extends GetView<StudentDetailsController> {
  const StudentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading) return const LoadingView(title: "Loading Student Details...",);
        if (controller.studentDetails == null) return _buildErrorState();

        return Column(
          children: [
            _buildStudentHeader(context),
            _buildTabBar(context),
            Expanded(child: _buildTabContent(context)),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildStudentHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
              const Spacer(),
              if (context.width > 768) _buildActionButtons(),
            ],
          ),
          const SizedBox(height: 16),
          context.width > 768 ? _buildDesktopProfile() : _buildMobileProfile(),
        ],
      ),
    );
  }

  Widget _buildDesktopProfile() {
    final student = controller.student;
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: student?.profilePicture != null ? NetworkImage(student!.profilePicture!) : null,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: student?.profilePicture == null
              ? Text(
                  (student?.studentName ?? 'N')[0].toUpperCase(),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
                )
              : null,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student?.studentName ?? 'Unknown Student',
                style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Student ID: ${student?.id} • Code: ${controller.uniqueCode?.uniqueCode ?? 'N/A'}',
                style: Get.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusChip(),
                  if (student?.email != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(student!.email!),
                  ],
                  if (student?.phoneNumber != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(student!.phoneNumber!),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (controller.creditBalance != null)
          _CreditBalanceCard(creditBalance: controller.creditBalance!),
      ],
    );
  }

  Widget _buildMobileProfile() {
    final student = controller.student;
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: student?.profilePicture != null ? NetworkImage(student!.profilePicture!) : null,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: student?.profilePicture == null
                  ? Text(
                      (student?.studentName ?? 'N')[0].toUpperCase(),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student?.studentName ?? 'Unknown Student',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ID: ${student?.id} • ${controller.uniqueCode?.uniqueCode ?? 'N/A'}',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(),
                ],
              ),
            ),
          ],
        ),
        if (student?.email != null || student?.phoneNumber != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                if (student?.email != null)
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(child: Text(student!.email!)),
                    ],
                  ),
                if (student?.email != null && student?.phoneNumber != null) const SizedBox(height: 8),
                if (student?.phoneNumber != null)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(student!.phoneNumber!),
                    ],
                  ),
              ],
            ),
          ),
        ],
        if (controller.creditBalance != null) ...[
          const SizedBox(height: 16),
          _CreditBalanceCard(creditBalance: controller.creditBalance!, isCompact: true),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: controller.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: controller.statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: controller.statusColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            controller.studentStatus,
            style: TextStyle(
              color: controller.statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: controller.contactStudent,
          icon: const Icon(Icons.phone, size: 16),
          label: const Text('Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: controller.sendNotification,
          icon: const Icon(Icons.notifications, size: 16),
          label: const Text('Notify'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: controller.editStudent,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: controller.suspendStudent,
          icon: const Icon(Icons.block, size: 16),
          label: const Text('Suspend'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: context.width > 768 ? _buildDesktopTabBar(context) : _buildMobileTabBar(),
    );
  }

  Widget _buildDesktopTabBar(BuildContext context) {
    return Obx(
      () => TabBar(
        controller: TabController(
          length: controller.tabTitles.length,
          vsync: Scaffold.of(context),
          initialIndex: controller.selectedTab,
        ),
        tabs:
            controller.tabTitles
                .map((title) => Tab(text: title, height: 48))
                .toList(),
        onTap: controller.setSelectedTab,
        isScrollable: true,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildMobileTabBar() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: controller.tabTitles.asMap().entries.map((entry) {
              final isSelected = controller.selectedTab == entry.key;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) controller.setSelectedTab(entry.key);
                  },
                  selectedColor: Colors.blue.withOpacity(0.2),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildTabContent(BuildContext context) {
    return Obx(() {
      switch (controller.selectedTab) {
        case 0:
          return _OverviewTab(controller: controller);
        case 1:
          return _TransactionsTab(controller: controller);
        case 2:
          return _CreditBalanceTab(controller: controller);
        case 3:
          return _ActivityTab(controller: controller);
        default:
          return _OverviewTab(controller: controller);
      }
    });
  }

  Widget _buildFloatingActions() {
    return Builder(builder:(context) =>  Get.width <= 768
        ? FloatingActionButton(
            onPressed: _showMobileActionsSheet,
            child: const Icon(Icons.more_vert),
          )
        : FloatingActionButton(
            onPressed: controller.refreshData,
            child: const Icon(Icons.refresh),
          ));
  }

  void _showMobileActionsSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Call Student'),
                onTap: () {
                  Get.back();
                  controller.contactStudent();
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.blue),
                title: const Text('Send Notification'),
                onTap: () {
                  Get.back();
                  controller.sendNotification();
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text('Record Payment'),
                onTap: () {
                  Get.back();
                  controller.recordPayment();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit Student'),
                onTap: () {
                  Get.back();
                  controller.editStudent();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Suspend Student'),
                onTap: () {
                  Get.back();
                  controller.suspendStudent();
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () {
                  Get.back();
                  controller.refreshData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load student details'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CREDIT BALANCE CARD WIDGET
// =============================================================================

class _CreditBalanceCard extends StatelessWidget {
  final StudentCreditBalance creditBalance;
  final bool isCompact;

  const _CreditBalanceCard({
    required this.creditBalance,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isCompact
            ? null
            : [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Credit Balance',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${creditBalance.credit ?? 0}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// OVERVIEW TAB
// =============================================================================

class _OverviewTab extends StatelessWidget {
  final StudentDetailsController controller;

  const _OverviewTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
      child: context.width > 1024
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildDriverInfoCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildQuickStatsCard(),
                      const SizedBox(height: 16),
                      _buildPaymentSummaryCard(),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _buildQuickStatsCard(),
                const SizedBox(height: 16),
                _buildPersonalInfoCard(),
                const SizedBox(height: 16),
                _buildDriverInfoCard(),
                const SizedBox(height: 16),
                _buildPaymentSummaryCard(),
              ],
            ),
    );
  }

  Widget _buildPersonalInfoCard() {
    final student = controller.student;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, 'Full Name', student?.studentName ?? 'N/A'),
            _buildInfoRow(Icons.email, 'Email', student?.email ?? 'N/A'),
            _buildInfoRow(Icons.phone, 'Phone', student?.phoneNumber ?? 'N/A'),
            _buildInfoRow(Icons.location_on, 'Address', student?.address ?? 'N/A'),
            _buildInfoRow(Icons.badge, 'Unique Code', controller.uniqueCode?.uniqueCode ?? 'N/A'),
            _buildInfoRow(Icons.currency_rupee, 'Proposed Fee', '₹${student?.proposedFee ?? 0}'),
            _buildInfoRow(Icons.calendar_today, 'Joined', _formatDate(student?.createdAt)),
            _buildInfoRow(Icons.update, 'Last Updated', _formatDate(student?.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    final driver = controller.driver;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Assigned Driver',
                  style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (driver != null)
                  TextButton.icon(
                    onPressed: controller.viewDriverDetails,
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (driver != null) ...[
              _buildInfoRow(Icons.person, 'Driver Name', driver.driverName ?? 'N/A'),
              _buildInfoRow(Icons.email, 'Email', driver.email ?? 'N/A'),
              _buildInfoRow(Icons.phone, 'Phone', driver.phoneNumber ?? 'N/A'),
              _buildInfoRow(Icons.check_circle, 'Bank Details',
                  driver.hasBankDetails == true ? 'Yes' : 'No'),
              _buildInfoRow(Icons.lock, 'MPIN Set', driver.mpinSet == true ? 'Yes' : 'No'),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No driver assigned yet',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Statistics',
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatItem('Total Paid', '₹${controller.totalPaid}', Icons.check_circle, Colors.green),
            _buildStatItem('Total Pending', '₹${controller.totalPending}', Icons.schedule, Colors.orange),
            _buildStatItem('Completed', '${controller.completedTransactions}', Icons.done_all, Colors.blue),
            _buildStatItem('Pending', '${controller.pendingTransactions}', Icons.pending, Colors.orange),
            _buildStatItem('Failed', '${controller.failedTransactions}', Icons.error, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentRow('Proposed Fee', controller.student?.proposedFee ?? 0, Colors.blue),
            _buildPaymentRow('Credit Balance', controller.creditBalance?.credit ?? 0, Colors.green),
            const Divider(height: 24),
            _buildPaymentRow(
              'Due Amount',
              controller.dueAmount,
              controller.dueAmount > 0 ? Colors.red : Colors.green,
              isBold: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.recordPayment,
                icon: const Icon(Icons.payment),
                label: const Text('Record Payment'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.sendPaymentReminder,
                icon: const Icon(Icons.notification_important),
                label: const Text('Send Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, int amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            '₹$amount',
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// =============================================================================
// TRANSACTIONS TAB
// =============================================================================

class _TransactionsTab extends StatelessWidget {
  final StudentDetailsController controller;

  const _TransactionsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: Obx(() {
            final transactions = controller.filteredTransactions;
            if (transactions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No transactions found'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) => _TransactionCard(transaction: transactions[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Created', 'Created'),
                const SizedBox(width: 8),
                _buildFilterChip('Success', 'Success'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'Pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Failed', 'Failed'),
              ],
            ),
          )),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.transactionFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.setTransactionFilter(value);
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
    );
  }
}

// =============================================================================
// TRANSACTION CARD WIDGET
// =============================================================================

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getStatusIcon(), color: _getStatusColor(), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${transaction.amount ?? 0}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDateTime(transaction.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Transaction ID', '#${transaction.id}'),
            _buildDetailRow('Reference', transaction.transactionRef ?? 'N/A'),
            _buildDetailRow('Mode', _capitalizeFirst(transaction.transactionMode ?? 'N/A')),
            if (transaction.driverId != null)
              _buildDetailRow('Driver ID', '${transaction.driverId}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Text(
        _capitalizeFirst(transaction.status ?? 'Unknown'),
        style: TextStyle(
          color: _getStatusColor(),
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (transaction.status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (transaction.status?.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// =============================================================================
// CREDIT BALANCE TAB
// =============================================================================

class _CreditBalanceTab extends StatelessWidget {
  final StudentDetailsController controller;

  const _CreditBalanceTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final creditBalance = controller.creditBalance;
    final student = controller.student;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
      child: Column(
        children: [
          // Large Balance Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Current Credit Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  '₹${creditBalance?.credit ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last updated: ${_formatDateTime(creditBalance?.updatedAt)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Balance Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance Information',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBalanceRow('Proposed Monthly Fee', student?.proposedFee ?? 0, Colors.blue),
                  _buildBalanceRow('Current Credit', creditBalance?.credit ?? 0, Colors.green),
                  const Divider(height: 24),
                  _buildBalanceRow(
                    'Amount Due',
                    controller.dueAmount,
                    controller.dueAmount > 0 ? Colors.red : Colors.green,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Payment Options Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Options',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.recordPayment,
                      icon: const Icon(Icons.payment),
                      label: const Text('Record New Payment'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: controller.sendPaymentReminder,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Send Payment Reminder'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, int amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            '₹$amount',
            style: TextStyle(
              fontSize: isBold ? 20 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// =============================================================================
// ACTIVITY TAB
// =============================================================================

class _ActivityTab extends StatelessWidget {
  final StudentDetailsController controller;

  const _ActivityTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final student = controller.student;
    final fcmToken = controller.fcmToken;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.width > 768 ? 24 : 16),
      child: Column(
        children: [
          // Account Timeline Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Timeline',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineItem(
                    'Account Created',
                    student?.createdAt,
                    Icons.person_add,
                    Colors.blue,
                  ),
                  _buildTimelineItem(
                    'Profile Updated',
                    student?.updatedAt,
                    Icons.edit,
                    Colors.orange,
                  ),
                  if (fcmToken?.lastUsedAt != null)
                    _buildTimelineItem(
                      'Last Active',
                      fcmToken?.lastUsedAt,
                      Icons.access_time,
                      Colors.green,
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Device & Platform Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device & Platform Info',
                    style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (fcmToken != null) ...[
                    _buildDeviceInfoRow('Platform', fcmToken.platform?.toUpperCase() ?? 'Unknown'),
                    _buildDeviceInfoRow(
                      'Device Status',
                      fcmToken.isActive == true ? 'Active' : 'Inactive',
                    ),
                    _buildDeviceInfoRow('Last Used', _formatDateTime(fcmToken.lastUsedAt)),
                    _buildDeviceInfoRow('Token Created', _formatDateTime(fcmToken.createdAt)),
                  ] else
                    const Center(
                      child: Text(
                        'No device information available',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime? date, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

