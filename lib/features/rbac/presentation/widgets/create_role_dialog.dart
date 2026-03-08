import 'package:flutter/material.dart';

class CreateRoleDialog extends StatefulWidget {
  final String? initialName;
  final Function(String name) onSave;

  const CreateRoleDialog({super.key, this.initialName, required this.onSave});

  @override
  State<CreateRoleDialog> createState() => _CreateRoleDialogState();
}

class _CreateRoleDialogState extends State<CreateRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialName == null ? 'Create Custom Role' : 'Edit Custom Role',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Role Name',
                border: OutlineInputBorder(),
              ),
              validator:
                  (val) =>
                      val == null || val.isEmpty ? 'Name is required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(_nameController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
