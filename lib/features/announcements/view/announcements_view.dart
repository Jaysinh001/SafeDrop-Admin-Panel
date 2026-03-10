// =============================================================================
// ANNOUNCEMENTS VIEW
// Design follows the same pattern as DriversListView / AuditLogView.
//
// Schema tables used:
//   announcement  — id, organization_id, author_id, author_role, title, body,
//                   target_type, target_id, priority, is_pinned, send_push,
//                   published_at, expires_at, created_at, updated_at, deleted_at
//   announcement_read — announcement_id, user_id, read_at  (read receipts)
// =============================================================================

import 'package:flutter/material.dart';

// =============================================================================
// DOMAIN MODEL
// =============================================================================

class Announcement {
  final int id;
  final int organizationId;
  final int authorId;
  final String authorName;    // resolved from author_id join
  final String authorRole;    // admin | driver
  final String title;
  final String body;
  final String targetType;    // all | route | role | group
  final int? targetId;
  final String? targetLabel;  // resolved label e.g. "Route 3", "Finance Team"
  final String priority;      // low | normal | high | urgent
  final bool isPinned;
  final bool sendPush;
  final DateTime? publishedAt; // null = draft
  final DateTime? expiresAt;
  final DateTime createdAt;
  final int readCount;         // from announcement_read join

  const Announcement({
    required this.id,
    required this.organizationId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.title,
    required this.body,
    required this.targetType,
    this.targetId,
    this.targetLabel,
    required this.priority,
    required this.isPinned,
    required this.sendPush,
    this.publishedAt,
    this.expiresAt,
    required this.createdAt,
    this.readCount = 0,
  });

  bool get isDraft     => publishedAt == null;
  bool get isExpired   => expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive    => !isDraft && !isExpired;
}

// =============================================================================
// MOCK DATA
// =============================================================================

