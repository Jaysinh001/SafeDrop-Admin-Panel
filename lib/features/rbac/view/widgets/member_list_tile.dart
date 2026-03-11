import 'package:flutter/material.dart';
import '../../data/models/org_member_model.dart';
import '../../../../core/theme/colors.dart';

class MemberListTile extends StatelessWidget {
  final OrgMemberModel member;
  final VoidCallback onTap;
  final bool isSelected;

  const MemberListTile({
    super.key,
    required this.member,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.primaryContainer.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : AppColors.surfaceContainerHigh,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child:
                member.avatarUrl != null
                    ? CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(member.avatarUrl!),
                    )
                    : Text(
                      member.name[0].toUpperCase(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.email,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _SystemRoleBadge(role: member.systemRole),
                if (member.permissionGroupName != null)
                  _ChipBadge(
                    label: member.permissionGroupName!,
                    color: AppColors.success,
                    icon: Icons.group_outlined,
                  ),
                if (member.customRoleName != null)
                  _ChipBadge(
                    label: member.customRoleName!,
                    color: AppColors.secondary,
                    icon: Icons.badge_outlined,
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isSelected ? AppColors.primary : AppColors.textTertiary,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _ChipBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
