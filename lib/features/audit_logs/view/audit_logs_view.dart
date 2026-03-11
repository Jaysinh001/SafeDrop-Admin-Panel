// =============================================================================
// AUDIT LOG VIEW  — READ ONLY
// Design follows the same pattern as DriversListView / StudentsListView.
// Schema: audit_log (id, organization_id, user_id, actor_type, actor_ip,
//   actor_agent, action, module, table_name, record_id, old_values,
//   new_values, changes, description, severity, created_at)
// =============================================================================

import 'package:flutter/material.dart';

// =============================================================================
// DOMAIN MODEL
// =============================================================================

class AuditLog {
  final int id;
  final int? organizationId;
  final int? userId;
  final String actorName; // resolved from user_id for display
  final String actorType; // user | system | cron
  final String? actorIp;
  final String? actorAgent;
  final String action;
  final String module;
  final String tableName;
  final int? recordId;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final Map<String, dynamic>? changes;
  final String? description;
  final String severity; // info | warning | critical
  final DateTime createdAt;

  const AuditLog({
    required this.id,
    this.organizationId,
    this.userId,
    required this.actorName,
    required this.actorType,
    this.actorIp,
    this.actorAgent,
    required this.action,
    required this.module,
    required this.tableName,
    this.recordId,
    this.oldValues,
    this.newValues,
    this.changes,
    this.description,
    required this.severity,
    required this.createdAt,
  });
}

// =============================================================================
// MOCK DATA
// =============================================================================