final List<Announcement> _mockAnnouncements = [
  Announcement(
    id: 44, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'Holiday Schedule — Holi 2026',
    body: 'Dear students and parents,\n\nPlease note that transport services will be suspended on 14th March 2026 (Holi). Normal services resume on 15th March.\n\nKindly make alternate arrangements for that day. For queries, contact the admin office.',
    targetType: 'all', priority: 'high', isPinned: true, sendPush: true,
    publishedAt: DateTime(2026, 3, 5, 9, 0), expiresAt: DateTime(2026, 3, 15),
    createdAt: DateTime(2026, 3, 4, 18, 30), readCount: 312,
  ),
  Announcement(
    id: 43, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'New Route 5 Launch — Effective 10 March',
    body: 'We are happy to announce the launch of Route 5 covering Sector 21, Sector 22, and Sector 23 areas.\n\nStudents in these areas can now register for the new route via the app. The route will operate Monday to Saturday with pickup at 7:00 AM.',
    targetType: 'all', priority: 'normal', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 3, 8, 10, 0), expiresAt: null,
    createdAt: DateTime(2026, 3, 8, 9, 45), readCount: 198,
  ),
  Announcement(
    id: 42, organizationId: 1, authorId: 7, authorName: 'Karan Joshi',
    authorRole: 'driver', title: 'Route 3 Delay — 09 March Morning',
    body: 'Due to road construction near Main Gate, Route 3 will be approximately 15-20 minutes delayed tomorrow morning (09 March). Please be ready earlier than usual or wait patiently at your stop.\n\nSorry for the inconvenience.',
    targetType: 'route', targetId: 3, targetLabel: 'Route 3',
    priority: 'urgent', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 3, 8, 20, 0), expiresAt: DateTime(2026, 3, 9, 12, 0),
    createdAt: DateTime(2026, 3, 8, 19, 50), readCount: 47,
  ),
  Announcement(
    id: 41, organizationId: 1, authorId: 5, authorName: 'Priya Mehta',
    authorRole: 'admin', title: 'Fee Payment Reminder — March 2026',
    body: 'This is a reminder that March 2026 transport fees are due by 10th March 2026.\n\nLate payments will attract a penalty of ₹500 per week as per the penalty rules. Pay via the app under Billing > Pay Now.\n\nFor any billing issues, contact the finance team.',
    targetType: 'all', priority: 'high', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 3, 1, 8, 0), expiresAt: DateTime(2026, 3, 15),
    createdAt: DateTime(2026, 2, 28, 17, 0), readCount: 289,
  ),
  Announcement(
    id: 40, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'Safety Guidelines for Students',
    body: 'Please follow these safety guidelines when using the transport service:\n\n1. Always wear a seatbelt.\n2. Do not distract the driver.\n3. Board and alight only at designated stops.\n4. Keep the vehicle clean.\n5. Carry your ID card at all times.',
    targetType: 'all', priority: 'normal', isPinned: true, sendPush: false,
    publishedAt: DateTime(2026, 2, 20, 10, 0), expiresAt: null,
    createdAt: DateTime(2026, 2, 19, 15, 0), readCount: 401,
  ),
  Announcement(
    id: 39, organizationId: 1, authorId: 5, authorName: 'Priya Mehta',
    authorRole: 'admin', title: 'Vehicle Maintenance — Route 2 Affected',
    body: 'Vehicle MH 12 EF 9012 (Route 2) is scheduled for maintenance on 12th March. A replacement vehicle will operate on that day.\n\nStudents on Route 2 may experience slight delays. We apologise for the inconvenience.',
    targetType: 'route', targetId: 2, targetLabel: 'Route 2',
    priority: 'normal', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 3, 10, 8, 0), expiresAt: DateTime(2026, 3, 13),
    createdAt: DateTime(2026, 3, 9, 22, 0), readCount: 63,
  ),
  Announcement(
    id: 38, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'Q1 2026 Billing Summary Available',
    body: 'The billing summary for Q1 2026 (January – March) is now available in the app under Billing > History. Please review and raise any discrepancies within 7 days.\n\nThis is for reference only. No action required unless you spot an error.',
    targetType: 'role', targetId: 4, targetLabel: 'Finance Team',
    priority: 'low', isPinned: false, sendPush: false,
    publishedAt: DateTime(2026, 3, 10, 11, 0), expiresAt: null,
    createdAt: DateTime(2026, 3, 10, 10, 30), readCount: 12,
  ),
  Announcement(
    id: 37, organizationId: 1, authorId: 5, authorName: 'Priya Mehta',
    authorRole: 'admin', title: 'Annual Day Transport Plan 2026 [DRAFT]',
    body: 'Draft: Transport arrangements for Annual Day on 25th April 2026.\n\nSpecial buses will be arranged from all major stops. Capacity is limited — register interest via the app by 15th April.\n\n[This announcement is still being reviewed — not yet published.]',
    targetType: 'all', priority: 'normal', isPinned: false, sendPush: false,
    publishedAt: null, expiresAt: null,
    createdAt: DateTime(2026, 3, 10, 14, 0), readCount: 0,
  ),
  Announcement(
    id: 36, organizationId: 1, authorId: 8, authorName: 'Amita Singh',
    authorRole: 'driver', title: 'Route 4 Stop Change — Block D Added',
    body: 'Starting 5th March, Route 4 will include a new stop at Block D Main Entrance (between Sector 18 stop and College Gate stop).\n\nStudents boarding from Block D should be at the stop by 7:25 AM.',
    targetType: 'route', targetId: 4, targetLabel: 'Route 4',
    priority: 'normal', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 3, 3, 7, 0), expiresAt: null,
    createdAt: DateTime(2026, 3, 2, 21, 30), readCount: 71,
  ),
  Announcement(
    id: 35, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'App Update Required — v2.4.0',
    body: 'A mandatory app update (v2.4.0) is available on the Play Store and App Store.\n\nThis update includes important security fixes and performance improvements. Please update before 20th February to avoid service disruption.',
    targetType: 'all', priority: 'urgent', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 2, 15, 9, 0), expiresAt: DateTime(2026, 2, 21),
    createdAt: DateTime(2026, 2, 14, 17, 0), readCount: 436,
  ),
  Announcement(
    id: 34, organizationId: 1, authorId: 5, authorName: 'Priya Mehta',
    authorRole: 'admin', title: 'New Penalty Rules Effective March 2026',
    body: 'Please note that updated late payment penalty rules come into effect from 1st March 2026.\n\nTier 1: ₹500 flat after 3-day grace period.\nTier 2: ₹1,000/week after 7 days.\nMaximum cap: ₹5,000.\n\nPay on time to avoid penalties.',
    targetType: 'all', priority: 'high', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 2, 25, 10, 0), expiresAt: null,
    createdAt: DateTime(2026, 2, 24, 16, 0), readCount: 378,
  ),
  Announcement(
    id: 33, organizationId: 1, authorId: 3, authorName: 'Ravi Sharma',
    authorRole: 'admin', title: 'Welcome New Students — Batch 2026',
    body: 'A warm welcome to all new students joining Sunrise University for the 2026 batch!\n\nYour transport registration is now open. Please complete your profile and route assignment via the SafeDrop app.\n\nFor assistance, contact admin@sunriseuniversity.edu.in.',
    targetType: 'all', priority: 'normal', isPinned: false, sendPush: true,
    publishedAt: DateTime(2026, 2, 1, 8, 0), expiresAt: null,
    createdAt: DateTime(2026, 1, 31, 20, 0), readCount: 156,
  ),
];

