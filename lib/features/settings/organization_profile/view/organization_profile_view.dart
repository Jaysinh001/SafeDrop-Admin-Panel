// =============================================================================
// ORGANIZATION DETAILS VIEW
// SafeDrop Organization Admin Panel
//
// Responsive across all screen sizes:
//   Desktop  (>= 1200) → two-column layout with sticky summary sidebar
//   Tablet   (>= 768)  → single-column, wider cards
//   Mobile   (<  768)  → single-column, compact cards
//
// Sections (sourced from schema):
//   1. Hero Header        — logo, name, type, status, join code
//   2. Quick Stats Row    — members, vehicles, routes, wallet balance
//   3. Contact & Info     — address, phone, email, website
//   4. Subscription Plan  — plan name, features, status, dates
//   5. Wallet & Finance   — balance, held, credited, debited
//   6. Member Breakdown   — roles doughnut-style list
//   7. Fleet Overview     — vehicles with status
//   8. Recent Audit Log   — last 5 audit entries
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/theme.dart';

// =============================================================================
// MOCK DATA MODELS
// =============================================================================

class _OrgMock {
  static const id = 1;
  static const name = 'Sunrise University';
  static const code = 'SUNRISE-2024';
  static const type = 'university';
  static const status = 'active';
  static const logoInitials = 'SU';
  static const address = '42, Knowledge Park, Sector 14, Gurugram, HR 122001';
  static const phone = '+91 98765 43210';
  static const email = 'admin@sunriseuniversity.edu.in';
  static const website = 'https://sunriseuniversity.edu.in';
  static const createdAt = '12 Jan 2023';
  static const updatedAt = '03 Mar 2025';

  // Subscription
  static const planName = 'Pro';
  static const planPrice = '₹4,999 / month';
  static const planStatus = 'active';
  static const planStart = '01 Jan 2025';
  static const planEnd = '31 Dec 2025';
  static const List<String> planFeatures = [
    'Live GPS Tracking',
    'Attendance Management',
    'Student Billing & Payments',
    'Chat & Announcements',
    'Penalty Rule Engine',
    'Audit Logs',
    'Up to 500 Students',
    'Up to 30 Drivers',
  ];

  // Wallet
  static const walletBalance = 2_48_500.00;
  static const walletHeld = 15_000.00;
  static const walletCredited = 12_45_000.00;
  static const walletDebited = 9_96_500.00;
  static const currency = 'INR';

  // Quick stats
  static const totalMembers = 432;
  static const totalVehicles = 18;
  static const totalRoutes = 12;
  static const activeTrips = 3;
  static const totalStudents = 380;
  static const totalDrivers = 28;
  static const totalAdmins = 5;

  // Member breakdown
  static const List<_MemberRole> memberRoles = [
    _MemberRole('Admin', 5, AppColors.primary),
    _MemberRole('Driver', 28, AppColors.info),
    _MemberRole('Student', 380, AppColors.success),
    _MemberRole('Staff', 19, AppColors.secondary),
  ];

  // Vehicles
  static const List<_VehicleMock> vehicles = [
    _VehicleMock('MH 12 AB 1234', 'Toyota HiAce', 'White', 14, 'active'),
    _VehicleMock('MH 12 CD 5678', 'Isuzu Elf', 'Silver', 20, 'active'),
    _VehicleMock('MH 12 EF 9012', 'Force Traveller', 'Blue', 17, 'maintenance'),
    _VehicleMock('MH 12 GH 3456', 'Toyota HiAce', 'White', 14, 'active'),
    _VehicleMock('MH 12 IJ 7890', 'Mahindra Supro', 'Yellow', 9, 'inactive'),
  ];

  // Audit log
  static const List<_AuditEntry> auditLog = [
    _AuditEntry(
      'Admin approved student enrollment',
      'user_management',
      'info',
      'Ravi Sharma',
      '10 Mar 2026, 09:42 AM',
    ),
    _AuditEntry(
      'Fee amount updated from ₹3,500 to ₹4,000',
      'billing',
      'warning',
      'Priya Mehta',
      '09 Mar 2026, 04:15 PM',
    ),
    _AuditEntry(
      'Driver schedule created for Route 3',
      'route',
      'info',
      'System',
      '09 Mar 2026, 08:00 AM',
    ),
    _AuditEntry(
      'Withdrawal request of ₹50,000 approved',
      'wallet',
      'critical',
      'Ravi Sharma',
      '08 Mar 2026, 03:30 PM',
    ),
    _AuditEntry(
      'New vehicle MH 12 GH 3456 added',
      'vehicle',
      'info',
      'Priya Mehta',
      '07 Mar 2026, 11:20 AM',
    ),
  ];
}

class _MemberRole {
  final String role;
  final int count;
  final Color color;
  const _MemberRole(this.role, this.count, this.color);
}