final List<AuditLog> _mockAuditLogs = [
  AuditLog(
    id: 1048, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'approved', module: 'user_management',
    tableName: 'organization_user', recordId: 214,
    oldValues: {'is_active': false}, newValues: {'is_active': true},
    changes: {'is_active': [false, true]},
    description: 'Admin approved student enrollment for Ananya Patel (ID 214)',
    severity: 'info', createdAt: DateTime(2026, 3, 10, 9, 42, 11),
  ),
  AuditLog(
    id: 1047, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    action: 'updated', module: 'billing',
    tableName: 'student_billing', recordId: 89,
    oldValues: {'fee_amount': 3500.00}, newValues: {'fee_amount': 4000.00},
    changes: {'fee_amount': [3500.00, 4000.00]},
    description: 'Fee amount updated from \u20b93,500 to \u20b94,000 for student ID 89',
    severity: 'warning', createdAt: DateTime(2026, 3, 9, 16, 15, 44),
  ),
  AuditLog(
    id: 1046, organizationId: 1, userId: null, actorName: 'Cron Job',
    actorType: 'cron', actorIp: null, actorAgent: null,
    action: 'created', module: 'billing',
    tableName: 'billing_cycle', recordId: 312,
    oldValues: null,
    newValues: {'student_id': 89, 'period_start': '2026-03-01', 'base_amount': 4000.00, 'status': 'pending'},
    changes: null,
    description: 'Monthly billing cycle auto-generated for March 2026 (student ID 89)',
    severity: 'info', createdAt: DateTime(2026, 3, 1, 0, 0, 3),
  ),
  AuditLog(
    id: 1045, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'approved', module: 'wallet',
    tableName: 'withdrawal_request', recordId: 18,
    oldValues: {'status': 'pending'}, newValues: {'status': 'approved'},
    changes: {'status': ['pending', 'approved']},
    description: 'Withdrawal request of \u20b950,000 approved by Ravi Sharma',
    severity: 'critical', createdAt: DateTime(2026, 3, 8, 15, 30, 22),
  ),
  AuditLog(
    id: 1044, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    action: 'created', module: 'vehicle',
    tableName: 'vehicle', recordId: 18,
    oldValues: null,
    newValues: {'license_plate': 'MH 12 GH 3456', 'model': 'Toyota HiAce', 'capacity': 14},
    changes: null,
    description: 'New vehicle MH 12 GH 3456 (Toyota HiAce) added to fleet',
    severity: 'info', createdAt: DateTime(2026, 3, 7, 11, 20, 5),
  ),
  AuditLog(
    id: 1043, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'created', module: 'route',
    tableName: 'driver_schedule', recordId: 95,
    oldValues: null,
    newValues: {'driver_id': 7, 'route_id': 3, 'start_time': '07:30:00', 'recurrence': 'weekdays'},
    changes: null,
    description: 'Driver schedule created for Route 3 (weekdays, 07:30 AM)',
    severity: 'info', createdAt: DateTime(2026, 3, 6, 8, 0, 0),
  ),
  AuditLog(
    id: 1042, organizationId: 1, userId: null, actorName: 'System',
    actorType: 'system', actorIp: null, actorAgent: null,
    action: 'updated', module: 'billing',
    tableName: 'billing_cycle', recordId: 305,
    oldValues: {'status': 'pending', 'penalty_amount': 0.00},
    newValues: {'status': 'overdue', 'penalty_amount': 500.00},
    changes: {'status': ['pending', 'overdue'], 'penalty_amount': [0.00, 500.00]},
    description: 'Penalty \u20b9500 applied to overdue billing cycle ID 305 (Tier 1 rule)',
    severity: 'warning', createdAt: DateTime(2026, 3, 6, 0, 0, 1),
  ),
  AuditLog(
    id: 1041, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Flutter/3.19.0 (android)',
    action: 'revoked', module: 'user_management',
    tableName: 'organization_user', recordId: 198,
    oldValues: {'is_active': true, 'role': 'driver'},
    newValues: {'is_active': false, 'deleted_at': '2026-03-05T17:10:00'},
    changes: {'is_active': [true, false]},
    description: 'Driver account deactivated — Mohan Das (ID 198), employment terminated',
    severity: 'critical', createdAt: DateTime(2026, 3, 5, 17, 10, 33),
  ),
  AuditLog(
    id: 1040, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'created', module: 'announcement',
    tableName: 'announcement', recordId: 44,
    oldValues: null,
    newValues: {'title': 'Holiday Schedule \u2014 Holi 2026', 'priority': 'high', 'send_push': true},
    changes: null,
    description: 'High-priority announcement published: "Holiday Schedule \u2014 Holi 2026"',
    severity: 'info', createdAt: DateTime(2026, 3, 5, 9, 0, 0),
  ),
  AuditLog(
    id: 1039, organizationId: 1, userId: 8, actorName: 'Karan Joshi',
    actorType: 'user', actorIp: '49.36.201.88',
    actorAgent: 'Flutter/3.19.0 (ios)',
    action: 'logged_in', module: 'auth',
    tableName: 'refresh_token', recordId: 501,
    oldValues: null, newValues: {'user_id': 8, 'device_id': 22},
    changes: null,
    description: 'User Karan Joshi logged in from iPhone (iOS)',
    severity: 'info', createdAt: DateTime(2026, 3, 5, 8, 55, 12),
  ),
  AuditLog(
    id: 1038, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    action: 'assigned', module: 'route',
    tableName: 'student_route', recordId: 156,
    oldValues: {'route_id': 2, 'boarding_stop_id': 5},
    newValues: {'route_id': 4, 'boarding_stop_id': 11},
    changes: {'route_id': [2, 4], 'boarding_stop_id': [5, 11]},
    description: 'Student Ananya Patel reassigned from Route 2 to Route 4',
    severity: 'warning', createdAt: DateTime(2026, 3, 4, 14, 22, 8),
  ),
  AuditLog(
    id: 1037, organizationId: 1, userId: null, actorName: 'System',
    actorType: 'system', actorIp: null, actorAgent: null,
    action: 'updated', module: 'tracking',
    tableName: 'trip_session', recordId: 78,
    oldValues: {'status': 'ongoing'},
    newValues: {'status': 'completed', 'ended_at': '2026-03-04T09:45:00'},
    changes: {'status': ['ongoing', 'completed']},
    description: 'Trip session #78 (Route 3) marked completed automatically',
    severity: 'info', createdAt: DateTime(2026, 3, 4, 9, 45, 0),
  ),
  AuditLog(
    id: 1036, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'deleted', module: 'route',
    tableName: 'route', recordId: 8,
    oldValues: {'name': 'Route 8 (Old Bypass)', 'is_active': false},
    newValues: null, changes: null,
    description: 'Inactive route "Route 8 (Old Bypass)" permanently deleted',
    severity: 'critical', createdAt: DateTime(2026, 3, 3, 11, 5, 50),
  ),
  AuditLog(
    id: 1035, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    action: 'updated', module: 'vehicle',
    tableName: 'vehicle', recordId: 12,
    oldValues: {'status': 'active'}, newValues: {'status': 'maintenance'},
    changes: {'status': ['active', 'maintenance']},
    description: 'Vehicle MH 12 EF 9012 status changed to maintenance',
    severity: 'warning', createdAt: DateTime(2026, 3, 3, 10, 30, 0),
  ),
  AuditLog(
    id: 1034, organizationId: 1, userId: null, actorName: 'Cron Job',
    actorType: 'cron', actorIp: null, actorAgent: null,
    action: 'updated', module: 'billing',
    tableName: 'student_billing', recordId: 101,
    oldValues: {'next_bill_date': '2026-03-01'},
    newValues: {'next_bill_date': '2026-04-01'},
    changes: {'next_bill_date': ['2026-03-01', '2026-04-01']},
    description: 'Next bill date advanced to 01 Apr 2026 for student billing ID 101',
    severity: 'info', createdAt: DateTime(2026, 3, 1, 0, 1, 0),
  ),
  AuditLog(
    id: 1033, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'created', module: 'user_management',
    tableName: 'organization_invitation', recordId: 31,
    oldValues: null,
    newValues: {'email': 'newdriver@example.com', 'role': 'driver', 'status': 'pending'},
    changes: null,
    description: 'Invitation sent to newdriver@example.com for role: driver',
    severity: 'info', createdAt: DateTime(2026, 3, 1, 10, 0, 0),
  ),
  AuditLog(
    id: 1032, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'updated', module: 'user_management',
    tableName: 'permission_policy', recordId: 12,
    oldValues: {'allowed': true}, newValues: {'allowed': false},
    changes: {'allowed': [true, false]},
    description: 'Permission "billing:manage" revoked from group "Finance Team"',
    severity: 'critical', createdAt: DateTime(2026, 2, 28, 16, 40, 0),
  ),
  AuditLog(
    id: 1031, organizationId: 1, userId: 8, actorName: 'Karan Joshi',
    actorType: 'user', actorIp: '49.36.201.88',
    actorAgent: 'Flutter/3.19.0 (ios)',
    action: 'updated', module: 'attendance',
    tableName: 'attendance', recordId: 4401,
    oldValues: {'status': 'absent'}, newValues: {'status': 'present'},
    changes: {'status': ['absent', 'present']},
    description: 'Attendance corrected to present \u2014 student Rohan Verma, Trip #77',
    severity: 'warning', createdAt: DateTime(2026, 2, 28, 10, 15, 0),
  ),
  AuditLog(
    id: 1030, organizationId: 1, userId: 5, actorName: 'Priya Mehta',
    actorType: 'user', actorIp: '103.21.58.145',
    actorAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    action: 'created', module: 'billing',
    tableName: 'organization_penalty_rule', recordId: 5,
    oldValues: null,
    newValues: {'tier_order': 2, 'grace_period_days': 7, 'penalty_amount': 1000.00, 'penalty_period': 'weekly'},
    changes: null,
    description: 'Penalty rule Tier 2 created: \u20b91,000/week after 7 days grace',
    severity: 'warning', createdAt: DateTime(2026, 2, 27, 14, 0, 0),
  ),
  AuditLog(
    id: 1029, organizationId: 1, userId: 3, actorName: 'Ravi Sharma',
    actorType: 'user', actorIp: '103.21.58.142',
    actorAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    action: 'logged_out', module: 'auth',
    tableName: 'refresh_token', recordId: 498,
    oldValues: {'revoked': false}, newValues: {'revoked': true},
    changes: {'revoked': [false, true]},
    description: 'User Ravi Sharma logged out \u2014 refresh token revoked',
    severity: 'info', createdAt: DateTime(2026, 2, 27, 18, 30, 0),
  ),
];

