import 'package:flutter/material.dart';

class PermissionSourceBadge extends StatelessWidget {
  final String source;

  const PermissionSourceBadge({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String label;

    switch (source.toLowerCase()) {
      case 'admin_override':
        backgroundColor = Colors.blue;
        label = 'Admin Override';
        break;
      case 'user_override':
        backgroundColor = Colors.orange;
        label = 'User Override';
        break;
      case 'group':
        backgroundColor = Colors.green;
        label = 'Group Policy';
        break;
      case 'role':
        backgroundColor = Colors.purple;
        label = 'Role';
        break;
      default:
        backgroundColor = Colors.grey;
        label = 'Default Deny';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