// =============================================================================
// FILTER / SORT OPTIONS
// =============================================================================

const _filterOptions   = ['all', 'published', 'draft', 'expired', 'pinned'];
const _priorityOptions = ['all', 'urgent', 'high', 'normal', 'low'];
const _targetOptions   = ['all', 'all_users', 'route', 'role', 'group'];

// =============================================================================
// INTERNAL STATE
// =============================================================================

class _VS {
  final String searchQuery;
  final String selectedFilter;   // all | published | draft | expired | pinned
  final String selectedPriority; // all | urgent | high | normal | low
  final String selectedTarget;   // all | all_users | route | role | group
  final String sortBy;           // date | priority | reads | title
  final bool   sortAscending;
  final DateTimeRange? dateRange;

  const _VS({
    this.searchQuery    = '',
    this.selectedFilter = 'all',
    this.selectedPriority = 'all',
    this.selectedTarget   = 'all',
    this.sortBy         = 'date',
    this.sortAscending  = false,
    this.dateRange,
  });

  List<Announcement> get filtered {
    var list = List<Announcement>.from(_mockAnnouncements);

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((a) =>
        a.title.toLowerCase().contains(q) ||
        a.body.toLowerCase().contains(q) ||
        a.authorName.toLowerCase().contains(q) ||
        (a.targetLabel ?? '').toLowerCase().contains(q),
      ).toList();
    }

    switch (selectedFilter) {
      case 'published': list = list.where((a) => a.isActive).toList(); break;
      case 'draft':     list = list.where((a) => a.isDraft).toList(); break;
      case 'expired':   list = list.where((a) => a.isExpired).toList(); break;
      case 'pinned':    list = list.where((a) => a.isPinned).toList(); break;
    }

    if (selectedPriority != 'all') {
      list = list.where((a) => a.priority == selectedPriority).toList();
    }

    if (selectedTarget != 'all') {
      final t = selectedTarget == 'all_users' ? 'all' : selectedTarget;
      list = list.where((a) => a.targetType == t).toList();
    }

    if (dateRange != null) {
      list = list.where((a) =>
        a.createdAt.isAfter(dateRange!.start.subtract(const Duration(seconds: 1))) &&
        a.createdAt.isBefore(dateRange!.end.add(const Duration(days: 1))),
      ).toList();
    }

    list.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case 'priority':
          const o = {'urgent': 0, 'high': 1, 'normal': 2, 'low': 3};
          cmp = (o[a.priority] ?? 4).compareTo(o[b.priority] ?? 4);
          break;
        case 'reads':  cmp = a.readCount.compareTo(b.readCount); break;
        case 'title':  cmp = a.title.compareTo(b.title); break;
        default:       cmp = (a.publishedAt ?? a.createdAt)
                               .compareTo(b.publishedAt ?? b.createdAt);
      }
      return sortAscending ? cmp : -cmp;
    });

    return list;
  }

  Map<String, int> get stats => {
    'total':     _mockAnnouncements.length,
    'published': _mockAnnouncements.where((a) => a.isActive).length,
    'drafts':    _mockAnnouncements.where((a) => a.isDraft).length,
    'pinned':    _mockAnnouncements.where((a) => a.isPinned).length,
    'urgent':    _mockAnnouncements.where((a) => a.priority == 'urgent').length,
  };

  _VS copyWith({
    String? searchQuery, String? selectedFilter, String? selectedPriority,
    String? selectedTarget, String? sortBy, bool? sortAscending,
    Object? dateRange = _s,
  }) => _VS(
    searchQuery:     searchQuery     ?? this.searchQuery,
    selectedFilter:  selectedFilter  ?? this.selectedFilter,
    selectedPriority: selectedPriority ?? this.selectedPriority,
    selectedTarget:  selectedTarget  ?? this.selectedTarget,
    sortBy:          sortBy          ?? this.sortBy,
    sortAscending:   sortAscending   ?? this.sortAscending,
    dateRange: dateRange == _s ? this.dateRange : dateRange as DateTimeRange?,
  );
}
const _s = Object();

