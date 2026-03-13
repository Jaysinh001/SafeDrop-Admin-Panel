import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rbac_bloc.dart';
import '../../bloc/rbac_event.dart';
import '../../bloc/rbac_state.dart';
import '../widgets/permission_group_card.dart';
import '../widgets/role_card.dart';
import '../widgets/member_list_tile.dart';
import '../widgets/permission_matrix_widget.dart';
import '../widgets/create_group_dialog.dart';
import '../widgets/create_role_dialog.dart';
import '../widgets/assign_group_dialog.dart';
import '../widgets/assign_role_dialog.dart';
import 'member_permission_detail_screen.dart';
import 'group_detail_screen.dart';
import 'role_detail_screen.dart';
import '../../data/models/permission_group_model.dart';
import '../../data/models/role_model.dart';
import '../../data/repositories/rbac_repository.dart'; // For PolicyInput
import '../../../../core/theme/colors.dart';

class RbacDashboardScreen extends StatefulWidget {
  const RbacDashboardScreen({super.key});

  @override
  State<RbacDashboardScreen> createState() => _RbacDashboardScreenState();
}

class _RbacDashboardScreenState extends State<RbacDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedNavIndex = 0; // 0: Groups, 1: Roles, 2: Members

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<RbacBloc>().add(LoadRbacDashboard());
    context.read<RbacBloc>().add(LoadAllPermissions());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RbacBloc, RbacState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
          context.read<RbacBloc>().add(ClearMessages());
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          context.read<RbacBloc>().add(ClearMessages());
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildMobileLayout(context, state);
            } else if (constraints.maxWidth < 1024) {
              return _buildTabletLayout(context, state);
            } else {
              return _buildDesktopLayout(context, state);
            }
          },
        );
      },
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout(BuildContext context, RbacState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RBAC Management'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'Groups'),
                Tab(text: 'Roles'),
                Tab(text: 'Members'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupsList(context, state),
          _buildRolesList(context, state),
          _buildMembersList(context, state),
        ],
      ),
      floatingActionButton:
          _tabController.index != 2
              ? FloatingActionButton(
                onPressed:
                    () =>
                        _tabController.index == 0
                            ? _showCreateGroup(context)
                            : _showCreateRole(context),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  // ===========================================================================
  // TABLET LAYOUT
  // ===========================================================================
  Widget _buildTabletLayout(BuildContext context, RbacState state) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Nav
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                _buildNavHeader('RBAC'),
                _buildNavItem(0, 'Permission Groups', Icons.group_work, state),
                _buildNavItem(
                  1,
                  'Custom Roles',
                  Icons.admin_panel_settings,
                  state,
                ),
                _buildNavItem(2, 'Org Members', Icons.people, state),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildCurrentSection(context, state, isTablet: true)),
        ],
      ),
    );
  }

  // ===========================================================================
  // DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout(BuildContext context, RbacState state) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Row(
        children: [
          // Col 1: Navigation sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: Column(
              children: [
                _buildNavHeader('RBAC System'),
                const SizedBox(height: 12),
                _buildNavItem(
                  0,
                  'Permission Groups',
                  Icons.group_work_outlined,
                  state,
                ),
                _buildNavItem(1, 'Internal Roles', Icons.badge_outlined, state),
                _buildNavItem(
                  2,
                  'Member Access',
                  Icons.person_outline_rounded,
                  state,
                ),
              ],
            ),
          ),
          // Col 2: List aspect
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: _buildListForSection(context, state),
          ),
          // Col 3: Details aspect
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildDetailPanel(context, state),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // COMMON UI BLOCKS
  // ===========================================================================

  Widget _buildNavHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String title,
    IconData icon,
    RbacState state,
  ) {
    final isSelected = _selectedNavIndex == index;
    int? count;
    if (index == 0) count = state.groups.length;
    if (index == 1) count = state.roles.length;
    if (index == 2) count = state.members.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedNavIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primary.withOpacity(0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSection(
    BuildContext context,
    RbacState state, {
    required bool isTablet,
  }) {
    // For Tablet, we might want a split view here too if we have space,
    // but the request says Master-Detail.
    return Row(
      children: [
        Expanded(flex: 2, child: _buildListForSection(context, state)),
        const VerticalDivider(width: 1),
        Expanded(flex: 3, child: _buildDetailPanel(context, state)),
      ],
    );
  }

  Widget _buildListForSection(BuildContext context, RbacState state) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildGroupsList(context, state, isListView: true);
      case 1:
        return _buildRolesList(context, state, isListView: true);
      case 2:
        return _buildMembersList(context, state, isListView: true);
      default:
        return const SizedBox();
    }
  }

  Widget _buildGroupsList(
    BuildContext context,
    RbacState state, {
    bool isListView = false,
  }) {
    if (state.isLoadingGroups) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.groups.isEmpty) {
      return _buildEmptyState(
        'No groups found',
        () => _showCreateGroup(context),
      );
    }

    return Column(
      children: [
        if (isListView)
          _buildSectionHeader('Groups', () => _showCreateGroup(context)),
        Expanded(
          child: ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, index) {
              final group = state.groups[index];
              return PermissionGroupCard(
                group: group,
                isSelected: state.selectedGroup?.id == group.id,
                onTap: () {
                  context.read<RbacBloc>().add(SelectGroup(group.id));
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<RbacBloc>(),
                              child: const GroupDetailScreen(),
                            ),
                      ),
                    );
                  }
                },
                onEdit: () => _showCreateGroup(context, group: group),
                onDelete:
                    () => _showDeleteConfirm(
                      context,
                      'Group',
                      () => context.read<RbacBloc>().add(
                        DeletePermissionGroup(group.id),
                      ),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRolesList(
    BuildContext context,
    RbacState state, {
    bool isListView = false,
  }) {
    if (state.isLoadingRoles) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.roles.isEmpty) {
      return _buildEmptyState('No roles found', () => _showCreateRole(context));
    }

    return Column(
      children: [
        if (isListView)
          _buildSectionHeader('Roles', () => _showCreateRole(context)),
        Expanded(
          child: ListView.builder(
            itemCount: state.roles.length,
            itemBuilder: (context, index) {
              final role = state.roles[index];
              return RoleCard(
                role: role,
                isSelected: state.selectedRole?.id == role.id,
                onTap: () {
                  context.read<RbacBloc>().add(SelectRole(role.id));
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<RbacBloc>(),
                              child: const RoleDetailScreen(),
                            ),
                      ),
                    );
                  }
                },
                onEdit: () => _showCreateRole(context, role: role),
                onDelete:
                    () => _showDeleteConfirm(
                      context,
                      'Role',
                      () => context.read<RbacBloc>().add(DeleteRole(role.id)),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(
    BuildContext context,
    RbacState state, {
    bool isListView = false,
  }) {
    if (state.isLoadingMembers) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged:
                (val) => context.read<RbacBloc>().add(SearchMembers(val)),
            decoration: const InputDecoration(
              hintText: 'Search members...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.filteredMembers.length,
            itemBuilder: (context, index) {
              final member = state.filteredMembers[index];
              return MemberListTile(
                member: member,
                isSelected:
                    state.selectedMember?.organizationUserId ==
                    member.organizationUserId,
                onTap: () {
                  context.read<RbacBloc>().add(
                    SelectMember(member.organizationUserId),
                  );
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<RbacBloc>(),
                              child: const MemberPermissionDetailScreen(),
                            ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailPanel(BuildContext context, RbacState state) {
    switch (_selectedNavIndex) {
      case 0:
        if (state.selectedGroup == null) {
          return const Center(child: Text('Select a group to view details'));
        }
        return _buildGroupDetail(context, state);
      case 1:
        if (state.selectedRole == null) {
          return const Center(child: Text('Select a role to view details'));
        }
        return _buildRoleDetail(context, state);
      case 2:
        if (state.selectedMember == null) {
          return const Center(child: Text('Select a member to view details'));
        }
        return const MemberPermissionDetailScreen(isPanel: true);
      default:
        return const Center(child: Text('Select an item'));
    }
  }

  Widget _buildGroupDetail(BuildContext context, RbacState state) {
    return Column(
      children: [
        _buildDetailHeader(state.selectedGroup!.name, 'Permission Matrix'),
        Expanded(
          child: PermissionMatrixWidget(
            allPermissions: state.allPermissions,
            currentPolicies: state.selectedGroup!.policies,
            isGroupMode: true,
            onPoliciesChanged: (policies) {
              // We'll show a "Save" button for these changes
              setState(() {
                _pendingPolicies =
                    policies
                        .map(
                          (p) => PolicyInput(
                            permissionId: p.permissionId,
                            allowed: p.allowed,
                          ),
                        )
                        .toList();
              });
            },
          ),
        ),
        _buildSaveAction(
          () => context.read<RbacBloc>().add(
            SaveGroupPolicies(state.selectedGroup!.id, _pendingPolicies ?? []),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDetail(BuildContext context, RbacState state) {
    return Column(
      children: [
        _buildDetailHeader(state.selectedRole!.name, 'Role Permissions'),
        Expanded(
          child: PermissionMatrixWidget(
            allPermissions: state.allPermissions,
            currentRolePermissionIds: state.selectedRole!.permissionIds,
            isGroupMode: false,
            onRolePermissionsChanged: (ids) {
              setState(() {
                _pendingRolePerms = ids;
              });
            },
          ),
        ),
        _buildSaveAction(
          () => context.read<RbacBloc>().add(
            SaveRolePermissions(
              state.selectedRole!.id,
              _pendingRolePerms ?? [],
            ),
          ),
        ),
      ],
    );
  }

  List<PolicyInput>? _pendingPolicies;
  List<int>? _pendingRolePerms;

  Widget _buildDetailHeader(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _showAssignDialog(context),
            icon: const Icon(Icons.person_add_outlined, size: 18),
            label: const Text('Assign Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveAction(VoidCallback onSave) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_pendingPolicies != null || _pendingRolePerms != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Unsaved changes',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
          ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
            color: AppColors.primary,
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, VoidCallback onAction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onAction, child: const Text('Create New')),
        ],
      ),
    );
  }

  // ===========================================================================
  // DIALOG HELPERS
  // ===========================================================================

  void _showCreateGroup(BuildContext context, {PermissionGroupModel? group}) {
    showDialog(
      context: context,
      builder:
          (_) => CreateGroupDialog(
            initialName: group?.name,
            initialDescription: group?.description,
            onSave: (name, desc) {
              if (group == null) {
                context.read<RbacBloc>().add(CreatePermissionGroup(name, desc));
              } else {
                context.read<RbacBloc>().add(
                  UpdatePermissionGroup(group.id, name, desc),
                );
              }
            },
          ),
    );
  }

  void _showCreateRole(BuildContext context, {RoleModel? role}) {
    showDialog(
      context: context,
      builder:
          (_) => CreateRoleDialog(
            initialName: role?.name,
            onSave: (name) {
              if (role == null) {
                context.read<RbacBloc>().add(CreateRole(name));
              } else {
                context.read<RbacBloc>().add(UpdateRole(role.id, name));
              }
            },
          ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    final state = context.read<RbacBloc>().state;
    if (_selectedNavIndex == 0) {
      showDialog(
        context: context,
        builder:
            (_) => AssignGroupDialog(
              members: state.members,
              groupName: state.selectedGroup!.name,
              onAssign:
                  (id) => context.read<RbacBloc>().add(
                    AssignGroupToMember(state.selectedGroup!.id, id),
                  ),
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AssignRoleDialog(
              members: state.members,
              roleName: state.selectedRole!.name,
              onAssign:
                  (id) => context.read<RbacBloc>().add(
                    AssignRoleToMember(state.selectedRole!.id, id),
                  ),
            ),
      );
    }
  }

  void _showDeleteConfirm(
    BuildContext context,
    String type,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete $type'),
            content: Text(
              'Are you sure you want to delete this $type? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