// =============================================================================
// FILTER OPTIONS
// =============================================================================

const _filterOptions = ['all', 'critical', 'warning', 'info', 'user', 'system', 'cron'];

// =============================================================================
// INTERNAL STATE  (pure, no BLoC — swap in BLoC events/state as needed)
// =============================================================================

class _VS {
  final String searchQuery;
  final String selectedFilter;
  final String selectedModule;
  final String sortBy;
  final bool sortAscending;
  final DateTimeRange? dateRange;

  const _VS({
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.selectedModule = 'all',
    this.sortBy = 'timestamp',
    this.sortAscending = false,
    this.dateRange,
  });

  List<AuditLog> get filtered {
    var list = List<AuditLog>.from(_mockAuditLogs);

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((e) =>
        (e.description ?? '').toLowerCase().contains(q) ||
        e.actorName.toLowerCase().contains(q) ||
        e.module.toLowerCase().contains(q) ||
        e.action.toLowerCase().contains(q) ||
        e.tableName.toLowerCase().contains(q) ||
        (e.actorIp ?? '').contains(q),
      ).toList();
    }

    if (selectedFilter != 'all') {
      if (['critical', 'warning', 'info'].contains(selectedFilter)) {
        list = list.where((e) => e.severity == selectedFilter).toList();
      } else {
        list = list.where((e) => e.actorType == selectedFilter).toList();
      }
    }

    if (selectedModule != 'all') {
      list = list.where((e) => e.module == selectedModule).toList();
    }

    if (dateRange != null) {
      list = list.where((e) =>
        e.createdAt.isAfter(dateRange!.start.subtract(const Duration(seconds: 1))) &&
        e.createdAt.isBefore(dateRange!.end.add(const Duration(days: 1))),
      ).toList();
    }