// =============================================================================
// MAIN VIEW
// =============================================================================

class AnnouncementsView extends StatefulWidget {
  const AnnouncementsView({super.key});
  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  _VS _vs = const _VS();
  final _searchCtrl = TextEditingController();

  void _set(_VS next) => setState(() => _vs = next);

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _vs.dateRange,
    );
    if (picked != null) _set(_vs.copyWith(dateRange: picked));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _vs.filtered;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(children: [
        _buildHeader(context, filtered.length),
        _buildFilterBar(context),
        Expanded(child: filtered.isEmpty
            ? _buildEmptyState(context)
            : _buildList(context, filtered)),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Announcement'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, int count) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(w > 768 ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Announcements',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Text('$count announcement${count == 1 ? '' : 's'} found',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        ])),
        if (w > 768) _buildQuickStats(),
      ]),
    );
  }

  Widget _buildQuickStats() {
    final s = _vs.stats;
    return Row(children: [
      _chip('Total',     s['total']!,     Colors.blue),
      const SizedBox(width: 8),
      _chip('Published', s['published']!, Colors.green),
      const SizedBox(width: 8),
      _chip('Drafts',    s['drafts']!,    Colors.grey),
      const SizedBox(width: 8),
      _chip('Pinned',    s['pinned']!,    Colors.orange),
      const SizedBox(width: 8),
      _chip('Urgent',    s['urgent']!,    Colors.red),
    ]);
  }

  Widget _chip(String label, int count, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3))),
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
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w > 768 ? 24 : 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: w > 768 ? _buildDesktopBar() : _buildMobileBar(),
    );
  }

  Widget _buildDesktopBar() => Row(children: [
    // Search
    Expanded(flex: 3, child: TextField(
      controller: _searchCtrl,
      onChanged: (v) => _set(_vs.copyWith(searchQuery: v)),
      decoration: InputDecoration(
        hintText: 'Search by title, body, author, or target...',
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
    )),
    const SizedBox(width: 12),

    // Status filter
    _dropdown(
      value: _vs.selectedFilter,
      items: const {
        'all': 'All Status', 'published': 'Published',
        'draft': 'Drafts', 'expired': 'Expired', 'pinned': 'Pinned',
      },
      onChanged: (v) => _set(_vs.copyWith(selectedFilter: v!)),
    ),
    const SizedBox(width: 12),

    // Priority filter
    _dropdown(
      value: _vs.selectedPriority,
      items: const {
        'all': 'All Priority', 'urgent': 'Urgent',
        'high': 'High', 'normal': 'Normal', 'low': 'Low',
      },
      onChanged: (v) => _set(_vs.copyWith(selectedPriority: v!)),
    ),
    const SizedBox(width: 12),

    // Target filter
    _dropdown(
      value: _vs.selectedTarget,
      items: const {
        'all': 'All Targets', 'all_users': 'Everyone',
        'route': 'Route', 'role': 'Role', 'group': 'Group',
      },
      onChanged: (v) => _set(_vs.copyWith(selectedTarget: v!)),
    ),
    const SizedBox(width: 12),

    // Sort
    _dropdown(
      value: _vs.sortBy,
      items: const {
        'date': 'Date', 'priority': 'Priority',
        'reads': 'Read Count', 'title': 'Title',
      },
      onChanged: (v) => _set(_vs.copyWith(sortBy: v!)),
    ),
    const SizedBox(width: 8),

    IconButton(
      onPressed: () => _set(_vs.copyWith(sortAscending: !_vs.sortAscending)),
      icon: Icon(_vs.sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
      tooltip: _vs.sortAscending ? 'Ascending' : 'Descending',
    ),

    _dateRangeButton(),
  ]);

  Widget _buildMobileBar() => Column(children: [
    // Search
    TextField(
      controller: _searchCtrl,
      onChanged: (v) => _set(_vs.copyWith(searchQuery: v)),
      decoration: InputDecoration(
        hintText: 'Search announcements...',
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
    Row(children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _filterOptions.map((f) {
            final isSelected = _vs.selectedFilter == f;
            final color = _filterColor(f);
            return Padding(padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_filterLabel(f)),
                selected: isSelected,
                onSelected: (sel) { if (sel) _set(_vs.copyWith(selectedFilter: f)); },
                selectedColor: color.withOpacity(0.2),
                checkmarkColor: color,
                labelStyle: TextStyle(
                  color: isSelected ? color : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
              ));
          }).toList()),
        ),
      ),
      PopupMenuButton<String>(
        onSelected: (v) => _set(_vs.copyWith(sortBy: v)),
        icon: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.sort),
          Icon(_vs.sortAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
        ]),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'date',     child: Text('Sort by Date')),
          PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
          PopupMenuItem(value: 'reads',    child: Text('Sort by Read Count')),
          PopupMenuItem(value: 'title',    child: Text('Sort by Title')),
        ],
      ),
      IconButton(
        icon: Icon(Icons.calendar_today_outlined,
          color: _vs.dateRange != null ? Colors.blue : Colors.grey[600], size: 22),
        onPressed: _pickDateRange,
        tooltip: 'Filter by date',
      ),
    ]),
    if (_vs.dateRange != null) ...[
      const SizedBox(height: 8),
      Align(alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.date_range_rounded, size: 13, color: Colors.blue),
            const SizedBox(width: 5),
            Text('${_fmtDate(_vs.dateRange!.start)} \u2013 ${_fmtDate(_vs.dateRange!.end)}',
              style: const TextStyle(
                color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => _set(_vs.copyWith(dateRange: null)),
              child: const Icon(Icons.close_rounded, size: 13, color: Colors.blue)),
          ]),
        ),
      ),
    ],
  ]);

  Widget _dropdown({
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: items.entries.map((e) =>
          DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
        onChanged: onChanged,
      ),
    ),
  );

  Widget _dateRangeButton() {
    final has = _vs.dateRange != null;
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: has ? Colors.blue.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: has ? Colors.blue.withOpacity(0.4) : Colors.grey[300]!)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.date_range_rounded, size: 16,
            color: has ? Colors.blue : Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            has ? '${_fmtDate(_vs.dateRange!.start)} \u2013 ${_fmtDate(_vs.dateRange!.end)}'
                : 'Date range',
            style: TextStyle(
              fontSize: 13,
              color: has ? Colors.blue : Colors.grey[700],
              fontWeight: has ? FontWeight.w600 : FontWeight.normal)),
          if (has) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _set(_vs.copyWith(dateRange: null)),
              child: const Icon(Icons.close_rounded, size: 14, color: Colors.blue)),
          ],
        ]),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIST  (responsive)
  // ---------------------------------------------------------------------------

  Widget _buildList(BuildContext context, List<Announcement> items) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) return _buildDesktopTable(context, items);
      if (constraints.maxWidth > 768)  return _buildTabletList(context, items);
      return _buildMobileList(context, items);
    });
  }

  // ── Desktop DataTable ──────────────────────────────────────────────────────

  Widget _buildDesktopTable(BuildContext context, List<Announcement> items) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.1), blurRadius: 10,
            offset: const Offset(0, 4))]),
        child: DataTable(
          columnSpacing: 24, horizontalMargin: 24,
          headingRowHeight: 56, dataRowMinHeight: 72, dataRowMaxHeight: 88,
          columns: const [
            DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Target', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Author', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Reads', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Published', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((a) => DataRow(cells: [
            // Title
            DataCell(SizedBox(width: 240, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  if (a.isPinned) ...[
                    const Icon(Icons.push_pin_rounded, size: 13, color: Colors.orange),
                    const SizedBox(width: 4),
                  ],
                  Expanded(child: Text(a.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                ]),
                const SizedBox(height: 3),
                Text(a.body, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ))),

            // Priority
            DataCell(_PriorityBadge(a.priority)),

            // Target
            DataCell(_TargetChip(a.targetType, label: a.targetLabel)),

            // Author
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(a.authorName, style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                _AuthorRolePip(a.authorRole),
              ],
            )),

            // Status
            DataCell(_StatusBadge(a)),

            // Read count
            DataCell(Row(children: [
              Icon(Icons.visibility_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('${a.readCount}', style: TextStyle(
                fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w600)),
            ])),

            // Published
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(a.publishedAt != null ? _fmtDate(a.publishedAt!) : '—',
                  style: TextStyle(fontSize: 13,
                    color: a.isDraft ? Colors.grey[400] : Colors.grey[800],
                    fontWeight: FontWeight.w500)),
                if (a.expiresAt != null)
                  Text('Exp: ${_fmtDate(a.expiresAt!)}',
                    style: TextStyle(fontSize: 11,
                      color: a.isExpired ? Colors.red[400] : Colors.grey[500])),
              ],
            )),

            // Actions
            DataCell(Row(children: [
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18, color: Colors.blue),
                tooltip: 'View details',
                onPressed: () => _openDetail(context, a)),
              if (a.isDraft)
                IconButton(
                  icon: const Icon(Icons.send_rounded, size: 18, color: Colors.green),
                  tooltip: 'Publish',
                  onPressed: () {}),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  // ── Tablet ─────────────────────────────────────────────────────────────────

  Widget _buildTabletList(BuildContext context, List<Announcement> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AnnouncementCard(
          item: items[i], onTap: () => _openDetail(ctx, items[i]))),
    );
  }

  // ── Mobile ─────────────────────────────────────────────────────────────────

  Widget _buildMobileList(BuildContext context, List<Announcement> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _AnnouncementCard(
          item: items[i], onTap: () => _openDetail(ctx, items[i]), isMobile: true)),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
      const SizedBox(height: 16),
      Text('No announcements found',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
      const SizedBox(height: 8),
      Text('Try adjusting your search or filter criteria',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
        textAlign: TextAlign.center),
      const SizedBox(height: 24),
      ElevatedButton.icon(
        onPressed: () { _searchCtrl.clear(); _set(const _VS()); },
        icon: const Icon(Icons.clear_all),
        label: const Text('Clear Filters')),
    ]));
  }

  // ---------------------------------------------------------------------------
  // CREATE / DETAIL SHEETS
  // ---------------------------------------------------------------------------

  void _openDetail(BuildContext context, Announcement a) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AnnouncementDetailSheet(item: a));
  }

  void _openCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AnnouncementCreateSheet());
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _filterLabel(String f) {
    const m = {'all': 'All', 'published': 'Published', 'draft': 'Drafts',
               'expired': 'Expired', 'pinned': 'Pinned'};
    return m[f] ?? f;
  }

  Color _filterColor(String f) {
    switch (f) {
      case 'published': return Colors.green;
      case 'draft':     return Colors.grey;
      case 'expired':   return Colors.red;
      case 'pinned':    return Colors.orange;
      default:          return Colors.blue;
    }
  }
}

