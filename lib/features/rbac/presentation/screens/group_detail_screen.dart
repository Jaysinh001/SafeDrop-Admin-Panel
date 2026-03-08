import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rbac_bloc.dart';
import '../../bloc/rbac_event.dart';
import '../../bloc/rbac_state.dart';
import '../widgets/permission_matrix_widget.dart';
import '../../data/repositories/rbac_repository.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<PolicyInput>? _pendingPolicies;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RbacBloc, RbacState>(
      builder: (context, state) {
        final group = state.selectedGroup;
        if (group == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Group Details')),
            body: const Center(child: Text('No group selected')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            actions: [
              if (_pendingPolicies != null && _pendingPolicies!.isNotEmpty)
                TextButton(
                  onPressed: () {
                    context.read<RbacBloc>().add(
                      SaveGroupPolicies(group.id, _pendingPolicies!),
                    );
                    setState(() {
                      _pendingPolicies = null;
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
                  group.description ?? 'No description',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const Divider(),
              Expanded(
                child: PermissionMatrixWidget(
                  allPermissions: state.allPermissions,
                  currentPolicies: group.policies,
                  isGroupMode: true,
                  onPoliciesChanged: (policies) {
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
            ],
          ),
        );
      },
    );
  }
}