    list.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case 'severity':
          const o = {'critical': 0, 'warning': 1, 'info': 2};
          cmp = (o[a.severity] ?? 3).compareTo(o[b.severity] ?? 3);
          break;
        case 'module':  cmp = a.module.compareTo(b.module); break;
        case 'action':  cmp = a.action.compareTo(b.action); break;
        case 'actor':   cmp = a.actorName.compareTo(b.actorName); break;
        default:        cmp = a.createdAt.compareTo(b.createdAt);
      }
      return sortAscending ? cmp : -cmp;
    });

    return list;
  }

  Map<String, int> get stats => {
    'total':    _mockAuditLogs.length,
    'critical': _mockAuditLogs.where((e) => e.severity == 'critical').length,
    'warning':  _mockAuditLogs.where((e) => e.severity == 'warning').length,
    'info':     _mockAuditLogs.where((e) => e.severity == 'info').length,
  };

  _VS copyWith({
    String? searchQuery, String? selectedFilter, String? selectedModule,
    String? sortBy, bool? sortAscending, Object? dateRange = _s,
  }) => _VS(
    searchQuery:    searchQuery    ?? this.searchQuery,
    selectedFilter: selectedFilter ?? this.selectedFilter,
    selectedModule: selectedModule ?? this.selectedModule,
    sortBy:         sortBy         ?? this.sortBy,
    sortAscending:  sortAscending  ?? this.sortAscending,
    dateRange:      dateRange == _s ? this.dateRange : dateRange as DateTimeRange?,
  );
}
const _s = Object(); // sentinel

// =============================================================================
// MAIN VIEW
// =============================================================================

class AuditLogView extends StatefulWidget {
  const AuditLogView({super.key});
  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  _VS _vs = const _VS();
  final _searchCtrl = TextEditingController();