// =============================================================================
// ANNOUNCEMENT CARD
// =============================================================================

class _AnnouncementCard extends StatelessWidget {
  final Announcement item;
  final VoidCallback onTap;
  final bool isMobile;

  const _AnnouncementCard({required this.item, required this.onTap, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final pColor = _priorityColor(item.priority);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            // Left priority accent bar
            Positioned(top: 0, bottom: 0, left: 0, width: 4,
              child: ColoredBox(color: pColor)),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // ── Row 1: badges + pin + chevron ──────────────────────────
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _PriorityBadge(item.priority),
                  const SizedBox(width: 6),
                  _TargetChip(item.targetType, label: item.targetLabel),
                  const SizedBox(width: 6),
                  _StatusBadge(item),
                  const Spacer(),
                  if (item.isPinned)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.push_pin_rounded, size: 15, color: Colors.orange)),
                  if (item.sendPush)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.notifications_active_rounded, size: 15, color: Colors.blue)),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                ]),

                const SizedBox(height: 8),

                // ── Row 2: title ──────────────────────────────────────────
                Text(item.title, style: TextStyle(
                  fontSize: isMobile ? 15 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900]),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),

                // ── Row 3: body preview ──────────────────────────────────
                Text(item.body, style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2, overflow: TextOverflow.ellipsis),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // ── Row 4: meta ──────────────────────────────────────────
                Wrap(spacing: 16, runSpacing: 6, children: [
                  _metaItem(Icons.person_outline_rounded, item.authorName),
                  _metaItem(Icons.visibility_outlined,    '${item.readCount} reads'),
                  _metaItem(Icons.access_time_rounded,
                    item.publishedAt != null
                      ? 'Published ${_fmtDate(item.publishedAt!)}'
                      : 'Draft — not published'),
                  if (item.expiresAt != null)
                    _metaItem(
                      Icons.event_busy_rounded,
                      'Expires ${_fmtDate(item.expiresAt!)}',
                      color: item.isExpired ? Colors.red : Colors.grey[500]!),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text, {Color? color}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color ?? Colors.grey[500]),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(fontSize: 12, color: color ?? Colors.grey[600])),
    ],
  );
}

