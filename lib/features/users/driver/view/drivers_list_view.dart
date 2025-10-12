import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../../../shared/widgets/loading_view.dart';
import '../controller/drivers_list_controller.dart';
import '../model/drivers_list_response.dart';

// =============================================================================
// DRIVERS LIST VIEW
// =============================================================================

class DriversListView extends GetView<DriversListController> {
  const DriversListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterAndSearch(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const LoadingView(title: 'Loading drivers...');
              }

              if (controller.filteredDrivers.isEmpty) {
                return _buildEmptyState();
              }

              return _buildDriversList(context);
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
                  'Drivers Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${controller.filteredDrivers.length} drivers found',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
      final stats = controller.driverStats;
      return Row(
        children: [
          _buildStatChip('Total', stats['total']!, Colors.blue),
          const SizedBox(width: 8),
          _buildStatChip('Active', stats['active']!, Colors.green),
          const SizedBox(width: 8),
          _buildStatChip(
            'Bank Details',
            stats['with_bank_details']!,
            Colors.orange,
          ),
          const SizedBox(width: 8),
          _buildStatChip('MPIN Set', stats['mpin_set']!, Colors.purple),
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
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
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
              hintText: 'Search by name, email, phone, or ID...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
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
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedFilter,
                hint: const Text('Filter'),
                items: [
                  const DropdownMenuItem(
                    value: 'all',
                    child: Text('All Drivers'),
                  ),
                  const DropdownMenuItem(
                    value: 'active',
                    child: Text('Active'),
                  ),
                  const DropdownMenuItem(
                    value: 'with_bank_details',
                    child: Text('With Bank Details'),
                  ),
                  const DropdownMenuItem(
                    value: 'without_bank_details',
                    child: Text('Without Bank Details'),
                  ),
                  const DropdownMenuItem(
                    value: 'mpin_set',
                    child: Text('MPIN Set'),
                  ),
                  const DropdownMenuItem(
                    value: 'mpin_not_set',
                    child: Text('MPIN Not Set'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controller.setFilter(value);
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Sort dropdown
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.sortBy,
                hint: const Text('Sort'),
                items: const [
                  DropdownMenuItem(value: 'name', child: Text('Name')),
                  DropdownMenuItem(value: 'email', child: Text('Email')),
                  DropdownMenuItem(
                    value: 'created_date',
                    child: Text('Join Date'),
                  ),
                  DropdownMenuItem(
                    value: 'unique_code',
                    child: Text('Code ID'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controller.setSortBy(value);
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Sort direction
        Obx(
          () => IconButton(
            onPressed: () => controller.setSortBy(controller.sortBy),
            icon: Icon(
              controller.sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            tooltip: controller.sortAscending ? 'Ascending' : 'Descending',
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
            hintText: 'Search drivers...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
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

        // Filter and Sort chips
        Row(
          children: [
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Filter chips
                      ...controller.filterOptions.map((filter) {
                        final isSelected = controller.selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_getFilterDisplayName(filter)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) controller.setFilter(filter);
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                            checkmarkColor: Colors.blue,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Sort button
            PopupMenuButton<String>(
              onSelected: controller.setSortBy,
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort),
                  Obx(
                    () => Icon(
                      controller.sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                    ),
                  ),
                ],
              ),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'name',
                      child: Text('Sort by Name'),
                    ),
                    const PopupMenuItem(
                      value: 'email',
                      child: Text('Sort by Email'),
                    ),
                    const PopupMenuItem(
                      value: 'created_date',
                      child: Text('Sort by Join Date'),
                    ),
                    const PopupMenuItem(
                      value: 'unique_code',
                      child: Text('Sort by Code ID'),
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
      case 'with_bank_details':
        return 'Bank Details';
      case 'without_bank_details':
        return 'No Bank';
      case 'mpin_set':
        return 'MPIN Set';
      case 'mpin_not_set':
        return 'No MPIN';
      default:
        return filter.capitalizeFirst!;
    }
  }

  Widget _buildDriversList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
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
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
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
            dataRowHeight: 72,
            columns: const [
              DataColumn(
                label: Text(
                  'Driver',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Contact',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Code ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Joined',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows:
                controller.filteredDrivers.map((driver) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  driver.profilePicture != null
                                      ? NetworkImage(driver.profilePicture!)
                                      : null,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child:
                                  driver.profilePicture == null
                                      ? Text(
                                        (driver.driverName ?? 'N')[0]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    driver.driverName ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'ID: ${driver.id}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              driver.email ?? 'No email',
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              driver.phoneNumber ?? 'No phone',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          '${driver.uniqueCodeId ?? 'N/A'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      DataCell(_buildDriverStatusChips(driver)),
                      DataCell(Text(_formatDate(driver.createdAt))),
                      DataCell(
                        ElevatedButton.icon(
                          onPressed: () => controller.openDriverDetails(driver),
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
      ),
    );
  }

  Widget _buildTabletGrid() {
    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.filteredDrivers.length,
        itemBuilder: (context, index) {
          final driver = controller.filteredDrivers[index];
          return _DriverCard(
            driver: driver,
            onTap: () => controller.openDriverDetails(driver),
          );
        },
      ),
    );
  }

  Widget _buildMobileList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredDrivers.length,
        itemBuilder: (context, index) {
          final driver = controller.filteredDrivers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DriverCard(
              driver: driver,
              onTap: () => controller.openDriverDetails(driver),
              isMobile: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverStatusChips(Driver driver) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _buildStatusChip(
          'Bank',
          driver.hasBankDetails == true,
          driver.hasBankDetails == true ? Colors.green : Colors.orange,
        ),
        _buildStatusChip(
          'MPIN',
          driver.mpinSet == true,
          driver.mpinSet == true ? Colors.blue : Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 10,
            color: isActive ? color : Colors.grey,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? color : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No drivers found',
            style: Get.textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              controller.setSearchQuery('');
              controller.setFilter('all');
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
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
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// =============================================================================
// DRIVER CARD COMPONENT
// =============================================================================

class _DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;
  final bool isMobile;

  const _DriverCard({
    required this.driver,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
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
              // Header with avatar and basic info
              Row(
                children: [
                  CircleAvatar(
                    radius: isMobile ? 24 : 20,
                    backgroundImage:
                        driver.profilePicture != null
                            ? NetworkImage(driver.profilePicture!)
                            : null,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child:
                        driver.profilePicture == null
                            ? Text(
                              (driver.driverName ?? 'N')[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: isMobile ? 18 : 16,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.driverName ?? 'Unknown Driver',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 16 : 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${driver.id} • Code: ${driver.uniqueCodeId ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isMobile ? 12 : 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Contact information
              if (driver.email != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        driver.email!,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              if (driver.phoneNumber != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      driver.phoneNumber!,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ] else
                const SizedBox(height: 2),

              // Status chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _buildStatusChip(
                    'Bank Details',
                    driver.hasBankDetails == true,
                    driver.hasBankDetails == true
                        ? Colors.green
                        : Colors.orange,
                  ),
                  _buildStatusChip(
                    'MPIN',
                    driver.mpinSet == true,
                    driver.mpinSet == true ? Colors.blue : Colors.red,
                  ),
                  if (driver.hasBankDetails == true && driver.mpinSet == true)
                    _buildStatusChip('Active', true, Colors.purple),
                ],
              ),

              const SizedBox(height: 12),

              // Join date and action
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Joined ${_formatDate(driver.createdAt)}',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 10,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (!isMobile)
                    TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isActive ? color : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? color : Colors.grey,
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

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
