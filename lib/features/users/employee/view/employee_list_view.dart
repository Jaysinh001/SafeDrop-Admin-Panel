import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../core/dependencies/injection_container.dart';
import '../employee_list_bloc/employee_list_bloc.dart';
import '../model/employee_list_response.dart';


// =============================================================================
// EMPLOYEES LIST VIEW
// =============================================================================

class EmployeesListView extends StatelessWidget {
  const EmployeesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: sl<EmployeesListBloc>(),
      child: BlocListener<EmployeesListBloc, EmployeesListState>(
        listener: _handleStateChanges,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: BlocBuilder<EmployeesListBloc, EmployeesListState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(context, state),
                  _buildFilterAndSearch(context, state),
                  Expanded(child: _buildBody(context, state)),
                ],
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: () => context
                  .read<EmployeesListBloc>()
                  .add(const EmployeesListRefreshRequested()),
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    EmployeesListState state,
  ) {
    if (state.errorMessage != null &&
        state.status == EmployeesListStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => context
                .read<EmployeesListBloc>()
                .add(const EmployeesListRefreshRequested()),
          ),
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context, EmployeesListState state) {
    if (state.status == EmployeesListStatus.loading) {
      return const LoadingView(title: 'Loading employees...');
    }
    if (state.status == EmployeesListStatus.error) {
      return _buildErrorState(context, state);
    }
    if (state.filteredEmployees.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildEmployeesList(context, state);
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, EmployeesListState state) {
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
                  'Employees Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.filteredEmployees.length} employees found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (width > 768) _buildQuickStats(context, state),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, EmployeesListState state) {
    final stats = state.employeeStats;
    return Row(
      children: [
        _buildStatChip(
          'Total',
          stats['total'] ?? 0,
          Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          'Active',
          stats['active'] ?? 0,
          AppColors.success,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          'Inactive',
          stats['inactive'] ?? 0,
          AppColors.error,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          'On Leave',
          stats['on_leave'] ?? 0,
          AppColors.warning,
        ),
      ],
    );
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

  // ---------------------------------------------------------------------------
  // Filter & Search Bar
  // ---------------------------------------------------------------------------

  Widget _buildFilterAndSearch(
    BuildContext context,
    EmployeesListState state,
  ) {
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
          ? _buildDesktopFilterBar(context, state)
          : _buildMobileFilterBar(context, state),
    );
  }

  Widget _buildDesktopFilterBar(
    BuildContext context,
    EmployeesListState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<EmployeesListBloc>();

    return Row(
      children: [
        // Search
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (val) =>
                bloc.add(EmployeesListSearchQueryChanged(val)),
            decoration: InputDecoration(
              hintText:
                  'Search by name, email, phone, department, or designation...',
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
              hint: const Text('Filter'),
              items: const [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All Employees'),
                ),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(
                  value: 'on_leave',
                  child: Text('On Leave'),
                ),
                DropdownMenuItem(
                  value: 'full_time',
                  child: Text('Full-time'),
                ),
                DropdownMenuItem(
                  value: 'part_time',
                  child: Text('Part-time'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  bloc.add(EmployeesListFilterChanged(value));
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
              hint: const Text('Sort'),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'email', child: Text('Email')),
                DropdownMenuItem(
                  value: 'join_date',
                  child: Text('Join Date'),
                ),
                DropdownMenuItem(
                  value: 'department',
                  child: Text('Department'),
                ),
                DropdownMenuItem(
                  value: 'designation',
                  child: Text('Designation'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  bloc.add(EmployeesListSortChanged(value));
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Sort direction toggle
        IconButton(
          onPressed: () => bloc.add(EmployeesListSortChanged(state.sortBy)),
          icon: Icon(
            state.sortAscending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          tooltip: state.sortAscending ? 'Ascending' : 'Descending',
        ),
      ],
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

  Widget _buildMobileFilterBar(
    BuildContext context,
    EmployeesListState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<EmployeesListBloc>();

    return Column(
      children: [
        TextField(
          onChanged: (val) => bloc.add(EmployeesListSearchQueryChanged(val)),
          decoration: InputDecoration(
            hintText: 'Search employees...',
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
                    ...bloc.filterOptions.map((filter) {
                      final isSelected = state.selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getFilterDisplayName(filter)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              bloc.add(EmployeesListFilterChanged(filter));
                            }
                          },
                          selectedColor:
                              colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: colorScheme.primary,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (val) => bloc.add(EmployeesListSortChanged(val)),
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
                PopupMenuItem(
                  value: 'name',
                  child: Text('Sort by Name'),
                ),
                PopupMenuItem(
                  value: 'email',
                  child: Text('Sort by Email'),
                ),
                PopupMenuItem(
                  value: 'join_date',
                  child: Text('Sort by Join Date'),
                ),
                PopupMenuItem(
                  value: 'department',
                  child: Text('Sort by Department'),
                ),
                PopupMenuItem(
                  value: 'designation',
                  child: Text('Sort by Designation'),
                ),
              ],
            ),
          ],
        ),
      ],
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
      case 'on_leave':
        return 'On Leave';
      case 'full_time':
        return 'Full-time';
      case 'part_time':
        return 'Part-time';
      default:
        return filter.isNotEmpty
            ? '${filter[0].toUpperCase()}${filter.substring(1)}'
            : filter;
    }
  }

  // ---------------------------------------------------------------------------
  // Employees List — responsive layout
  // ---------------------------------------------------------------------------

  Widget _buildEmployeesList(BuildContext context, EmployeesListState state) {
    return RefreshIndicator(
      onRefresh: () async => context
          .read<EmployeesListBloc>()
          .add(const EmployeesListRefreshRequested()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return _buildDesktopTable(context, state);
          } else if (constraints.maxWidth > 768) {
            return _buildTabletGrid(context, state);
          } else {
            return _buildMobileList(context, state);
          }
        },
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, EmployeesListState state) {
    final colorScheme = Theme.of(context).colorScheme;

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
                'Employee',
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
                'Department',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Designation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Employment Type',
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
                'Join Date',
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
          rows: state.filteredEmployees.map((employee) {
            return DataRow(
              cells: [
                // Name + ID
                DataCell(
                  Row(
                    children: [
                      _buildAvatar(employee.firstName, colorScheme),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              employee.firstName != null && employee.lastName != null
                                  ? '${employee.firstName} ${employee.lastName}'
                                  : 'Unknown Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${employee.id}',
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

                // Email + Phone
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        employee.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        employee.phoneNumber ?? 'No phone',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Department
                DataCell(
                  Text(
                    employee.departmentName ?? 'N/A',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // Designation
                DataCell(
                  Text(
                    employee.designation ?? 'N/A',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // Employment Type
                DataCell(
                  _buildEmploymentTypeChip(
                    employee.employmentType,
                    colorScheme,
                  ),
                ),

                // Status chip
                DataCell(
                  _buildStatusChip(employee.status, colorScheme),
                ),

                // Join date
                DataCell(
                  Text(
                    _formatDate(employee.joinDate),
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),

                // Actions
                DataCell(
                  ElevatedButton.icon(
                    onPressed: () =>
                        _openEmployeeDetails(context, employee),
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
  }

  Widget _buildTabletGrid(BuildContext context, EmployeesListState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = state.filteredEmployees[index];
        return _EmployeeCard(
          employee: employee,
          onTap: () => _openEmployeeDetails(context, employee),
        );
      },
    );
  }

  Widget _buildMobileList(BuildContext context, EmployeesListState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = state.filteredEmployees[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _EmployeeCard(
            employee: employee,
            onTap: () => _openEmployeeDetails(context, employee),
            isMobile: true,
          ),
        );
      },
    );
  }

  void _openEmployeeDetails(BuildContext context, Datum employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening details for ${employee.firstName} ${employee.lastName}...'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Implement navigation when employee details route is ready
    // context.push(AppRoutes.employeeDetails, extra: employee);
  }

  // ---------------------------------------------------------------------------
  // Empty / Error states
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(BuildContext context, EmployeesListState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load employees',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ?? 'An unexpected error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context
                .read<EmployeesListBloc>()
                .add(const EmployeesListRefreshRequested()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<EmployeesListBloc>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No employees found',
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
              bloc.add(const EmployeesListSearchQueryChanged(''));
              bloc.add(const EmployeesListFilterChanged('all'));
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
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

  Widget _buildStatusChip(String? status, ColorScheme colorScheme) {
    final label = status ?? 'Unknown';
    final color = _getStatusColor(status);

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

  Widget _buildEmploymentTypeChip(String? type, ColorScheme colorScheme) {
    final label = type ?? 'N/A';
    final color = type?.toLowerCase() == 'full-time'
        ? AppColors.success
        : AppColors.info;

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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.error;
      case 'on leave':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 30) return '${difference.inDays}d ago';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// =============================================================================
// EMPLOYEE CARD COMPONENT
// =============================================================================

class _EmployeeCard extends StatelessWidget {
  final Datum employee;
  final VoidCallback onTap;
  final bool isMobile;

  const _EmployeeCard({
    required this.employee,
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
            // ✅ FIXED: Use mainAxisSize.min to prevent flex issues
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar + name + ID
              Row(
                children: [
                  CircleAvatar(
                    radius: isMobile ? 24 : 20,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      (employee.firstName ?? 'N')[0].toUpperCase(),
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
                          employee.firstName != null && employee.lastName != null
                              ? '${employee.firstName} ${employee.lastName}'
                              : 'Unknown Name',
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
                          'ID: ${employee.id}',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
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
              Divider(color: colorScheme.outlineVariant, height: 1),
              const SizedBox(height: 12),

              // Contact info
              _buildInfoRow(
                icon: Icons.email_outlined,
                text: employee.email ?? 'No email',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.phone_outlined,
                text: employee.phoneNumber ?? 'No phone',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.business_outlined,
                text: employee.departmentName ?? 'N/A',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.work_outline,
                text: employee.designation ?? 'N/A',
                colorScheme: colorScheme,
              ),

        
              // Status chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCardStatusChip(
                    employee.status ?? 'Unknown',
                    _getStatusColor(employee.status),
                  ),
                  _buildCardStatusChip(
                    employee.employmentType ?? 'N/A',
                    employee.employmentType?.toLowerCase() == 'full-time'
                        ? AppColors.success
                        : AppColors.info,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // View Details button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Full Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
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
              color: colorScheme.onSurface,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCardStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.error;
      case 'on leave':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  // String _formatDate(DateTime? date) {
  //   if (date == null) return 'N/A';
  //   final now = DateTime.now();
  //   final difference = now.difference(date);
  //   if (difference.inDays == 0) return 'Today';
  //   if (difference.inDays == 1) return 'Yesterday';
  //   if (difference.inDays < 30) return '${difference.inDays}d ago';
  //   return '${date.day.toString().padLeft(2, '0')}/'
  //       '${date.month.toString().padLeft(2, '0')}/'
  //       '${date.year}';
  // }
}