// =============================================================================
// ANNOUNCEMENT DETAIL SHEET
// =============================================================================

class _AnnouncementDetailSheet extends StatelessWidget {
  final Announcement item;
  const _AnnouncementDetailSheet({required this.item});

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 12),

          // Sheet header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _PriorityBadge(item.priority),
              const SizedBox(width: 8),
              _StatusBadge(item),
              const SizedBox(width: 8),
              if (item.isPinned)
                const Icon(Icons.push_pin_rounded, size: 16, color: Colors.orange),
              const Spacer(),
              if (item.isDraft)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50], borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.4))),
                  child: Row(children: [
                    const Icon(Icons.send_rounded, size: 14, color: Colors.green),
                    const SizedBox(width: 6),
                    Text('Publish', style: TextStyle(
                      color: Colors.green[700], fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact),
            ]),
          ),
          const Divider(height: 1),

          // Content
          Expanded(child: ListView(
            controller: ctrl,
            padding: EdgeInsets.fromLTRB(20, 16, 20, mq.padding.bottom + 24),
            children: [

              // Title
              Text(item.title, style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
              const SizedBox(height: 12),

              // Meta chips row
              Wrap(spacing: 8, runSpacing: 8, children: [
                _TargetChip(item.targetType, label: item.targetLabel),
                _metaChip(Icons.person_rounded, item.authorName, Colors.grey),
                _metaChip(Icons.badge_rounded, item.authorRole, Colors.grey),
                if (item.sendPush)
                  _metaChip(Icons.notifications_active_rounded, 'Push Sent', Colors.blue),
                _metaChip(Icons.visibility_outlined, '${item.readCount} reads', Colors.grey),
              ]),
              const SizedBox(height: 16),

              // Body text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50], borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!)),
                child: Text(item.body, style: TextStyle(
                  fontSize: 14, color: Colors.grey[800], height: 1.6)),
              ),
              const SizedBox(height: 16),

              // Details grid
              _section(context, 'Details', [
                _row(context, 'Announcement ID', '#${item.id}'),
                _row(context, 'Priority',        item.priority),
                _row(context, 'Target Type',     item.targetType),
                if (item.targetLabel != null)
                  _row(context, 'Target',        item.targetLabel!),
                _row(context, 'Author',          item.authorName),
                _row(context, 'Author Role',     item.authorRole),
                _row(context, 'Is Pinned',       item.isPinned ? 'Yes' : 'No'),
                _row(context, 'Push Notification', item.sendPush ? 'Sent' : 'Not sent'),
                _row(context, 'Published At',
                  item.publishedAt != null
                    ? '${_fmtDate(item.publishedAt!)}  ${_fmtTime(item.publishedAt!)}'
                    : 'Not published (draft)'),
                if (item.expiresAt != null)
                  _row(context, 'Expires At',
                    '${_fmtDate(item.expiresAt!)}  ${_fmtTime(item.expiresAt!)}'),
                _row(context, 'Created At',
                  '${_fmtDate(item.createdAt)}  ${_fmtTime(item.createdAt)}'),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _metaChip(IconData icon, String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.2))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _section(BuildContext ctx, String title, List<Widget> children) => Container(
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

  Widget _row(BuildContext ctx, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 140, child: Text(label, style: TextStyle(
        fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600))),
      Expanded(child: Text(value, style: TextStyle(
        fontSize: 13, color: Colors.grey[800], fontWeight: FontWeight.w500))),
    ]),
  );
}

// =============================================================================
// CREATE ANNOUNCEMENT SHEET
// =============================================================================

class _AnnouncementCreateSheet extends StatefulWidget {
  const _AnnouncementCreateSheet();
  @override
  State<_AnnouncementCreateSheet> createState() => _AnnouncementCreateSheetState();
}

class _AnnouncementCreateSheetState extends State<_AnnouncementCreateSheet> {
  final _titleCtrl  = TextEditingController();
  final _bodyCtrl   = TextEditingController();
  String _priority  = 'normal';
  String _targetType = 'all';
  bool   _sendPush  = true;
  bool   _isPinned  = false;

  @override
  void dispose() {
    _titleCtrl.dispose(); _bodyCtrl.dispose(); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.90, minChildSize: 0.60, maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 12),

          // Header
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Icon(Icons.campaign_rounded, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text('New Announcement', style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact),
            ])),
          const Divider(height: 1),

          Expanded(child: ListView(
            controller: ctrl,
            padding: EdgeInsets.fromLTRB(20, 16, 20, mq.padding.bottom + 24),
            children: [
              // Title
              Text('Title', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: Colors.grey[600], letterSpacing: 0.4)),
              const SizedBox(height: 6),
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter announcement title...',
                  filled: true, fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!))),
              ),
              const SizedBox(height: 16),

              // Body
              Text('Body', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: Colors.grey[600], letterSpacing: 0.4)),
              const SizedBox(height: 6),
              TextField(
                controller: _bodyCtrl, maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your announcement here...',
                  filled: true, fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!))),
              ),
              const SizedBox(height: 16),

              // Priority + Target row
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Priority', style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: Colors.grey[600], letterSpacing: 0.4)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50], borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _priority, isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'low',    child: Text('Low')),
                          DropdownMenuItem(value: 'normal', child: Text('Normal')),
                          DropdownMenuItem(value: 'high',   child: Text('High')),
                          DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                        ],
                        onChanged: (v) => setState(() => _priority = v!),
                      ),
                    ),
                  ),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Target', style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: Colors.grey[600], letterSpacing: 0.4)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50], borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _targetType, isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'all',   child: Text('Everyone')),
                          DropdownMenuItem(value: 'route', child: Text('Specific Route')),
                          DropdownMenuItem(value: 'role',  child: Text('Specific Role')),
                          DropdownMenuItem(value: 'group', child: Text('Permission Group')),
                        ],
                        onChanged: (v) => setState(() => _targetType = v!),
                      ),
                    ),
                  ),
                ])),
              ]),
              const SizedBox(height: 16),

              // Toggles
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50], borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!)),
                child: Column(children: [
                  SwitchListTile(
                    value: _sendPush,
                    onChanged: (v) => setState(() => _sendPush = v),
                    title: const Text('Send Push Notification',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('Notify users via FCM',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    secondary: const Icon(Icons.notifications_active_rounded,
                      color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _isPinned,
                    onChanged: (v) => setState(() => _isPinned = v),
                    title: const Text('Pin Announcement',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('Keep at top of the feed',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    secondary: const Icon(Icons.push_pin_rounded, color: Colors.orange),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.save_outlined, size: 16),
                  label: const Text('Save as Draft'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Publish Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                )),
              ]),
            ],
          )),
        ]),
      ),
    );
  }
}

