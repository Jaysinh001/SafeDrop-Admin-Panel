import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/loading_view.dart';
import '../../../../core/dependencies/injection_container.dart';
import '../bloc/driver_details_bloc/driver_details_bloc.dart';
import '../bloc/driver_details_bloc/driver_details_event.dart';
import '../bloc/driver_details_bloc/driver_details_state.dart';
import '../model/driver_details_response.dart';
import '../model/drivers_list_response.dart' as dlr;

// =============================================================================
// DRIVER DETAILS VIEW
// =============================================================================

class DriverDetailsView extends StatefulWidget {
  final dynamic arguments;

  const DriverDetailsView({
    super.key,
    this.arguments,
  });

  @override
  State<DriverDetailsView> createState() => _DriverDetailsViewState();
}

class _DriverDetailsViewState extends State<DriverDetailsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      context.read<DriverDetailsBloc>().add(
        DriverDetailsTabChanged(_tabController.index),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int driverId = 0;
    final args = widget.arguments;
    // if (args is dlr.Driver) {
    //   driverId = args.id ?? 0;
    // } else if (args is Map && args['id'] != null) {
    //   driverId = args['id'];
    // }

    return BlocProvider.value(
      value: sl<DriverDetailsBloc>()..add(DriverDetailsLoaded(driverId: driverId)),
      child: BlocListener<DriverDetailsBloc, DriverDetailsState>(
        listener: _handleStateChanges,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: BlocBuilder<DriverDetailsBloc, DriverDetailsState>(
            builder: (context, state) {
              if (state.status == DriverDetailStatus.loading) {
                return const LoadingView(title: 'Loading driver details...');
              }

              if (state.driverDetails == null) {
                return _buildErrorState(context);
              }

              return Column(
                children: [
                  _buildDriverHeader(context, state),
                  _buildTabBar(context, state),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _OverviewTab(state: state),
                        _WalletTab(wallet: state.wallet),
                        _BankDetailsTab(bankDetails: state.bankDetails),
                        _VehiclesTab(vehicles: state.vehicles),
                        _ActivityTab(driver: state.driver, fcmToken: state.fcmToken),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return BlocBuilder<DriverDetailsBloc, DriverDetailsState>(
                builder: (context, state) => _buildFloatingActions(context, state),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, DriverDetailsState state) {
    // Show error snackbar
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // Show suspend confirmation dialog
    if (state.showSuspendConfirmation) {
      _showSuspendDialog(context);
    }

    // Show notification sent message
    if (state.showNotificationSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification sent to driver'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Handle contact request
    if (state.contactPhoneNumber != null) {
      _launchPhone(state.contactPhoneNumber!);
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+$phoneNumber",
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showSuspendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Suspend Driver'),
        content: const Text('Are you sure you want to suspend this driver?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Driver suspended successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverHeader(BuildContext context, DriverDetailsState state) {
    final driver = state.driver;

    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
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
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              if (MediaQuery.of(context).size.width > 768)
                _buildActionButtons(context),
            ],
          ),
          const SizedBox(height: 16),
          MediaQuery.of(context).size.width > 768
              ? _buildDesktopProfile(context, state, driver)
              : _buildMobileProfile(context, state, driver),
        ],
      ),
    );
  }

  Widget _buildDesktopProfile(
    BuildContext context,
    DriverDetailsState state,
    Driver? driver,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              driver?.profilePicture != null
                  ? NetworkImage(driver!.profilePicture!)
                  : null,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child:
              driver?.profilePicture == null
                  ? Text(
                    (driver?.driverName ?? 'N')[0].toUpperCase(),
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
                driver?.driverName ?? 'Unknown Driver',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Driver ID: ${driver?.id} • Code: ${state.uniqueCode?.uniqueCode ?? 'N/A'}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusChip(state),
                  const SizedBox(width: 12),
                  if (driver?.email != null) ...[
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(driver!.email!),
                    const SizedBox(width: 16),
                  ],
                  if (driver?.phoneNumber != null) ...[
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(driver!.phoneNumber!),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (state.wallet != null) _WalletSummaryCard(wallet: state.wallet!),
      ],
    );
  }

  Widget _buildMobileProfile(
    BuildContext context,
    DriverDetailsState state,
    Driver? driver,
  ) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  driver?.profilePicture != null
                      ? NetworkImage(driver!.profilePicture!)
                      : null,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child:
                  driver?.profilePicture == null
                      ? Text(
                        (driver?.driverName ?? 'N')[0].toUpperCase(),
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
                    driver?.driverName ?? 'Unknown Driver',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${driver?.id} • Code: ${state.uniqueCode?.uniqueCode ?? 'N/A'}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(state),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (driver?.email != null || driver?.phoneNumber != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (driver?.email != null) ...[
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(child: Text(driver!.email!)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                if (driver?.phoneNumber != null)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(child: Text(driver!.phoneNumber!)),
                    ],
                  ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        if (state.wallet != null)
          _WalletSummaryCard(wallet: state.wallet!, isCompact: true),
      ],
    );
  }

  Widget _buildStatusChip(DriverDetailsState state) {
    final statusColor = _getStatusColor(state.driverStatus);
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
            state.driverStatus,
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

  Color _getStatusColor(String status) {
    if (status == 'Active') return Colors.green;
    if (status == 'Incomplete Setup') return Colors.orange;
    return Colors.red;
  }

  Widget _buildActionButtons(BuildContext context) {
    final bloc = context.read<DriverDetailsBloc>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => bloc.add(DriverDetailsContactRequested()),
          icon: const Icon(Icons.phone, size: 16),
          label: const Text('Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => bloc.add(DriverDetailsNotificationRequested()),
          icon: const Icon(Icons.notifications, size: 16),
          label: const Text('Notify'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit functionality coming soon!')),
          ),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => bloc.add(DriverDetailsSuspendRequested()),
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

  Widget _buildTabBar(BuildContext context, DriverDetailsState state) {
    return Container(
      color: Colors.white,
      child: MediaQuery.of(context).size.width > 768
          ? _buildDesktopTabBar(context, state)
          : _buildMobileTabBar(context, state),
    );
  }

  Widget _buildDesktopTabBar(BuildContext context, DriverDetailsState state) {
    final bloc = context.read<DriverDetailsBloc>();
    return TabBar(
      controller: _tabController,
      tabs: bloc.tabTitles.map((title) => Tab(text: title, height: 48)).toList(),
      isScrollable: true,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Colors.blue,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _buildMobileTabBar(BuildContext context, DriverDetailsState state) {
    final bloc = context.read<DriverDetailsBloc>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: bloc.tabTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = state.selectedTab == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(title),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _tabController.animateTo(index);
                }
              },
              selectedColor: Colors.blue.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingActions(BuildContext context, DriverDetailsState state) {
    final bloc = context.read<DriverDetailsBloc>();
    if (MediaQuery.of(context).size.width <= 768) {
      return FloatingActionButton(
        onPressed: () => _showMobileActionsSheet(context, bloc),
        child: const Icon(Icons.more_vert),
      );
    }
    return FloatingActionButton(
      onPressed: () => bloc.add(DriverDetailsRefreshed()),
      child: const Icon(Icons.refresh),
    );
  }

  void _showMobileActionsSheet(BuildContext context, DriverDetailsBloc bloc) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => Container(
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
                title: const Text('Call Driver'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  bloc.add(DriverDetailsContactRequested());
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.blue),
                title: const Text('Send Notification'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  bloc.add(DriverDetailsNotificationRequested());
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit Driver'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit functionality coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Suspend Driver'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  bloc.add(DriverDetailsSuspendRequested());
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  bloc.add(DriverDetailsRefreshed());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final bloc = context.read<DriverDetailsBloc>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load driver details'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => bloc.add(DriverDetailsRefreshed()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// WALLET SUMMARY CARD
// =============================================================================

class _WalletSummaryCard extends StatelessWidget {
  final Wallet wallet;
  final bool isCompact;

  const _WalletSummaryCard({required this.wallet, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        children: [
          Expanded(
            child: _buildBalanceCard(
              'Available',
              wallet.availableBalance ?? 0,
              Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBalanceCard(
              'Pending',
              wallet.pendingBalance ?? 0,
              Colors.orange,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallet Balance',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${wallet.availableBalance ?? 0}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pending: ₹${wallet.pendingBalance ?? 0}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String label, int amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹$amount',
            style: TextStyle(
              color: color,
              fontSize: 18,
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
  final DriverDetailsState state;

  const _OverviewTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
      child: MediaQuery.of(context).size.width > 1024
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildPersonalInfoCard(context),
              const SizedBox(height: 16),
              _buildAccountStatusCard(context),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildQuickStatsCard(context),
              const SizedBox(height: 16),
              _buildRecentActivityCard(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildPersonalInfoCard(context),
        const SizedBox(height: 16),
        _buildAccountStatusCard(context),
        const SizedBox(height: 16),
        _buildQuickStatsCard(context),
        const SizedBox(height: 16),
        _buildRecentActivityCard(context),
      ],
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    final driver = state.driver;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.person,
              'Full Name',
              driver?.driverName ?? 'N/A',
            ),
            _buildInfoRow(Icons.email, 'Email', driver?.email ?? 'N/A'),
            _buildInfoRow(Icons.phone, 'Phone', driver?.phoneNumber ?? 'N/A'),
            _buildInfoRow(
              Icons.badge,
              'Unique Code',
              state.uniqueCode?.uniqueCode ?? 'N/A',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              'Joined',
              _formatDate(driver?.createdAt),
            ),
            _buildInfoRow(
              Icons.update,
              'Last Updated',
              _formatDate(driver?.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatusCard(BuildContext context) {
    final driver = state.driver;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusItem('Bank Details', driver?.hasBankDetails ?? false),
            _buildStatusItem('MPIN Set', driver?.mpinSet ?? false),
            _buildStatusItem(
              'Profile Complete',
              (driver?.hasBankDetails ?? false) && (driver?.mpinSet ?? false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              'Bank Accounts',
              '${state.bankDetails.length}',
              Icons.account_balance,
            ),
            _buildStatItem(
              'Vehicles',
              '${state.vehicles.length}',
              Icons.directions_car,
            ),
            _buildStatItem(
              'Wallet Balance',
              '₹${state.wallet?.availableBalance ?? 0}',
              Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (state.fcmToken != null) ...[
              _buildInfoRow(
                Icons.phone_android,
                'Platform',
                state.fcmToken!.platform?.toUpperCase() ?? 'Unknown',
              ),
              _buildInfoRow(
                Icons.circle,
                'Status',
                state.fcmToken!.isActive == true ? 'Active' : 'Inactive',
              ),
              _buildInfoRow(
                Icons.access_time,
                'Last Active',
                _formatDate(state.fcmToken!.lastUsedAt),
              ),
            ] else
              const Center(child: Text('No device information available')),
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

  Widget _buildStatusItem(String label, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.cancel,
            color: isComplete ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// =============================================================================
// WALLET TAB
// =============================================================================

class _WalletTab extends StatelessWidget {
  final Wallet? wallet;

  const _WalletTab({this.wallet});

  @override
  Widget build(BuildContext context) {
    if (wallet == null) {
      return const Center(child: Text('No wallet information available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
      child: Column(
        children: [
          MediaQuery.of(context).size.width > 768
              ? Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      'Available Balance',
                      wallet!.availableBalance ?? 0,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBalanceCard(
                      'Pending Balance',
                      wallet!.pendingBalance ?? 0,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBalanceCard(
                      'Total Balance',
                      (wallet!.availableBalance ?? 0) +
                          (wallet!.pendingBalance ?? 0),
                      Colors.blue,
                    ),
                  ),
                ],
              )
              : Column(
                children: [
                  _buildBalanceCard(
                    'Available Balance',
                    wallet!.availableBalance ?? 0,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceCard(
                    'Pending Balance',
                    wallet!.pendingBalance ?? 0,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceCard(
                    'Total Balance',
                    (wallet!.availableBalance ?? 0) +
                        (wallet!.pendingBalance ?? 0),
                    Colors.blue,
                  ),
                ],
              ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildWalletInfoRow('Wallet ID', '${wallet!.id ?? 'N/A'}'),
                  _buildWalletInfoRow(
                    'Driver ID',
                    '${wallet!.driverId ?? 'N/A'}',
                  ),
                  _buildWalletInfoRow(
                    'Last Updated',
                    _formatDateTime(wallet!.updatedAt),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, int amount, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '₹$amount',
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
// BANK DETAILS TAB
// =============================================================================

class _BankDetailsTab extends StatelessWidget {
  final List<BankDetail> bankDetails;

  const _BankDetailsTab({required this.bankDetails});

  @override
  Widget build(BuildContext context) {
    if (bankDetails.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No bank details available'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
      itemCount: bankDetails.length,
      itemBuilder: (context, index) {
        final bank = bankDetails[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bank.bankName ?? 'Unknown Bank',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (bank.isPrimary == true)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'PRIMARY',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildBankDetailRow(
                  'Account Holder',
                  bank.accountHolder ?? 'N/A',
                ),
                _buildBankDetailRow(
                  'Account Number',
                  bank.accountNumber ?? 'N/A',
                ),
                _buildBankDetailRow('IFSC Code', bank.ifscCode ?? 'N/A'),
                _buildBankDetailRow('Added On', _formatDate(bank.createdAt)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// =============================================================================
// VEHICLES TAB
// =============================================================================

class _VehiclesTab extends StatelessWidget {
  final List<Vehicle> vehicles;

  const _VehiclesTab({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    if (vehicles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No vehicles assigned'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.purple,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.vehicleNumber ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          if (vehicle.isAssigned == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'ASSIGNED',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildVehicleDetailRow('Type', vehicle.vehicleType ?? 'N/A'),
                _buildVehicleDetailRow('Model', vehicle.model ?? 'N/A'),
                _buildVehicleDetailRow('Color', vehicle.color ?? 'N/A'),
                _buildVehicleDetailRow(
                  'Owner ID',
                  '${vehicle.ownerId ?? 'N/A'}',
                ),
                _buildVehicleDetailRow(
                  'Assigned On',
                  _formatDate(vehicle.createdAt),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// =============================================================================
// ACTIVITY TAB
// =============================================================================

class _ActivityTab extends StatelessWidget {
  final Driver? driver;
  final FcmToken? fcmToken;

  const _ActivityTab({this.driver, this.fcmToken});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 768 ? 24 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Timeline',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineItem(
                    'Account Created',
                    driver?.createdAt,
                    Icons.person_add,
                    Colors.blue,
                  ),
                  _buildTimelineItem(
                    'Profile Updated',
                    driver?.updatedAt,
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (fcmToken != null) ...[
                    _buildDeviceInfoRow(
                      'Platform',
                      fcmToken!.platform?.toUpperCase() ?? 'Unknown',
                    ),
                    _buildDeviceInfoRow(
                      'Device Status',
                      fcmToken!.isActive == true ? 'Active' : 'Inactive',
                    ),
                    _buildDeviceInfoRow(
                      'Last Used',
                      _formatDateTime(fcmToken!.lastUsedAt),
                    ),
                    _buildDeviceInfoRow(
                      'Token Created',
                      _formatDateTime(fcmToken!.createdAt),
                    ),
                  ] else
                    const Center(
                      child: Text('No device information available'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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