class _VehicleMock {
  final String plate;
  final String model;
  final String color;
  final int capacity;
  final String status;
  const _VehicleMock(
      this.plate, this.model, this.color, this.capacity, this.status);
}

class _AuditEntry {
  final String description;
  final String module;
  final String severity;
  final String actor;
  final String time;
  const _AuditEntry(
      this.description, this.module, this.severity, this.actor, this.time);
}

// =============================================================================
// MAIN VIEW
// =============================================================================

class OrganizationDetailsView extends StatefulWidget {
  const OrganizationDetailsView({super.key});

  @override
  State<OrganizationDetailsView> createState() =>
      _OrganizationDetailsViewState();
}

class _OrganizationDetailsViewState extends State<OrganizationDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.desktop;
    final isTablet = width >= Breakpoints.mobile;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      body: CustomScrollView(
        slivers: [
          // ── Hero header ────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHero(context, isTablet, isDesktop)),

          // ── Quick stats bar ────────────────────────────────────────────────
          SliverToBoxAdapter(
              child: _buildQuickStats(context, isTablet, isDesktop)),

          // ── Body ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: isDesktop
                ? _buildDesktopBody(context)
                : _buildNarrowBody(context, isTablet),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HERO HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHero(
      BuildContext context, bool isTablet, bool isDesktop) {
    final hPad = isDesktop
        ? AppSpacing.xxl
        : isTablet
            ? AppSpacing.xl
            : AppSpacing.md;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outline, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(hPad, AppSpacing.xl, hPad, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              Text(
                'Organizations',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.chevron_right,
                    size: 14, color: AppColors.textTertiary),
              ),
              Text(
                _OrgMock.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Logo row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo / initials
              Container(
                width: isTablet ? 72 : 56,
                height: isTablet ? 72 : 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.30),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _OrgMock.logoInitials,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: isTablet ? 26 : 20,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Name + chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _OrgMock.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _TypeBadge(_OrgMock.type),
                        _StatusBadge(_OrgMock.status),
                        _PlanBadge(_OrgMock.planName),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Join code row
                    _JoinCodeChip(code: _OrgMock.code),
                  ],
                ),
              ),

              // Edit button (desktop)
              if (isTablet) ...[
                const SizedBox(width: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.sm),
          Text(
            'Created ${_OrgMock.createdAt}  ·  Last updated ${_OrgMock.updatedAt}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUICK STATS BAR
  // ---------------------------------------------------------------------------

  Widget _buildQuickStats(
      BuildContext context, bool isTablet, bool isDesktop) {
    final hPad = isDesktop
        ? AppSpacing.xxl
        : isTablet
            ? AppSpacing.xl
            : AppSpacing.md;

    final stats = [
      _QuickStat(
        'Members',
        _OrgMock.totalMembers.toString(),
        Icons.people_alt_rounded,
        AppColors.primary,
        AppColors.primaryContainer,
      ),
      _QuickStat(
        'Students',
        _OrgMock.totalStudents.toString(),
        Icons.school_rounded,
        AppColors.info,
        AppColors.infoContainer,
      ),
      _QuickStat(
        'Drivers',
        _OrgMock.totalDrivers.toString(),
        Icons.drive_eta_rounded,
        AppColors.secondary,
        AppColors.secondaryContainer,
      ),
      _QuickStat(
        'Vehicles',
        _OrgMock.totalVehicles.toString(),
        Icons.directions_bus_rounded,
        AppColors.success,
        AppColors.successContainer,
      ),
      _QuickStat(
        'Routes',
        _OrgMock.totalRoutes.toString(),
        Icons.route_rounded,
        AppColors.warning,
        AppColors.warningContainer,
      ),
      _QuickStat(
        'Active Trips',
        _OrgMock.activeTrips.toString(),
        Icons.my_location_rounded,
        AppColors.error,
        AppColors.errorContainer,
      ),
    ];

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
          horizontal: hPad, vertical: AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats
              .map((s) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: _QuickStatCard(stat: s, compact: !isTablet),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP BODY  (two-column)
  // ---------------------------------------------------------------------------

  Widget _buildDesktopBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column — main content
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildContactCard(context),
                const SizedBox(height: AppSpacing.lg),
                _buildMemberBreakdownCard(context),
                const SizedBox(height: AppSpacing.lg),
                _buildFleetCard(context),
                const SizedBox(height: AppSpacing.lg),
                _buildAuditCard(context),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          // Right column — sidebar
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildWalletCard(context),
                const SizedBox(height: AppSpacing.lg),
                _buildSubscriptionCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NARROW BODY  (Tablet & Mobile — single column)
  // ---------------------------------------------------------------------------

  Widget _buildNarrowBody(BuildContext context, bool isTablet) {
    final hPad = isTablet ? AppSpacing.xl : AppSpacing.md;
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, AppSpacing.lg, hPad, 0),
      child: Column(
        children: [
          _buildContactCard(context),
          const SizedBox(height: AppSpacing.md),
          _buildWalletCard(context),
          const SizedBox(height: AppSpacing.md),
          _buildSubscriptionCard(context),
          const SizedBox(height: AppSpacing.md),
          _buildMemberBreakdownCard(context),
          const SizedBox(height: AppSpacing.md),
          _buildFleetCard(context),
          const SizedBox(height: AppSpacing.md),
          _buildAuditCard(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION CARDS
  // ---------------------------------------------------------------------------

  // ── Contact & Info ─────────────────────────────────────────────────────────

  Widget _buildContactCard(BuildContext context) {
    return _SectionCard(
      title: 'Contact & Information',
      icon: Icons.business_rounded,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: _OrgMock.address,
            iconColor: AppColors.error,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: _OrgMock.phone,
            iconColor: AppColors.success,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: _OrgMock.email,
            iconColor: AppColors.primary,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.language_rounded,
            label: 'Website',
            value: _OrgMock.website,
            iconColor: AppColors.info,
            isLink: true,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.category_rounded,
            label: 'Type',
            value: _OrgMock.type
                .replaceAll('_', ' ')
                .split(' ')
                .map((w) => w[0].toUpperCase() + w.substring(1))
                .join(' '),
            iconColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  // ── Wallet & Finance ────────────────────────────────────────────────────────

  Widget _buildWalletCard(BuildContext context) {
    return _SectionCard(
      title: 'Wallet & Finance',
      icon: Icons.account_balance_wallet_rounded,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.successContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          'Active',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.successDark,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      child: Column(
        children: [
          // Main balance highlight
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatCurrency(_OrgMock.walletBalance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.lock_rounded,
                        size: 12, color: Colors.white60),
                    const SizedBox(width: 4),
                    Text(
                      'On hold: ${_formatCurrency(_OrgMock.walletHeld)}',
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onPrimary.withOpacity(0.7),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Credited / Debited
          Row(
            children: [
              Expanded(
                child: _FinanceMetric(
                  label: 'Total Credited',
                  value: _formatCurrency(_OrgMock.walletCredited),
                  icon: Icons.arrow_circle_up_rounded,
                  color: AppColors.success,
                  bgColor: AppColors.successContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _FinanceMetric(
                  label: 'Total Debited',
                  value: _formatCurrency(_OrgMock.walletDebited),
                  icon: Icons.arrow_circle_down_rounded,
                  color: AppColors.error,
                  bgColor: AppColors.errorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.receipt_long_rounded, size: 16),
                  label: const Text('Transactions'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_circle_down_rounded, size: 16),
                  label: const Text('Withdraw'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Subscription Plan ───────────────────────────────────────────────────────

  Widget _buildSubscriptionCard(BuildContext context) {
    return _SectionCard(
      title: 'Subscription Plan',
      icon: Icons.workspace_premium_rounded,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          _OrgMock.planName,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start',
                  value: _OrgMock.planStart,
                  iconColor: AppColors.info,
                  dense: true,
                ),
              ),
              Expanded(
                child: _InfoRow(
                  icon: Icons.event_rounded,
                  label: 'End',
                  value: _OrgMock.planEnd,
                  iconColor: AppColors.warning,
                  dense: true,
                ),
              ),
            ],
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.payments_rounded,
            label: 'Price',
            value: _OrgMock.planPrice,
            iconColor: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),

          // Features grid
          Text(
            'Included Features',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _OrgMock.planFeatures
                .map((f) => _FeatureChip(feature: f))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upgrade_rounded, size: 16),
              label: const Text('Change Plan'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Member Breakdown ────────────────────────────────────────────────────────

  Widget _buildMemberBreakdownCard(BuildContext context) {
    const total = _OrgMock.totalStudents +
        _OrgMock.totalDrivers +
        _OrgMock.totalAdmins +
        19; // staff

    return _SectionCard(
      title: 'Member Breakdown',
      icon: Icons.people_alt_rounded,
      child: Column(
        children: [
          ..._OrgMock.memberRoles.map((role) {
            final pct = role.count / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: role.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        role.role,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${role.count}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: role.color,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '(${(pct * 100).toStringAsFixed(0)}%)',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(role.color),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.people_alt_rounded, size: 16),
            label: const Text('Manage Members'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40)),
          ),
        ],
      ),
    );
  }

  // ── Fleet Overview ──────────────────────────────────────────────────────────

  Widget _buildFleetCard(BuildContext context) {
    return _SectionCard(
      title: 'Fleet Overview',
      icon: Icons.directions_bus_rounded,
      trailing: TextButton(
        onPressed: () {},
        child: const Text('View All'),
      ),
      child: Column(
        children: _OrgMock.vehicles.map((v) => _VehicleRow(vehicle: v)).toList(),
      ),
    );
  }

  // ── Audit Log ───────────────────────────────────────────────────────────────

  Widget _buildAuditCard(BuildContext context) {
    return _SectionCard(
      title: 'Recent Audit Activity',
      icon: Icons.policy_rounded,
      trailing: TextButton(
        onPressed: () {},
        child: const Text('View All'),
      ),
      child: Column(
        children: _OrgMock.auditLog
            .map((entry) => _AuditRow(entry: entry))
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      final lac = amount / 100000;
      return '₹${lac.toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      final k = amount / 1000;
      return '₹${k.toStringAsFixed(1)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }
}

// =============================================================================
// SUB-WIDGETS
// =============================================================================

// ── Section Card shell ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: AppColors.outline),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool isLink;
  final bool dense;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.isLink = false,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: dense ? AppSpacing.xs : AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isLink ? AppColors.primary : AppColors.textPrimary,
                        decoration: isLink
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 0.5, color: AppColors.outlineVariant);
}

// ── Badges ───────────────────────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        type.replaceAll('_', ' ').toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.secondaryDark,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successContainer : AppColors.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppColors.successDark : AppColors.errorDark,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
          ),
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String plan;
  const _PlanBadge(this.plan);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_rounded,
              size: 11, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            '$plan Plan',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Join Code Chip ────────────────────────────────────────────────────────────

class _JoinCodeChip extends StatelessWidget {
  final String code;
  const _JoinCodeChip({required this.code});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Join code copied!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.key_rounded,
                size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 5),
            Text(
              code,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontFamily: 'monospace',
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.copy_rounded,
                size: 12, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

// ── Quick Stat Card ───────────────────────────────────────────────────────────

class _QuickStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  const _QuickStat(
      this.label, this.value, this.icon, this.color, this.bgColor);
}

class _QuickStatCard extends StatelessWidget {
  final _QuickStat stat;
  final bool compact;
  const _QuickStatCard({required this.stat, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.md : AppSpacing.lg,
          vertical: compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: stat.bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: stat.color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stat.icon, size: compact ? 16 : 20, color: stat.color),
          SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stat.value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: stat.color,
                      fontWeight: FontWeight.w800,
                      fontSize: compact ? 14 : 16,
                    ),
              ),
              Text(
                stat.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: stat.color.withOpacity(0.75),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Finance Metric ────────────────────────────────────────────────────────────

class _FinanceMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _FinanceMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color.withOpacity(0.7),
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature Chip ──────────────────────────────────────────────────────────────

class _FeatureChip extends StatelessWidget {
  final String feature;
  const _FeatureChip({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.successContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 11, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            feature,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.successDark,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Vehicle Row ───────────────────────────────────────────────────────────────

class _VehicleRow extends StatelessWidget {
  final _VehicleMock vehicle;
  const _VehicleRow({required this.vehicle});

  static Color _statusColor(String s) {
    switch (s) {
      case 'active':
        return AppColors.success;
      case 'maintenance':
        return AppColors.warning;
      default:
        return AppColors.textTertiary;
    }
  }

  static Color _statusBg(String s) {
    switch (s) {
      case 'active':
        return AppColors.successContainer;
      case 'maintenance':
        return AppColors.warningContainer;
      default:
        return AppColors.surfaceContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(vehicle.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.outline, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: _statusBg(vehicle.status),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(Icons.directions_bus_rounded, size: 16, color: color),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.plate,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                          color: AppColors.textPrimary,
                        ),
                  ),
                  Text(
                    '${vehicle.model}  ·  ${vehicle.color}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            // Capacity
            Row(
              children: [
                const Icon(Icons.people_rounded,
                    size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 3),
                Text(
                  '${vehicle.capacity}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            // Status chip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 3),
              decoration: BoxDecoration(
                color: _statusBg(vehicle.status),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                vehicle.status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Audit Row ─────────────────────────────────────────────────────────────────

class _AuditRow extends StatelessWidget {
  final _AuditEntry entry;
  const _AuditRow({required this.entry});

  static Color _severityColor(String s) {
    switch (s) {
      case 'critical':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  static IconData _moduleIcon(String m) {
    switch (m) {
      case 'billing':
        return Icons.receipt_long_rounded;
      case 'route':
        return Icons.route_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'vehicle':
        return Icons.directions_bus_rounded;
      default:
        return Icons.manage_accounts_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(entry.severity);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(_moduleIcon(entry.module), size: 14, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 3),
                    Text(
                      entry.actor,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 3),
                    Text(
                      entry.time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs + 2, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              entry.severity,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}