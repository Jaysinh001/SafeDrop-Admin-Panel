import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rbac_bloc.dart';
import '../../bloc/rbac_event.dart';
import '../../bloc/rbac_state.dart';
import '../widgets/permission_matrix_widget.dart';

class RoleDetailScreen extends StatefulWidget {
  const RoleDetailScreen({super.key});

  @override
  State<RoleDetailScreen> createState() => _RoleDetailScreenState();
}

class _RoleDetailScreenState extends State<RoleDetailScreen> {
  List<int>? _pendingRolePerms;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RbacBloc, RbacState>(
      builder: (context, state) {
        final role = state.selectedRole;
        if (role == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Role Details')),
            body: const Center(child: Text('No role selected')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(role.name),
            actions: [
              if (_pendingRolePerms != null)
                TextButton(
                  onPressed: () {
                    context.read<RbacBloc>().add(
                      SaveRolePermissions(role.id, _pendingRolePerms!),
                    );
                    setState(() {
                      _pendingRolePerms = null;
                    });
                  },
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Manage permissions for this custom role',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const Divider(),
              Expanded(
                child: PermissionMatrixWidget(
                  allPermissions: state.allPermissions,
                  currentRolePermissionIds: role.permissionIds,
                  isGroupMode: false,
                  onRolePermissionsChanged: (ids) {
                    setState(() {
                      _pendingRolePerms = ids;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