  void _set(_VS next) => setState(() => _vs = next);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _vs.dateRange,
    );
    if (picked != null) _set(_vs.copyWith(dateRange: picked));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _vs.filtered;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(context, filtered.length),
          _buildFilterBar(context),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(context)
                : _buildList(context, filtered),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, int count) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
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
                Row(
                  children: [
                    Text(
                      'Audit Log',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orange.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 11, color: Colors.orange[700]),
                          const SizedBox(width: 4),
                          Text('Read Only', style: TextStyle(
                            color: Colors.orange[700], fontSize: 11, fontWeight: FontWeight.w700,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$count event${count == 1 ? '' : 's'} found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
          if (width > 768) _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final s = _vs.stats;
    return Row(children: [
      _chip('Total',    s['total']!,    Colors.blue),
      const SizedBox(width: 8),
      _chip('Critical', s['critical']!, Colors.red),
      const SizedBox(width: 8),
      _chip('Warning',  s['warning']!,  Colors.orange),
      const SizedBox(width: 8),
      _chip('Info',     s['info']!,     Colors.green),
    ]);
  }

  Widget _chip(String label, int count, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('$label ($count)', style: TextStyle(
        color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    ]),
  );

  // ---------------------------------------------------------------------------
  // FILTER BAR
  // ---------------------------------------------------------------------------

  Widget _buildFilterBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width > 768 ? 24 : 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: width > 768 ? _buildDesktopFilterBar() : _buildMobileFilterBar(),
    );
  }

  Widget _buildDesktopFilterBar() {
    return Row(children: [
      // Search
      Expanded(
        flex: 3,
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => _set(_vs.copyWith(searchQuery: v)),
          decoration: InputDecoration(
            hintText: 'Search description, actor, module, IP address...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () {
                    _searchCtrl.clear(); _set(_vs.copyWith(searchQuery: ''));
                  }) : null,
            filled: true, fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      const SizedBox(width: 12),

      // Severity / Actor type filter
      _dropdown(
        value: _vs.selectedFilter,
        items: const {
          'all': 'All Events', 'critical': 'Critical', 'warning': 'Warning',
          'info': 'Info', 'user': 'By User', 'system': 'By System', 'cron': 'By Cron',
        },
        onChanged: (v) => _set(_vs.copyWith(selectedFilter: v!)),
      ),
      const SizedBox(width: 12),

      // Module filter
      _dropdown(
        value: _vs.selectedModule,
        items: const {
          'all': 'All Modules', 'billing': 'Billing', 'auth': 'Auth',
          'route': 'Route', 'vehicle': 'Vehicle', 'user_management': 'User Mgmt',
          'wallet': 'Wallet', 'announcement': 'Announcement',
          'attendance': 'Attendance', 'tracking': 'Tracking',
        },
        onChanged: (v) => _set(_vs.copyWith(selectedModule: v!)),
      ),
      const SizedBox(width: 12),

      // Sort
      _dropdown(
        value: _vs.sortBy,
        items: const {
          'timestamp': 'Timestamp', 'severity': 'Severity',
          'module': 'Module', 'action': 'Action', 'actor': 'Actor',
        },
        onChanged: (v) => _set(_vs.copyWith(sortBy: v!)),
      ),
      const SizedBox(width: 8),

      // Sort direction
      IconButton(
        onPressed: () => _set(_vs.copyWith(sortAscending: !_vs.sortAscending)),
        icon: Icon(_vs.sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
        tooltip: _vs.sortAscending ? 'Ascending' : 'Descending',
      ),

      // Date range
      _dateRangeButton(),
    ]);
  }

  Widget _buildMobileFilterBar() {
    return Column(children: [
      // Search
      TextField(
        controller: _searchCtrl,
        onChanged: (v) => _set(_vs.copyWith(searchQuery: v)),
        decoration: InputDecoration(
          hintText: 'Search audit events...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () {
                  _searchCtrl.clear(); _set(_vs.copyWith(searchQuery: ''));
                }) : null,
          filled: true, fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      const SizedBox(height: 12),

      // Filter chips + sort + date
      Row(children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((f) {
                final isSelected = _vs.selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_filterLabel(f)),
                    selected: isSelected,
                    onSelected: (sel) { if (sel) _set(_vs.copyWith(selectedFilter: f)); },
                    selectedColor: _filterChipColor(f).withOpacity(0.2),
                    checkmarkColor: _filterChipColor(f),
                    labelStyle: TextStyle(
                      color: isSelected ? _filterChipColor(f) : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Sort popup
        PopupMenuButton<String>(
          onSelected: (v) => _set(_vs.copyWith(sortBy: v)),
          icon: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.sort),
            Icon(_vs.sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
          ]),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'timestamp', child: Text('Sort by Timestamp')),
            PopupMenuItem(value: 'severity',  child: Text('Sort by Severity')),
            PopupMenuItem(value: 'module',    child: Text('Sort by Module')),
            PopupMenuItem(value: 'action',    child: Text('Sort by Action')),
            PopupMenuItem(value: 'actor',     child: Text('Sort by Actor')),
          ],
        ),
        // Date icon
        IconButton(
          icon: Icon(Icons.calendar_today_outlined,
            color: _vs.dateRange != null ? Colors.blue : Colors.grey[600], size: 22),
          onPressed: _pickDateRange,
          tooltip: 'Filter by date',
        ),
      ]),

      // Active date range chip
      if (_vs.dateRange != null) ...[
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.date_range_rounded, size: 13, color: Colors.blue),
              const SizedBox(width: 5),
              Text(
                '${_fmtDate(_vs.dateRange!.start)} \u2013 ${_fmtDate(_vs.dateRange!.end)}',
                style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => _set(_vs.copyWith(dateRange: null)),
                child: const Icon(Icons.close_rounded, size: 13, color: Colors.blue),
              ),
            ]),
          ),
        ),
      ],
    ]);
  }

  Widget _dropdown({
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.entries.map((e) =>
            DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateRangeButton() {
    final has = _vs.dateRange != null;
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: has ? Colors.blue.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: has ? Colors.blue.withOpacity(0.4) : Colors.grey[300]!),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.date_range_rounded, size: 16,
            color: has ? Colors.blue : Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            has
              ? '${_fmtDate(_vs.dateRange!.start)} \u2013 ${_fmtDate(_vs.dateRange!.end)}'
              : 'Date range',
            style: TextStyle(
              fontSize: 13,
              color: has ? Colors.blue : Colors.grey[700],
              fontWeight: has ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (has) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _set(_vs.copyWith(dateRange: null)),
              child: const Icon(Icons.close_rounded, size: 14, color: Colors.blue),
            ),
          ],
        ]),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIST  (responsive)
  // ---------------------------------------------------------------------------

  Widget _buildList(BuildContext context, List<AuditLog> logs) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) return _buildDesktopTable(context, logs);
      if (constraints.maxWidth > 768)  return _buildTabletList(context, logs);
      return _buildMobileList(context, logs);
    });
  }

  // ── Desktop DataTable ─────────────────────────────────────────────────────

  Widget _buildDesktopTable(BuildContext context, List<AuditLog> logs) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: DataTable(
          columnSpacing: 24,
          horizontalMargin: 24,
          headingRowHeight: 56,
          dataRowMinHeight: 68,
          dataRowMaxHeight: 80,
          columns: const [
            DataColumn(label: Text('Severity', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Module / Action', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actor', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Record', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: logs.map((log) => DataRow(cells: [
            DataCell(_SeverityBadge(log.severity)),
            DataCell(SizedBox(
              width: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(log.description ?? '\u2014',
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            )),
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModuleChip(log.module),
                const SizedBox(height: 4),
                _ActionChip(log.action),
              ],
            )),
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(log.actorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Row(children: [
                  _ActorTypePip(log.actorType),
                  if (log.actorIp != null) ...[
                    const SizedBox(width: 6),
                    Text(log.actorIp!, style: TextStyle(
                      fontSize: 11, color: Colors.grey[500], fontFamily: 'monospace')),
                  ],
                ]),
              ],
            )),
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(log.tableName, style: TextStyle(
                  fontSize: 12, color: Colors.grey[700], fontFamily: 'monospace')),
                if (log.recordId != null)
                  Text('#${log.recordId}', style: TextStyle(
                    fontSize: 11, color: Colors.grey[500], fontFamily: 'monospace')),
              ],
            )),
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_fmtDate(log.createdAt), style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
                Text(_fmtTime(log.createdAt), style: TextStyle(
                  fontSize: 12, color: Colors.grey[500])),
              ],
            )),
            DataCell(IconButton(
              icon: const Icon(Icons.open_in_new_rounded, size: 18, color: Colors.blue),
              tooltip: 'View details',
              onPressed: () => _openDetail(context, log),
            )),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildTabletList(BuildContext context, List<AuditLog> logs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AuditLogCard(log: logs[i], onTap: () => _openDetail(ctx, logs[i])),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<AuditLog> logs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _AuditLogCard(log: logs[i], onTap: () => _openDetail(ctx, logs[i]), isMobile: true),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.manage_search_rounded, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text('No audit events found',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text('Try adjusting your search or filter criteria',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            _searchCtrl.clear();
            _set(const _VS());
          },
          icon: const Icon(Icons.clear_all),
          label: const Text('Clear Filters'),
        ),
      ]),
    );
  }

  // ---------------------------------------------------------------------------
  // DETAIL SHEET
  // ---------------------------------------------------------------------------

  void _openDetail(BuildContext context, AuditLog log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AuditDetailSheet(log: log),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _filterLabel(String f) {
    const m = {'all': 'All', 'critical': 'Critical', 'warning': 'Warning',
                'info': 'Info', 'user': 'User', 'system': 'System', 'cron': 'Cron'};
    return m[f] ?? f;
  }

  Color _filterChipColor(String f) {
    switch (f) {
      case 'critical': return Colors.red;
      case 'warning':  return Colors.orange;
      case 'info':     return Colors.green;
      case 'user':     return Colors.blue;
      case 'system':   return Colors.purple;
      case 'cron':     return Colors.teal;
      default:         return Colors.blue;
    }
  }
}

