import 'package:flutter/material.dart';
import '../../data/models/org_member_model.dart';

class AssignGroupDialog extends StatefulWidget {
  final List<OrgMemberModel> members;
  final String groupName;
  final Function(int orgUserId) onAssign;

  const AssignGroupDialog({
    super.key,
    required this.members,
    required this.groupName,
    required this.onAssign,
  });

  @override
  State<AssignGroupDialog> createState() => _AssignGroupDialogState();
}

class _AssignGroupDialogState extends State<AssignGroupDialog> {
  OrgMemberModel? _selectedMember;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign to Group: ${widget.groupName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select a member to assign to this group:'),
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
          if (_selectedMember?.permissionGroupName != null) ...[
            const SizedBox(height: 8),
            Text(
              'Current: ${_selectedMember!.permissionGroupName}',
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
