import 'package:flutter/material.dart';
import '../../data/models/org_member_model.dart';

class AssignRoleDialog extends StatefulWidget {
  final List<OrgMemberModel> members;
  final String roleName;
  final Function(int orgUserId) onAssign;

  const AssignRoleDialog({
    super.key,
    required this.members,
    required this.roleName,
    required this.onAssign,
  });

  @override
  State<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<AssignRoleDialog> {
  OrgMemberModel? _selectedMember;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Role: ${widget.roleName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select a member to assign this role:'),
          const SizedBox(height: 16),
          DropdownButtonFormField<OrgMemberModel>(
            value: _selectedMember,
            items:
                widget.members
                    .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                    .toList(),
            onChanged: (val) => setState(() => _selectedMember = val),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Member',
            ),
          ),
          if (_selectedMember?.customRoleName != null) ...[
            const SizedBox(height: 8),
            Text(
              'Current: ${_selectedMember!.customRoleName}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _selectedMember == null
                  ? null
                  : () {
                    widget.onAssign(_selectedMember!.organizationUserId);
                    Navigator.pop(context);
                  },
          child: const Text('Assign'),
        ),
      ],
    );
  }
}
