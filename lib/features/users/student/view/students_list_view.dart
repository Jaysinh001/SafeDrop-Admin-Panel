import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../core/dependencies/injection_container.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/student_list_bloc/students_list_bloc.dart';
import '../bloc/student_list_bloc/students_list_event.dart';
import '../bloc/student_list_bloc/students_list_state.dart';
import '../model/students_list_response.dart';

class StudentsListView extends StatelessWidget {
  const StudentsListView({super.key});

  void _openStudentDetails(BuildContext context, Item student) {
    // context.push(AppRoutes.studentDetails, extra: student);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening details for ${student.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocProvider(
      create: (context) =>
          sl<StudentsListBloc>()..add(StudentsListLoaded()),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Column(
          children: [
            _buildHeader(context),
            _buildFilterAndSearch(context),
            Expanded(
              child: BlocBuilder<StudentsListBloc, StudentsListState>(
                builder: (context, state) {
                  if (state.status == StudentsListStatus.loading) {
                    return const LoadingView(title: 'Loading students...');
                  }
                  if (state.status == StudentsListStatus.error) {
                    return _buildErrorState(context, state.errorMessage);
                  }
                  if (state.filteredStudents.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildStudentsList(context);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<StudentsListBloc, StudentsListState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => context
                  .read<StudentsListBloc>()
                  .add(StudentsListRefreshRequested()),
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.all(width > 768 ? 24 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.2,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Students Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                BlocBuilder<StudentsListBloc, StudentsListState>(
                  builder: (context, state) {
                    return Text(
                      '${state.filteredStudents.length} students found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (width > 768) _buildQuickStats(context),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return Row(
          children: [
            _buildStatChip(context, 'Total', state.totalStudents, AppColors.primary),
            const SizedBox(width: 8),
            _buildStatChip(context, 'Active', state.activeStudents, AppColors.success),
            const SizedBox(width: 8),
            _buildStatChip(context, 'Inactive', state.inactiveStudents, AppColors.error),
            const SizedBox(width: 8),
            _buildStatChip(context, 'Enrolled', state.enrolledStudents, AppColors.info),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
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

  // ---------------------------------------------------------------------------
  // Filter & Search Bar
  // ---------------------------------------------------------------------------

  Widget _buildFilterAndSearch(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width > 768 ? 24 : 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 0.2,
          ),
        ),
      ),
      child: width > 768
          ? _buildDesktopFilterBar(context)
          : _buildMobileFilterBar(context),
    );
  }

  Widget _buildDesktopFilterBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return Row(
          children: [
            // Search
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (value) => context
                    .read<StudentsListBloc>()
                    .add(StudentsListSearchQueryChanged(value)),
                decoration: InputDecoration(
                  hintText:
                      'Search by name, email, phone, ID, or enrollment status...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Filter dropdown
            _buildDropdownContainer(
              context: context,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Students')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'inactive',
                      child: Text('Inactive'),
                    ),
                    DropdownMenuItem(
                      value: 'enrolled',
                      child: Text('Enrolled'),
                    ),
                    DropdownMenuItem(
                      value: 'unenrolled',
                      child: Text('Unenrolled'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<StudentsListBloc>()
                          .add(StudentsListFilterChanged(value));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Sort dropdown
            _buildDropdownContainer(
              context: context,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.sortBy,
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(value: 'id', child: Text('ID')),
                    DropdownMenuItem(
                      value: 'admission_date',
                      child: Text('Admission Date'),
                    ),
                    DropdownMenuItem(
                      value: 'enrollment_status',
                      child: Text('Enrollment Status'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<StudentsListBloc>()
                          .add(StudentsListSortChanged(value));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Sort direction toggle
            IconButton(
              onPressed: () => context
                  .read<StudentsListBloc>()
                  .add(StudentsListSortChanged(state.sortBy)),
              icon: Icon(
                state.sortAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
              ),
              tooltip: state.sortAscending ? 'Ascending' : 'Descending',
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownContainer({
    required BuildContext context,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: child,
    );
  }

  Widget _buildMobileFilterBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              onChanged: (value) => context
                  .read<StudentsListBloc>()
                  .add(StudentsListSearchQueryChanged(value)),
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...['all', 'active', 'inactive', 'enrolled', 'unenrolled']
                            .map((filter) {
                          final isSelected = state.selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(_getFilterDisplayName(filter)),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<StudentsListBloc>().add(
                                    StudentsListFilterChanged(filter),
                                  );
                                }
                              },
                              selectedColor: colorScheme.primary.withOpacity(0.2),
                              checkmarkColor: colorScheme.primary,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => context
                      .read<StudentsListBloc>()
                      .add(StudentsListSortChanged(value)),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort),
                      Icon(
                        state.sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                      ),
                    ],
                  ),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                    PopupMenuItem(value: 'id', child: Text('Sort by ID')),
                    PopupMenuItem(
                      value: 'admission_date',
                      child: Text('Sort by Admission Date'),
                    ),
                    PopupMenuItem(
                      value: 'enrollment_status',
                      child: Text('Sort by Enrollment Status'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All';
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'enrolled':
        return 'Enrolled';
      case 'unenrolled':
        return 'Unenrolled';
      default:
        if (filter.isEmpty) return '';
        return filter[0].toUpperCase() + filter.substring(1).toLowerCase();
    }
  }

  // ---------------------------------------------------------------------------
  // Students List — responsive layout
  // ---------------------------------------------------------------------------

  Widget _buildStudentsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<StudentsListBloc>().add(StudentsListRefreshRequested()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return _buildDesktopTable(context);
          } else if (constraints.maxWidth > 768) {
            return _buildTabletGrid(context);
          } else {
            return _buildMobileList(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 24,
              headingRowHeight: 56,
              dataRowMinHeight: 72,
              dataRowMaxHeight: 72,
              columns: [
                DataColumn(
                  label: Text(
                    'Student',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Contact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Phone',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Admission Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
              rows: state.filteredStudents.map((student) {
                return DataRow(
                  cells: [
                    // Student name + ID
                    DataCell(
                      Row(
                        children: [
                          _buildAvatar(student.name, colorScheme),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  student.name ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'ID: ${student.id ?? '—'}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Email
                    DataCell(
                      Text(
                        student.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Phone
                    DataCell(
                      Text(
                        student.phone ?? 'No phone',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // Admission date
                    DataCell(
                      Text(
                        student.admissionDate != null
                            ? _formatDate(student.admissionDate!)
                            : '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    // Enrollment status chip
                    DataCell(
                      _buildEnrollmentStatusChip(student.enrollmentStatus),
                    ),

                    // Actions
                    DataCell(
                      ElevatedButton.icon(
                        onPressed: () =>
                            _openStudentDetails(context, student),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletGrid(BuildContext context) {
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.filteredStudents.length,
          itemBuilder: (context, index) {
            final student = state.filteredStudents[index];
            return _StudentCard(
              student: student,
              onTap: () => _openStudentDetails(context, student),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return BlocBuilder<StudentsListBloc, StudentsListState>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.filteredStudents.length,
          itemBuilder: (context, index) {
            final student = state.filteredStudents[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StudentCard(
                student: student,
                onTap: () => _openStudentDetails(context, student),
                isMobile: true,
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Empty / Error States
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<StudentsListBloc>()
                  .add(const StudentsListSearchQueryChanged(''));
              context
                  .read<StudentsListBloc>()
                  .add(const StudentsListFilterChanged('all'));
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context
                .read<StudentsListBloc>()
                .add(StudentsListRefreshRequested()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------

  Widget _buildAvatar(String? name, ColorScheme colorScheme) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        (name ?? 'N')[0].toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEnrollmentStatusChip(String? status) {
    final label = status != null
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : 'Unknown';

    final Color color;
    switch (status?.toLowerCase()) {
      case 'active':
      case 'enrolled':
        color = AppColors.success;
        break;
      case 'inactive':
        color = AppColors.error;
        break;
      default:
        color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// =============================================================================
// STUDENT CARD COMPONENT
// =============================================================================

class _StudentCard extends StatelessWidget {
  final Item student;
  final VoidCallback onTap;
  final bool isMobile;

  const _StudentCard({
    required this.student,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + name + ID row
              Row(
                children: [
                  CircleAvatar(
                    radius: isMobile ? 24 : 20,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      (student.name ?? 'N')[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: isMobile ? 18 : 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name ?? 'Unknown Student',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 16 : 14,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${student.id ?? '—'}',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: isMobile ? 12 : 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Email
              if (student.email != null) ...[
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  text: student.email!,
                  isMobile: isMobile,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 6),
              ],

              // Phone
              if (student.phone != null) ...[
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  text: student.phone!,
                  isMobile: isMobile,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
              ],

              // Admission date
              if (student.admissionDate != null) ...[
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: 'Admitted: ${_formatDate(student.admissionDate!)}',
                  isMobile: isMobile,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
              ],

              const Spacer(),

              // Enrollment status chip
              _buildEnrollmentStatusChip(student.enrollmentStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required bool isMobile,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 13 : 12,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEnrollmentStatusChip(String? status) {
    final label = status != null
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : 'Unknown';

    final Color color;
    switch (status?.toLowerCase()) {
      case 'active':
      case 'enrolled':
        color = AppColors.success;
        break;
      case 'inactive':
        color = AppColors.error;
        break;
      default:
        color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            color == AppColors.info ? Icons.help_outline : Icons.circle,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}