// =============================================================================
// STUDENTS LIST VIEW
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/loading_view.dart';
import '../controller/students_list_controller.dart';
import '../model/students_list_response.dart';

class StudentsListView extends GetView<StudentsListController> {
  const StudentsListView({super.key});

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
                return const LoadingView(title: "Loading students...",);
              }
              
              if (controller.filteredStudents.isEmpty) {
                return _buildEmptyState();
              }
              
              return _buildStudentsList(context);
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
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
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
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  '${controller.filteredStudents.length} students found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                )),
              ],
            ),
          ),
          if (context.width > 768)
            _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Obx(() {
      final stats = controller.studentStats;
      return Row(
        children: [
          _buildStatChip('Total', stats['total']!, Colors.blue),
          const SizedBox(width: 8),
          _buildStatChip('Active', stats['active']!, Colors.green),
          const SizedBox(width: 8),
          _buildStatChip('Assigned', stats['assigned']!, Colors.purple),
          const SizedBox(width: 8),
          _buildStatChip('Unassigned', stats['unassigned']!, Colors.orange),
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
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
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
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: context.width > 768 ? _buildDesktopFilterBar() : _buildMobileFilterBar(),
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
              hintText: 'Search by name, email, phone, ID, or driver...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Filter dropdown
        Obx(() => Container(
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
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Students')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(value: 'assigned', child: Text('Assigned to Driver')),
                DropdownMenuItem(value: 'unassigned', child: Text('Unassigned')),
              ],
              onChanged: (value) {
                if (value != null) controller.setFilter(value);
              },
            ),
          ),
        )),
        
        const SizedBox(width: 16),
        
        // Sort dropdown
        Obx(() => Container(
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
                DropdownMenuItem(value: 'fee', child: Text('Fee')),
                DropdownMenuItem(value: 'student_id', child: Text('Student ID')),
                DropdownMenuItem(value: 'driver', child: Text('Driver')),
              ],
              onChanged: (value) {
                if (value != null) controller.setSortBy(value);
              },
            ),
          ),
        )),
        
        const SizedBox(width: 8),
        
        // Sort direction
        Obx(() => IconButton(
          onPressed: () => controller.setSortBy(controller.sortBy),
          icon: Icon(
            controller.sortAscending 
                ? Icons.arrow_upward 
                : Icons.arrow_downward,
          ),
          tooltip: controller.sortAscending ? 'Ascending' : 'Descending',
        )),
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
            hintText: 'Search students...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        
        // Filter and Sort chips
        Row(
          children: [
            Expanded(
              child: Obx(() => SingleChildScrollView(
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
              )),
            ),
            
            // Sort button
            PopupMenuButton<String>(
              onSelected: controller.setSortBy,
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort),
                  Obx(() => Icon(
                    controller.sortAscending 
                        ? Icons.arrow_upward 
                        : Icons.arrow_downward,
                    size: 16,
                  )),
                ],
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                PopupMenuItem(value: 'fee', child: Text('Sort by Fee')),
                PopupMenuItem(value: 'student_id', child: Text('Sort by ID')),
                PopupMenuItem(value: 'driver', child: Text('Sort by Driver')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all': return 'All';
      case 'active': return 'Active';
      case 'inactive': return 'Inactive';
      case 'assigned': return 'Assigned';
      case 'unassigned': return 'Unassigned';
      default: return filter.capitalizeFirst!;
    }
  }

  Widget _buildStudentsList(BuildContext context) {
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
    return Obx(() => SingleChildScrollView(
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
            DataColumn(label: Text('Student', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Fee', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: controller.filteredStudents.map((student) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: Text(
                          (student.studentName ?? 'N')[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              student.studentName ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${student.studentId}',
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
                        student.email ?? 'No email',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        student.phoneNumber ?? 'No phone',
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
                    '₹${student.proposedFee ?? 0}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataCell(
                  student.driverId != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              student.driverName ?? 'Unknown',
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              student.driverCode ?? 'N/A',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Unassigned',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
                DataCell(_buildStudentStatusChips(student)),
                DataCell(
                  ElevatedButton.icon(
                    onPressed: () => controller.openStudentDetails(student),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    ));
  }

  Widget _buildTabletGrid() {
    return Obx(() => GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: controller.filteredStudents.length,
      itemBuilder: (context, index) {
        final student = controller.filteredStudents[index];
        return _StudentCard(
          student: student,
          onTap: () => controller.openStudentDetails(student),
        );
      },
    ));
  }

  Widget _buildMobileList() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredStudents.length,
      itemBuilder: (context, index) {
        final student = controller.filteredStudents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _StudentCard(
            student: student,
            onTap: () => controller.openStudentDetails(student),
            isMobile: true,
          ),
        );
      },
    ));
  }

  Widget _buildStudentStatusChips(Student student) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _buildStatusChip(
          student.accountActive == true ? 'Active' : 'Inactive',
          student.accountActive == true,
          student.accountActive == true ? Colors.green : Colors.red,
        ),
        if (student.driverId != null)
          _buildStatusChip(
            'Assigned',
            true,
            Colors.purple,
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
          color: isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
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
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
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
}

// =============================================================================
// STUDENT CARD COMPONENT
// =============================================================================

class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final bool isMobile;

  const _StudentCard({
    required this.student,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(
                      (student.studentName ?? 'N')[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
                          student.studentName ?? 'Unknown Student',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 16 : 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${student.studentId}',
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
              if (student.email != null) ...[
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        student.email!,
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
              
              if (student.phoneNumber != null) ...[
                Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      student.phoneNumber!,
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
              
              // Fee display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      'Proposed Fee: ₹${student.proposedFee ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Driver assignment info
              if (student.driverId != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.purple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Driver',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              student.driverName ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.purple,
                              ),
                            ),
                            Text(
                              'Code: ${student.driverCode ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'No driver assigned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Status chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _buildStatusChip(
                    student.accountActive == true ? 'Active' : 'Inactive',
                    student.accountActive == true,
                    student.accountActive == true ? Colors.green : Colors.red,
                  ),
                  if (student.driverId != null)
                    _buildStatusChip(
                      'Assigned',
                      true,
                      Colors.purple,
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
          color: isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
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
}