// =============================================================================
// AUDIT LOG CARD
// =============================================================================

class _AuditLogCard extends StatelessWidget {
  final AuditLog log;
  final VoidCallback onTap;
  final bool isMobile;

  const _AuditLogCard({required this.log, required this.onTap, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final sColor = _severityColor(log.severity);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            // Left severity accent bar
            Positioned(top: 0, bottom: 0, left: 0, width: 4,
              child: ColoredBox(color: sColor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Row 1: badges + timestamp
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SeverityBadge(log.severity),
                  const SizedBox(width: 6),
                  _ModuleChip(log.module),
                  const SizedBox(width: 6),
                  _ActionChip(log.action),
                  const Spacer(),
                  Text(_fmtDate(log.createdAt),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                ]),
                const SizedBox(height: 8),

                // Row 2: description
                Text(log.description ?? '\u2014', style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Row 3: meta
                Wrap(spacing: 16, runSpacing: 6, children: [
                  _metaItem(Icons.person_outline_rounded, log.actorName),
                  _metaItem(Icons.table_chart_outlined,
                    '${log.tableName}${log.recordId != null ? ' #${log.recordId}' : ''}',
                    mono: true),
                  if (log.actorIp != null)
                    _metaItem(Icons.router_outlined, log.actorIp!, mono: true),
                  _metaItem(Icons.access_time_rounded, _fmtTime(log.createdAt)),
                ]),

                // Inline diff preview
                if (log.changes != null) ...[
                  const SizedBox(height: 10),
                  _inlineDiff(log.changes!),
                ],
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text, {bool mono = false}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: Colors.grey[500]),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(
        fontSize: 12, color: Colors.grey[600],
        fontFamily: mono ? 'monospace' : null)),
    ],
  );

