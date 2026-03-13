import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rbac_bloc.dart';
import '../../bloc/rbac_event.dart';
import '../../bloc/rbac_state.dart';
import '../widgets/permission_source_badge.dart';

class MemberPermissionDetailScreen extends StatelessWidget {
  final bool isPanel;

  const MemberPermissionDetailScreen({super.key, this.isPanel = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RbacBloc, RbacState>(
      builder: (context, state) {
        final member = state.selectedMember;
        if (member == null) {
          return const Center(child: Text('No member selected'));
        }

        return Scaffold(
          appBar:
              isPanel
                  ? null
                  : AppBar(title: Text('Permissions: ${member.name}')),
          body:
              state.isLoadingPermissions
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      _buildMemberHeader(context, state),
                      _buildAssignmentControls(context, state),
                      const Divider(),
                      Expanded(child: _buildPermissionTable(context, state)),
                    ],
                  ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddOverride(context, state),
            label: const Text('Add Override'),
            icon: const Icon(Icons.add_moderator),
          ),
        );
      },
    );
  }

  Widget _buildMemberHeader(BuildContext context, RbacState state) {
    final member = state.selectedMember!;
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                member.avatarUrl != null
                    ? NetworkImage(member.avatarUrl!)
                    : null,
            child:
                member.avatarUrl == null
                    ? Text(member.name[0], style: const TextStyle(fontSize: 24))
                    : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(member.email, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                _SystemRoleBadge(role: member.systemRole),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentControls(BuildContext context, RbacState state) {
    final member = state.selectedMember!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _DropdownControl(
              label: 'Permission Group',
              value: member.permissionGroupName ?? 'None',
              onTap: () => _showChangeGroup(context, state),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _DropdownControl(
              label: 'Custom Role',
              value: member.customRoleName ?? 'None',
              onTap: () => _showChangeRole(context, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTable(BuildContext context, RbacState state) {
    if (state.selectedMemberPermissions.isEmpty) {
      return const Center(child: Text('No permissions found for this member'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Permission')),
          DataColumn(label: Text('Module')),
          DataColumn(label: Text('Source')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows:
            state.selectedMemberPermissions
                .map(
                  (p) => DataRow(
                    cells: [
                      DataCell(Text(p.permissionName)),
                      DataCell(Text(p.module)),
                      DataCell(PermissionSourceBadge(source: p.source)),
                      DataCell(
                        Icon(
                          p.allowed ? Icons.check_circle : Icons.cancel,
                          color: p.allowed ? Colors.green : Colors.red,
                        ),
                      ),
                      DataCell(
                        p.source == 'user_override'
                            ? IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed:
                                  () => context.read<RbacBloc>().add(
                                    RemoveUserPermissionOverride(
                                      state.selectedMember!.organizationUserId,
                                      0 /* We need ID here */,
                                    ),
                                  ),
                            )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  void _showAddOverride(BuildContext context, RbacState state) {
    // Show a dialog with permission picker
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Permission Override'),
            content: SizedBox(
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.allPermissions.length,
                itemBuilder: (context, index) {
                  final p = state.allPermissions[index];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text(p.module),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            context.read<RbacBloc>().add(
                              AddUserPermissionOverride(
                                state.selectedMember!.organizationUserId,
                                p.id,
                                true,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            context.read<RbacBloc>().add(
                              AddUserPermissionOverride(
                                state.selectedMember!.organizationUserId,
                                p.id,
                                false,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }

  void _showChangeGroup(BuildContext context, RbacState state) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Change Permission Group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  state.groups
                      .map(
                        (g) => ListTile(
                          title: Text(g.name),
                          onTap: () {
                            context.read<RbacBloc>().add(
                              AssignGroupToMember(
                                g.id,
                                state.selectedMember!.organizationUserId,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _showChangeRole(BuildContext context, RbacState state) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Change Custom Role'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  state.roles
                      .map(
                        (r) => ListTile(
                          title: Text(r.name),
                          onTap: () {
                            context.read<RbacBloc>().add(
                              AssignRoleToMember(
                                r.id,
                                state.selectedMember!.organizationUserId,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }
}

class _SystemRoleBadge extends StatelessWidget {
  final String role;
  const _SystemRoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class _DropdownControl extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DropdownControl({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
