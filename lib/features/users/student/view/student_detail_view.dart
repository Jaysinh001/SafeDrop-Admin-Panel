import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/loading_view.dart';
import '../../../../core/dependencies/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/student_details_bloc/student_detail_bloc.dart';
import '../bloc/student_details_bloc/student_detail_event.dart';
import '../bloc/student_details_bloc/student_detail_state.dart';
import '../model/student_details_response.dart';
import '../model/students_list_response.dart' as slr;

// =============================================================================
// STUDENT DETAILS VIEW
// =============================================================================

class StudentDetailsView extends StatelessWidget {
  final Object? arguments;
  const StudentDetailsView({super.key, this.arguments});

  static const List<String> tabTitles = [
    'Overview',
    'Transactions',
    'Fees History',
    'Credit Balance',
    'Activity',
  ];

  int _getStudentId() {
    // if (arguments is slr.Student) {
    //   return (arguments as slr.Student).studentId ?? 0;
    // } else if (arguments is Map && (arguments as Map)['id'] != null) {
    //   return (arguments as Map)['id'];
    // }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<StudentDetailBloc>()
                ..add(StudentDetailLoaded(_getStudentId())),
      child: BlocBuilder<StudentDetailBloc, StudentDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: _buildBody(context, state),
            floatingActionButton: _buildFloatingActions(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, StudentDetailState state) {
    if (state.status == StudentDetailStatus.loading) {
      return const LoadingView(title: "Loading Student Details...");
    }
    if (state.studentDetails == null) return _buildErrorState(context);

    return Column(
      children: [
        _buildStudentHeader(context, state),
        _buildTabBar(context, state),
        Expanded(child: _buildTabContent(context, state)),
      ],
    );
  }

  Widget _buildStudentHeader(BuildContext context, StudentDetailState state) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              if (width > 768) _buildActionButtons(context, state),
            ],
          ),
          const SizedBox(height: 16),
          width > 768
              ? _buildDesktopProfile(context, state)
              : _buildMobileProfile(context, state),
        ],
      ),
    );
  }

  Widget _buildDesktopProfile(BuildContext context, StudentDetailState state) {
    final student = state.studentDetails?.student;
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              student?.profilePicture != null
                  ? NetworkImage(student!.profilePicture!)
                  : null,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child:
              student?.profilePicture == null
                  ? Text(
                    (student?.studentName ?? 'N')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
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
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Student ID: ${student?.id} • Code: ${state.studentDetails?.uniqueCode?.uniqueCode ?? 'N/A'}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusChip(state),
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
        if (state.studentDetails?.studentCreditBalance != null)
          _CreditBalanceCard(
            creditBalance: state.studentDetails!.studentCreditBalance!,
          ),
      ],
    );
  }

  Widget _buildMobileProfile(BuildContext context, StudentDetailState state) {
    final student = state.studentDetails?.student;
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  student?.profilePicture != null
                      ? NetworkImage(student!.profilePicture!)
                      : null,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child:
                  student?.profilePicture == null
                      ? Text(
                        (student?.studentName ?? 'N')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${student?.id} • ${state.studentDetails?.uniqueCode?.uniqueCode ?? 'N/A'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(state),
                ],
              ),
            ),
          ],
        ),
        if (student?.email != null || student?.phoneNumber != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
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
                if (student?.email != null && student?.phoneNumber != null)
                  const SizedBox(height: 8),
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
        if (state.studentDetails?.studentCreditBalance != null) ...[
          const SizedBox(height: 16),
          _CreditBalanceCard(
            creditBalance: state.studentDetails!.studentCreditBalance!,
            isCompact: true,
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip(StudentDetailState state) {
    final statusColor = _getStatusColor(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _getStudentStatus(state),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(StudentDetailState state) {
    final student = state.studentDetails?.student;
    final driver = state.studentDetails?.driver;
    if (student?.accountActive == true && driver != null) {
      return Colors.green;
    } else if (student?.accountActive == true) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getStudentStatus(StudentDetailState state) {
    final student = state.studentDetails?.student;
    final driver = state.studentDetails?.driver;
    if (student?.accountActive == true && driver != null) {
      return 'Active';
    } else if (student?.accountActive == true) {
      return 'Active (No Driver)';
    } else {
      return 'Inactive';
    }
  }

  Widget _buildActionButtons(BuildContext context, StudentDetailState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => _contactStudent(context, state),
          icon: const Icon(Icons.phone, size: 16),
          label: const Text('Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _sendNotification(context, state),
          icon: const Icon(Icons.notifications, size: 16),
          label: const Text('Notify'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _editStudent(context),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _suspendStudent(context),
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

  Widget _buildTabBar(BuildContext context, StudentDetailState state) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child:
          width > 768
              ? _buildDesktopTabBar(context, state)
              : _buildMobileTabBar(context, state),
    );
  }

  Widget _buildDesktopTabBar(BuildContext context, StudentDetailState state) {
    return TabBar(
      controller: TabController(
        length: tabTitles.length,
        vsync: Scaffold.of(context),
        initialIndex: state.selectedTab,
      ),
      tabs: tabTitles.map((title) => Tab(text: title, height: 48)).toList(),
      onTap:
          (index) => context.read<StudentDetailBloc>().add(
            StudentDetailTabChanged(index),
          ),
      isScrollable: true,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Colors.blue,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _buildMobileTabBar(BuildContext context, StudentDetailState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            tabTitles.asMap().entries.map((entry) {
              final isSelected = state.selectedTab == entry.key;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<StudentDetailBloc>().add(
                        StudentDetailTabChanged(entry.key),
                      );
                    }
                  },
                  selectedColor: Colors.blue.withOpacity(0.2),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, StudentDetailState state) {
    switch (state.selectedTab) {
      case 0:
        return _OverviewTab(context: context, state: state);
      case 1:
        return _TransactionsTab(context: context, state: state);
      case 2:
        return _DuePaymentsTab(context: context, state: state);
      case 3:
        return _CreditBalanceTab(context: context, state: state);
      case 4:
        return _ActivityTab(context: context, state: state);
      default:
        return _OverviewTab(context: context, state: state);
    }
  }

  Widget _buildFloatingActions(BuildContext context, StudentDetailState state) {
    final width = MediaQuery.of(context).size.width;
    return width <= 768
        ? FloatingActionButton(
          onPressed: () => _showMobileActionsSheet(context, state),
          child: const Icon(Icons.more_vert),
        )
        : FloatingActionButton(
          onPressed:
              () => context.read<StudentDetailBloc>().add(
                StudentDetailRefreshRequested(),
              ),
          child: const Icon(Icons.refresh),
        );
  }

  void _showMobileActionsSheet(BuildContext context, StudentDetailState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Call Student'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _contactStudent(context, state);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.blue),
                title: const Text('Send Notification'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _sendNotification(context, state);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text('Record Payment'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _recordPayment(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit Student'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _editStudent(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Suspend Student'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _suspendStudent(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.read<StudentDetailBloc>().add(
                    StudentDetailRefreshRequested(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load student details'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                () => context.read<StudentDetailBloc>().add(
                  StudentDetailRefreshRequested(),
                ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// UI HELPERS (TOP-LEVEL)
// =============================================================================

void _contactStudent(BuildContext context, StudentDetailState state) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Calling ${state.studentDetails?.student?.phoneNumber ?? 'student'}...',
      ),
    ),
  );
}

void _sendNotification(BuildContext context, StudentDetailState state) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Notification sent to student')));
}

void _editStudent(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Edit functionality coming soon!')),
  );
}

void _suspendStudent(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Suspend Student'),
        content: const Text(
          'Are you sure you want to suspend this student account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student account suspended')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Suspend'),
          ),
        ],
      );
    },
  );
}

void _recordPayment(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Payment recording functionality coming soon!'),
    ),
  );
}

void _sendPaymentReminder(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Payment reminder sent to student')),
  );
}

String _formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return '${date.day}/${date.month}/${date.year}';
}

String _formatDateTime(DateTime? date) {
  if (date == null) return 'N/A';
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
        boxShadow:
            isCompact
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
  final BuildContext context;
  final StudentDetailState state;

  const _OverviewTab({required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
      child:
          width > 1024
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
    final student = state.studentDetails?.student;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.person,
              'Full Name',
              student?.studentName ?? 'N/A',
            ),
            _buildInfoRow(Icons.email, 'Email', student?.email ?? 'N/A'),
            _buildInfoRow(Icons.phone, 'Phone', student?.phoneNumber ?? 'N/A'),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              student?.address ?? 'N/A',
            ),
            _buildInfoRow(
              Icons.badge,
              'Unique Code',
              state.studentDetails?.uniqueCode?.uniqueCode ?? 'N/A',
            ),
            _buildInfoRow(
              Icons.currency_rupee,
              'Proposed Fee',
              '₹${student?.proposedFee ?? 0}',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              'Joined',
              _formatDate(student?.createdAt),
            ),
            _buildInfoRow(
              Icons.update,
              'Last Updated',
              _formatDate(student?.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    final driver = state.studentDetails?.driver;
    final theme = Theme.of(context);
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (driver != null)
                  TextButton.icon(
                    onPressed: () => _viewDriverDetails(context, state),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (driver != null) ...[
              _buildInfoRow(
                Icons.person,
                'Driver Name',
                driver.driverName ?? 'N/A',
              ),
              _buildInfoRow(Icons.email, 'Email', driver.email ?? 'N/A'),
              _buildInfoRow(Icons.phone, 'Phone', driver.phoneNumber ?? 'N/A'),
              _buildInfoRow(
                Icons.check_circle,
                'Bank Details',
                driver.hasBankDetails == true ? 'Yes' : 'No',
              ),
              _buildInfoRow(
                Icons.lock,
                'MPIN Set',
                driver.mpinSet == true ? 'Yes' : 'No',
              ),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No driver assigned yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _viewDriverDetails(BuildContext context, StudentDetailState state) {
    if (state.studentDetails?.driver != null) {
      context.pushNamed(
        AppRoutes.driverDetails,
        extra: {"id": state.studentDetails!.driver!.id},
      );
    }
  }

  Widget _buildQuickStatsCard() {
    final theme = Theme.of(context);
    final transactions = state.studentDetails?.transactions ?? [];

    final totalPaid = transactions
        .where((t) => t.status?.toLowerCase() == 'completed')
        .fold(0, (sum, t) => sum + (t.amount ?? 0));

    final totalPending = transactions
        .where((t) => t.status?.toLowerCase() == 'pending')
        .fold(0, (sum, t) => sum + (t.amount ?? 0));

    final completedCount =
        transactions
            .where((t) => t.status?.toLowerCase() == 'completed')
            .length;

    final pendingCount =
        transactions.where((t) => t.status?.toLowerCase() == 'pending').length;

    final failedCount =
        transactions.where((t) => t.status?.toLowerCase() == 'failed').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Statistics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              'Total Paid',
              '₹$totalPaid',
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatItem(
              'Total Pending',
              '₹$totalPending',
              Icons.schedule,
              Colors.orange,
            ),
            _buildStatItem(
              'Completed',
              '$completedCount',
              Icons.done_all,
              Colors.blue,
            ),
            _buildStatItem(
              'Pending',
              '$pendingCount',
              Icons.pending,
              Colors.orange,
            ),
            _buildStatItem('Failed', '$failedCount', Icons.error, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    final theme = Theme.of(context);
    final student = state.studentDetails?.student;
    final creditBalance =
        state.studentDetails?.studentCreditBalance?.credit ?? 0;
    final proposedFee = student?.proposedFee ?? 0;
    final dueAmount = proposedFee - creditBalance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentRow('Proposed Fee', proposedFee, Colors.blue),
            _buildPaymentRow('Credit Balance', creditBalance, Colors.green),
            const Divider(height: 24),
            _buildPaymentRow(
              'Due Amount',
              dueAmount,
              dueAmount > 0 ? Colors.red : Colors.green,
              isBold: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _recordPayment(context),
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
                onPressed: () => _sendPaymentReminder(context),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(
    String label,
    int amount,
    Color color, {
    bool isBold = false,
  }) {
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
}

// =============================================================================
// TRANSACTIONS TAB
// =============================================================================

class _TransactionsTab extends StatelessWidget {
  final BuildContext context;
  final StudentDetailState state;

  const _TransactionsTab({required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: () {
            final transactions = _getFilteredTransactions();
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
              padding: EdgeInsets.all(width > 768 ? 24 : 16),
              itemCount: transactions.length,
              itemBuilder:
                  (context, index) =>
                      _TransactionCard(transaction: transactions[index]),
            );
          }(),
        ),
      ],
    );
  }

  List<Transaction> _getFilteredTransactions() {
    final transactions = state.studentDetails?.transactions ?? [];
    if (state.transactionFilter == 'all') return transactions;
    return transactions
        .where(
          (t) =>
              t.status?.toLowerCase() == state.transactionFilter.toLowerCase(),
        )
        .toList();
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = state.transactionFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<StudentDetailBloc>().add(
            StudentDetailTransactionFilterChanged(value),
          );
        }
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
                  child: Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${transaction.amount ?? 0}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
            _buildDetailRow(
              'Mode',
              _capitalizeFirst(transaction.transactionMode ?? 'N/A'),
            ),
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
}

// =============================================================================
// CREDIT BALANCE TAB
// =============================================================================

class _CreditBalanceTab extends StatelessWidget {
  final BuildContext context;
  final StudentDetailState state;

  const _CreditBalanceTab({required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    final creditBalance = state.studentDetails?.studentCreditBalance;
    final student = state.studentDetails?.student;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
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
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _addCredit(context),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Credit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF764ba2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Info Cards
          if (width > 600)
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Total Added',
                    '₹${creditBalance?.credit ?? 0}',
                    Icons.add_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    'Total Used',
                    '₹0',
                    Icons.remove_circle,
                    Colors.red,
                  ),
                ),
              ],
            )
          else ...[
            _buildInfoCard(
              'Total Added',
              '₹${creditBalance?.credit ?? 0}',
              Icons.add_circle,
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Total Used', '₹0', Icons.remove_circle, Colors.red),
          ],
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBalanceRow(
                    'Proposed Monthly Fee',
                    student?.proposedFee ?? 0,
                    Colors.blue,
                  ),
                  _buildBalanceRow(
                    'Current Credit',
                    creditBalance?.credit ?? 0,
                    Colors.green,
                  ),
                  const Divider(height: 24),
                  _buildBalanceRow(
                    'Amount Due',
                    (student?.proposedFee ?? 0) -
                        (creditBalance?.credit ?? 0), // Calculate due amount
                    ((student?.proposedFee ?? 0) -
                                (creditBalance?.credit ?? 0)) >
                            0
                        ? Colors.red
                        : Colors.green,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Options',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => _recordPayment(
                            context,
                          ), // Re-using existing method
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
                      onPressed:
                          () => _sendPaymentReminder(
                            context,
                          ), // Re-using existing method
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

  void _addCredit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add credit functionality coming soon!')),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(
    String label,
    int amount,
    Color color, {
    bool isBold = false,
  }) {
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
}

// =============================================================================
// DUE PAYMENTS TAB
// =============================================================================

class _DuePaymentsTab extends StatelessWidget {
  final BuildContext context;
  final StudentDetailState state;

  const _DuePaymentsTab({required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final duePayments = state.studentDetails?.duePayments ?? [];
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header with Add Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Payments',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${duePayments.length} payment records',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed:
                    () => context.read<StudentDetailBloc>().add(
                      StudentDetailGenerateNextPaymentRequested(),
                    ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Due Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Due Payments Timeline
        Expanded(
          child:
              duePayments.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No due payments found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new due payment to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed:
                              () => context.read<StudentDetailBloc>().add(
                                StudentDetailGenerateNextPaymentRequested(),
                              ),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Due Payment'),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.all(width > 768 ? 24 : 16),
                    itemCount: duePayments.length,
                    itemBuilder: (context, index) {
                      final duePayment = duePayments[index];
                      final isLast = index == duePayments.length - 1;
                      return _DuePaymentTimelineItem(
                        duePayment: duePayment,
                        isLast: isLast,
                        onEdit:
                            () =>
                                _showEditDuePaymentDialog(context, duePayment),
                        onDelete:
                            () => _confirmDeleteDuePayment(context, duePayment),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  void _confirmDeleteDuePayment(BuildContext context, DuePayment duePayment) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Due Payment'),
          content: Text(
            'Are you sure you want to delete the due payment for ${_getMonthName(duePayment.dueMonth ?? 1)} ${duePayment.dueYear}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // In a real app, we'd dispatch an event to delete.
                // For now, we'll just show a snackbar as we haven't implemented delete event.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete functionality coming soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _showEditDuePaymentDialog(BuildContext context, DuePayment duePayment) {
    final amountController = TextEditingController(
      text: (duePayment.amount ?? 0).toString(),
    );
    final monthController = TextEditingController(
      text: (duePayment.dueMonth ?? 1).toString(),
    );
    final yearController = TextEditingController(
      text: (duePayment.dueYear ?? DateTime.now().year).toString(),
    );
    String selectedStatus = duePayment.status ?? 'pending';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Due Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: monthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Month (1-12)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'paid', child: Text('Paid')),
                    DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                  ],
                  onChanged: (value) {
                    if (value != null) selectedStatus = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(amountController.text) ?? 0;
                final month = int.tryParse(monthController.text) ?? 1;
                final year =
                    int.tryParse(yearController.text) ?? DateTime.now().year;

                if (amount > 0 && month >= 1 && month <= 12 && year > 2000) {
                  // Dispatch update event here
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Update functionality coming soon!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid values')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// DUE PAYMENT TIMELINE ITEM
// =============================================================================

class _DuePaymentTimelineItem extends StatelessWidget {
  final DuePayment duePayment;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DuePaymentTimelineItem({
    required this.duePayment,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(duePayment.dueMonth ?? 1);
    final statusColor = _getStatusColor(duePayment.status ?? 'pending');
    final statusIcon = _getStatusIcon(duePayment.status ?? 'pending');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 3),
              ),
              child: Icon(statusIcon, size: 20, color: statusColor),
            ),
            if (!isLast)
              Container(width: 2, height: 80, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),

        // Content Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                                '$monthName ${duePayment.dueYear}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  (duePayment.status ?? 'pending')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${duePayment.amount ?? 0}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created: ${_formatDate(duePayment.createdAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (duePayment.updatedAt != null)
                                Text(
                                  'Updated: ${_formatDate(duePayment.updatedAt)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 20),
                          tooltip: 'Edit',
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text('Delete Due Payment'),
                                  content: Text(
                                    'Are you sure you want to delete the due payment for $monthName ${duePayment.dueYear}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        onDelete();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete, size: 20),
                          tooltip: 'Delete',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'overdue':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

// =============================================================================
// ACTIVITY TAB
// =============================================================================

class _ActivityTab extends StatelessWidget {
  final BuildContext context;
  final StudentDetailState state;

  const _ActivityTab({required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    final student = state.studentDetails?.student;
    final fcmToken = state.studentDetails?.fcmToken;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Timeline',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device & Platform Info',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (fcmToken != null) ...[
                    _buildDeviceInfoRow(
                      'Platform',
                      fcmToken.platform?.toUpperCase() ?? 'Unknown',
                    ),
                    _buildDeviceInfoRow(
                      'Device Status',
                      fcmToken.isActive == true ? 'Active' : 'Inactive',
                    ),
                    _buildDeviceInfoRow(
                      'Last Used',
                      _formatDateTime(fcmToken.lastUsedAt),
                    ),
                    _buildDeviceInfoRow(
                      'Token Created',
                      _formatDateTime(fcmToken.createdAt),
                    ),
                  ] else
                    const Center(
                      child: Text(
                        'No device information available',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
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

  Widget _buildTimelineItem(
    String title,
    DateTime? date,
    IconData icon,
    Color color,
  ) {
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
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
}
