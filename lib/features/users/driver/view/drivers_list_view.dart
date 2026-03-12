import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../core/dependencies/injection_container.dart';
import '../bloc/driver_list_bloc/drivers_list_bloc.dart';
import '../bloc/driver_list_bloc/drivers_list_event.dart';
import '../bloc/driver_list_bloc/drivers_list_state.dart';
import '../model/drivers_list_response.dart';

// =============================================================================
// DRIVERS LIST VIEW
// =============================================================================

class DriversListView extends StatelessWidget {
  const DriversListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocProvider.value(
      value: sl<DriversListBloc>(),
      child: BlocListener<DriversListBloc, DriversListState>(
        listener: _handleStateChanges,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: BlocBuilder<DriversListBloc, DriversListState>(
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
              onPressed: () =>
                  context.read<DriversListBloc>().add(DriversListRefreshed()),
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, DriversListState state) {
    if (state.errorMessage != null &&
        state.status == DriversListStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () =>
                context.read<DriversListBloc>().add(DriversListRefreshed()),
          ),
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context, DriversListState state) {
    if (state.status == DriversListStatus.loading) {
      return const LoadingView(title: 'Loading drivers...');
    }
    if (state.status == DriversListStatus.error) {
      return _buildErrorState(context, state);
    }
    if (state.filteredDrivers.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildDriversList(context, state);
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, DriversListState state) {
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
                  'Drivers Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.filteredDrivers.length} drivers found',
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

  Widget _buildQuickStats(BuildContext context, DriversListState state) {
    final stats = state.driverStats;
    return Row(
      children: [
        _buildStatChip('Total', stats['total'] ?? 0, AppColors.primary),
        const SizedBox(width: 8),
        _buildStatChip('Active', stats['active'] ?? 0, AppColors.success),
        const SizedBox(width: 8),
        _buildStatChip(
          'Independent',
          stats['independent'] ?? 0,
          AppColors.warning,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          'Employed',
          stats['employed'] ?? 0,
          AppColors.info,
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

  Widget _buildFilterAndSearch(BuildContext context, DriversListState state) {
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
    DriversListState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<DriversListBloc>();
    
    return Row(
      children: [
        // Search
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (val) =>
                bloc.add(DriversListSearchQueryChanged(val)),
            decoration: InputDecoration(
              hintText:
                  'Search by name, email, phone, ID, or employment status...',
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
                  child: Text('All Drivers'),
                ),
                DropdownMenuItem(
                  value: 'independent',
                  child: Text('Independent'),
                ),
                DropdownMenuItem(
                  value: 'employed',
                  child: Text('Employed'),
                ),
                DropdownMenuItem(
                  value: 'employed_status',
                  child: Text('Has Employment Status'),
                ),
                DropdownMenuItem(
                  value: 'no_status',
                  child: Text('No Status'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  bloc.add(DriversListFilterChanged(value));
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
                  value: 'created_date',
                  child: Text('Join Date'),
                ),
                DropdownMenuItem(
                  value: 'employment_status',
                  child: Text('Employment Status'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  bloc.add(DriversListSortByChanged(value));
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Sort direction toggle
        IconButton(
          onPressed: () =>
              bloc.add(DriversListSortByChanged(state.sortBy)),
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
    DriversListState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<DriversListBloc>();
    
    return Column(
      children: [
        TextField(
          onChanged: (val) => bloc.add(DriversListSearchQueryChanged(val)),
          decoration: InputDecoration(
            hintText: 'Search drivers...',
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
                              bloc.add(DriversListFilterChanged(filter));
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
              onSelected: (val) => bloc.add(DriversListSortByChanged(val)),
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
                  value: 'created_date',
                  child: Text('Sort by Join Date'),
                ),
                PopupMenuItem(
                  value: 'employment_status',
                  child: Text('Sort by Employment Status'),
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
      case 'independent':
        return 'Independent';
      case 'employed':
        return 'Employed';
      case 'employed_status':
        return 'Has Status';
      case 'no_status':
        return 'No Status';
      default:
        return filter.isNotEmpty
            ? '${filter[0].toUpperCase()}${filter.substring(1)}'
            : filter;
    }
  }

  // ---------------------------------------------------------------------------
  // Drivers List — responsive layout
  // ---------------------------------------------------------------------------

  Widget _buildDriversList(BuildContext context, DriversListState state) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<DriversListBloc>().add(DriversListRefreshed()),
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

  Widget _buildDesktopTable(BuildContext context, DriversListState state) {
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
                'Driver',
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
                'Employment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Joined',
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
          rows: state.filteredDrivers.map((driver) {
            return DataRow(
              cells: [
                // Name + ID
                DataCell(
                  Row(
                    children: [
                      _buildAvatar(driver.name, colorScheme),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              driver.name ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${driver.id ?? '—'}',
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
                        driver.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        driver.phone ?? 'No phone',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Employment status chip
                DataCell(
                  _buildEmploymentStatusChip(driver.employmentStatus),
                ),

                // Independent / Employed badge
                DataCell(_buildTypeBadge(driver.isIndependent)),

                // Join date
                DataCell(
                  Text(
                    _formatDate(driver.createdAt),
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),

                // Actions
                DataCell(
                  ElevatedButton.icon(
                    onPressed: () => _openDriverDetails(context, driver),
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

  Widget _buildTabletGrid(BuildContext context, DriversListState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.filteredDrivers.length,
      itemBuilder: (context, index) {
        final driver = state.filteredDrivers[index];
        return _DriverCard(
          driver: driver,
          onTap: () => _openDriverDetails(context, driver),
        );
      },
    );
  }

  Widget _buildMobileList(BuildContext context, DriversListState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredDrivers.length,
      itemBuilder: (context, index) {
        final driver = state.filteredDrivers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _DriverCard(
            driver: driver,
            onTap: () => _openDriverDetails(context, driver),
            isMobile: true,
          ),
        );
      },
    );
  }

  void _openDriverDetails(BuildContext context, Item driver) {
    context.push(AppRoutes.driverDetails, extra: driver);
  }

  // ---------------------------------------------------------------------------
  // Empty / Error states
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(BuildContext context, DriversListState state) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load drivers',
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
            onPressed: () =>
                context.read<DriversListBloc>().add(DriversListRefreshed()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<DriversListBloc>();
    
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
            'No drivers found',
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
              bloc.add(const DriversListSearchQueryChanged(''));
              bloc.add(const DriversListFilterChanged('all'));
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

  Widget _buildEmploymentStatusChip(String? status) {
    final label = status != null
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : 'Unknown';

    final Color color;
    switch (status?.toLowerCase()) {
      case 'employed':
      case 'active':
        color = AppColors.success;
        break;
      case 'unemployed':
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

  Widget _buildTypeBadge(bool? isIndependent) {
    final isInd = isIndependent == true;
    final color = isInd ? AppColors.warning : AppColors.info;
    final label = isInd ? 'Independent' : 'Employed';
    final icon =
        isInd ? Icons.person_outline : Icons.business_center_outlined;

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
          Icon(icon, size: 12, color: color),
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
// DRIVER CARD COMPONENT
// =============================================================================

class _DriverCard extends StatelessWidget {
  final Item driver;
  final VoidCallback onTap;
  final bool isMobile;

  const _DriverCard({
    required this.driver,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIndependent = driver.isIndependent == true;

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
              // Avatar + name + status indicator
              Row(
                children: [
                  CircleAvatar(
                    radius: isMobile ? 24 : 20,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      (driver.name ?? 'N')[0].toUpperCase(),
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
                          driver.name ?? 'Unknown Driver',
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
                          'ID: ${driver.id ?? '—'}',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Independent / employed indicator
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isIndependent
                          ? AppColors.warning.withOpacity(0.1)
                          : AppColors.info.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIndependent
                          ? Icons.person_outline
                          : Icons.business_center_outlined,
                      size: 16,
                      color: isIndependent ? AppColors.warning : AppColors.info,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: colorScheme.outlineVariant, height: 1),
              const SizedBox(height: 16),

              // Contact info
              _buildInfoRow(
                icon: Icons.email_outlined,
                text: driver.email ?? 'No email',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.phone_outlined,
                text: driver.phone ?? 'No phone',
                colorScheme: colorScheme,
              ),
              if (driver.createdAt != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: 'Joined: ${_formatDate(driver.createdAt)}',
                  colorScheme: colorScheme,
                ),
              ],

              const Spacer(),

              // Status chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCardStatusChip(
                    isIndependent ? 'Independent' : 'Employed',
                    isIndependent ? AppColors.warning : AppColors.info,
                  ),
                  if (driver.employmentStatus != null)
                    _buildCardStatusChip(
                      driver.employmentStatus![0].toUpperCase() +
                          driver.employmentStatus!.substring(1).toLowerCase(),
                      AppColors.success,
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
                      color: Theme.of(context).colorScheme.primary,
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