  Widget _inlineDiff(Map<String, dynamic> changes) {
    final entry = changes.entries.first;
    final vals  = entry.value as List<dynamic>;
    final before = vals.isNotEmpty      ? '${vals[0]}' : '\u2014';
    final after  = vals.length > 1      ? '${vals[1]}' : '\u2014';
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('${entry.key}:', style: TextStyle(
        fontSize: 11, color: Colors.grey[500], fontFamily: 'monospace')),
      const SizedBox(width: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
        child: Text(before, style: const TextStyle(
          fontSize: 11, color: Colors.red, fontFamily: 'monospace')),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
        child: Text(after, style: const TextStyle(
          fontSize: 11, color: Colors.green, fontFamily: 'monospace')),
      ),
      if (changes.length > 1)
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text('+${changes.length - 1} more',
            style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ),
    ]);
  }
}

// =============================================================================
// DETAIL BOTTOM SHEET
// =============================================================================

class _AuditDetailSheet extends StatelessWidget {
  final AuditLog log;
  const _AuditDetailSheet({required this.log});

  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final isWide = mq.size.width >= 768;

    return DraggableScrollableSheet(
      initialChildSize: isWide ? 0.80 : 0.90,
      minChildSize: 0.50, maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _SeverityBadge(log.severity),
              const SizedBox(width: 8),
              Text('Event #${log.id}', style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.withOpacity(0.4)),
                ),
                child: Row(children: [
                  Icon(Icons.lock_outline_rounded, size: 11, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text('Read Only', style: TextStyle(
                    color: Colors.orange[700], fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact,
              ),
            ]),
          ),
          const Divider(height: 1),

          // Body
          Expanded(
            child: ListView(
              controller: ctrl,
              padding: EdgeInsets.fromLTRB(20, 16, 20, mq.padding.bottom + 24),
              children: [
                _section(context, 'Event Details', [
                  _row('Event ID',  '#${log.id}', mono: true),
                  _row('Module',    log.module),
                  _row('Action',    log.action),
                  _row('Severity',  log.severity),
                  _row('Table',     log.tableName, mono: true),
                  if (log.recordId != null)
                    _row('Record ID', '#${log.recordId}', mono: true),
                  _row('Timestamp',
                    '${_fmtDate(log.createdAt)}  ${_fmtTime(log.createdAt)}'),
                  if (log.organizationId != null)
                    _row('Org ID',  'Org #${log.organizationId}', mono: true),
                ]),
                const SizedBox(height: 14),

                _section(context, 'Actor', [
                  _row('Name',     log.actorName),
                  _row('Type',     log.actorType),
                  if (log.actorIp != null)  _row('IP Address', log.actorIp!, mono: true),
                  if (log.userId  != null)  _row('User ID', 'User #${log.userId}', mono: true),
                  if (log.actorAgent != null) _row('Agent', log.actorAgent!),
                ]),

                if (log.description != null) ...[
                  const SizedBox(height: 14),
                  _section(context, 'Description', [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(log.description!,
                        style: TextStyle(color: Colors.grey[800], height: 1.5)),
                    ),
                  ]),
                ],

                if (log.changes != null) ...[
                  const SizedBox(height: 14),
                  _diffSection(context),
                ] else ...[
                  if (log.oldValues != null) ...[
                    const SizedBox(height: 14),
                    _jsonSection(context, 'Before', log.oldValues!, isOld: true),
                  ],
                  if (log.newValues != null) ...[
                    const SizedBox(height: 14),
                    _jsonSection(context,
                      log.oldValues != null ? 'After' : 'Created With',
                      log.newValues!, isOld: false),
                  ],
                ],
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _section(BuildContext ctx, String title, List<Widget> children) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.grey[50], borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Text(title, style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey[700]))),
        const Divider(height: 1, thickness: 0.5),
        ...children,
      ]),
    );

  Widget _row(String label, String value, {bool mono = false}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 110, child: Text(label, style: TextStyle(
          fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600))),
        Expanded(child: Text(value, style: TextStyle(
          fontSize: 13, color: Colors.grey[800],
          fontFamily: mono ? 'monospace' : null, fontWeight: FontWeight.w500))),
      ]),
    );

  Widget _diffSection(BuildContext ctx) => Container(
    decoration: BoxDecoration(
      color: Colors.grey[50], borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Row(children: [
          const Icon(Icons.compare_arrows_rounded, size: 15, color: Colors.blue),
          const SizedBox(width: 6),
          Text('Changes', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey[700])),
        ])),
      const Divider(height: 1, thickness: 0.5),
      Padding(padding: const EdgeInsets.all(14),
        child: Column(children: log.changes!.entries.map((entry) {
          final vals   = entry.value as List<dynamic>;
          final before = vals.isNotEmpty ? '${vals[0]}' : 'null';
          final after  = vals.length > 1 ? '${vals[1]}' : 'null';
          return Padding(padding: const EdgeInsets.only(bottom: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(entry.key, style: TextStyle(
                fontSize: 12, color: Colors.grey[600],
                fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              Row(children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.withOpacity(0.25))),
                  child: Row(children: [
                    const Text('\u2212', style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w800, fontSize: 13)),
                    const SizedBox(width: 4),
                    Expanded(child: Text(before, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.red, fontFamily: 'monospace', fontSize: 12))),
                  ]),
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey)),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.withOpacity(0.25))),
                  child: Row(children: [
                    const Text('+', style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w800, fontSize: 13)),
                    const SizedBox(width: 4),
                    Expanded(child: Text(after, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.green, fontFamily: 'monospace', fontSize: 12))),
                  ]),
                )),
              ]),
            ]),
          );
        }).toList()),
      ),
    ]),
  );

  Widget _jsonSection(BuildContext ctx, String title,
      Map<String, dynamic> data, {required bool isOld}) {
    final color = isOld ? Colors.red : Colors.green;
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.04), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Text(title, style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: color))),
        const Divider(height: 1, thickness: 0.5),
        Padding(padding: const EdgeInsets.all(14),
          child: Column(children: data.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 140, child: Text(e.key, style: TextStyle(
                fontSize: 12, color: color,
                fontFamily: 'monospace', fontWeight: FontWeight.w700))),
              const Text(': ', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Expanded(child: Text('${e.value}', style: TextStyle(
                fontSize: 12, color: Colors.grey[800], fontFamily: 'monospace'))),
            ]),
          )).toList()),
        ),
      ]),
    );
  }
}