// =============================================================================
// SMALL BADGE WIDGETS
// =============================================================================

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge(this.priority);
  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(priority);
    final icon  = priority == 'urgent' ? Icons.priority_high_rounded
                : priority == 'high'   ? Icons.keyboard_double_arrow_up_rounded
                : priority == 'normal' ? Icons.remove_rounded
                :                        Icons.keyboard_double_arrow_down_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(priority, style: TextStyle(
          color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Announcement item;
  const _StatusBadge(this.item);
  @override
  Widget build(BuildContext context) {
    final String label;
    final Color  color;
    final IconData icon;

    if (item.isDraft) {
      label = 'draft'; color = Colors.grey; icon = Icons.edit_note_rounded;
    } else if (item.isExpired) {
      label = 'expired'; color = Colors.red; icon = Icons.event_busy_rounded;
    } else {
      label = 'published'; color = Colors.green; icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(
          color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _TargetChip extends StatelessWidget {
  final String targetType;
  final String? label;
  const _TargetChip(this.targetType, {this.label});
  @override
  Widget build(BuildContext context) {
    final icon = targetType == 'route' ? Icons.route_rounded
               : targetType == 'role'  ? Icons.badge_rounded
               : targetType == 'group' ? Icons.group_rounded
               :                         Icons.people_alt_rounded;
    final display = label ?? (targetType == 'all' ? 'Everyone' : targetType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.08), borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.purple.withOpacity(0.2))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: Colors.purple[700]),
        const SizedBox(width: 3),
        Text(display, style: TextStyle(
          color: Colors.purple[700], fontSize: 10, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _AuthorRolePip extends StatelessWidget {
  final String role;
  const _AuthorRolePip(this.role);
  @override
  Widget build(BuildContext context) {
    final color = role == 'admin' ? Colors.blue : Colors.teal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(role, style: TextStyle(
        color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

// =============================================================================
// GLOBAL PURE HELPERS
// =============================================================================

Color _priorityColor(String p) {
  switch (p) {
    case 'urgent': return Colors.red;
    case 'high':   return Colors.orange;
    case 'low':    return Colors.grey;
    default:       return Colors.blue;
  }
}

String _fmtDate(DateTime dt) {
  const m = ['Jan','Feb','Mar','Apr','May','Jun',
              'Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
}

String _fmtTime(DateTime dt) =>
  '${dt.hour.toString().padLeft(2,'0')}:'
  '${dt.minute.toString().padLeft(2,'0')}';