// =============================================================================
// SMALL BADGE WIDGETS
// =============================================================================

class _SeverityBadge extends StatelessWidget {
  final String severity;
  const _SeverityBadge(this.severity);
  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);
    final icon  = severity == 'critical' ? Icons.error_rounded
                : severity == 'warning'  ? Icons.warning_rounded
                                         : Icons.info_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(severity, style: TextStyle(
          color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _ModuleChip extends StatelessWidget {
  final String module;
  const _ModuleChip(this.module);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.blue.withOpacity(0.2))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(_moduleIcon(module), size: 10, color: Colors.blue[700]),
      const SizedBox(width: 3),
      Text(module.replaceAll('_', ' '), style: TextStyle(
        color: Colors.blue[700], fontSize: 10, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ActionChip extends StatelessWidget {
  final String action;
  const _ActionChip(this.action);
  @override
  Widget build(BuildContext context) {
    final color = _actionColor(action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2))),
      child: Text(action.replaceAll('_', ' '), style: TextStyle(
        color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

class _ActorTypePip extends StatelessWidget {
  final String actorType;
  const _ActorTypePip(this.actorType);
  @override
  Widget build(BuildContext context) {
    final color = actorType == 'user' ? Colors.blue
                : actorType == 'system' ? Colors.purple
                : Colors.teal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(actorType, style: TextStyle(
        color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

// =============================================================================
// GLOBAL PURE HELPERS
// =============================================================================

Color _severityColor(String s) {
  switch (s) {
    case 'critical': return Colors.red;
    case 'warning':  return Colors.orange;
    default:         return Colors.green;
  }
}

Color _actionColor(String a) {
  switch (a) {
    case 'created':    return Colors.green;
    case 'deleted':    return Colors.red;
    case 'approved':   return Colors.green[700]!;
    case 'rejected':   return Colors.red[700]!;
    case 'revoked':    return Colors.red;
    case 'logged_in':  return Colors.blue;
    case 'logged_out': return Colors.blue;
    case 'assigned':   return Colors.purple;
    default:           return Colors.orange;
  }
}

IconData _moduleIcon(String m) {
  switch (m) {
    case 'billing':         return Icons.receipt_long_rounded;
    case 'auth':            return Icons.lock_rounded;
    case 'route':           return Icons.route_rounded;
    case 'vehicle':         return Icons.directions_bus_rounded;
    case 'user_management': return Icons.manage_accounts_rounded;
    case 'wallet':          return Icons.account_balance_wallet_rounded;
    case 'announcement':    return Icons.campaign_rounded;
    case 'attendance':      return Icons.fact_check_rounded;
    case 'tracking':        return Icons.my_location_rounded;
    default:                return Icons.layers_rounded;
  }
}

String _fmtDate(DateTime dt) {
  const m = ['Jan','Feb','Mar','Apr','May','Jun',
              'Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
}

String _fmtTime(DateTime dt) =>
  '${dt.hour.toString().padLeft(2,'0')}:'
  '${dt.minute.toString().padLeft(2,'0')}:'
  '${dt.second.toString().padLeft(2,'0')}';