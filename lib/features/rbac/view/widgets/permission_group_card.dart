import 'package:flutter/material.dart';
import '../../data/models/permission_group_model.dart';
import '../../../../core/theme/colors.dart';

class PermissionGroupCard extends StatelessWidget {
  final PermissionGroupModel group;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelected;

  const PermissionGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.primaryContainer.withOpacity(0.3)
                : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.cardBorder,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppColors.primaryContainer.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (group.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            group.description!,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {}, // Handled by popup below
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ).asPopupTrigger(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 12),
                                Text('Edit Group'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Delete Group',
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _Badge(
                    icon: Icons.people_outline,
                    label: '${group.memberCount} Members',
                    color: AppColors.infoContainer,
                    textColor: AppColors.infoDark,
                  ),
                  const SizedBox(width: 12),
                  _Badge(
                    icon: Icons.shield_outlined,
                    label: '${group.policies.length} Permissions',
                    color: AppColors.successContainer,
                    textColor: AppColors.successDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension PopupTriggerExtension on Widget {
  Widget asPopupTrigger({
    required List<PopupMenuEntry<String>> Function(BuildContext) itemBuilder,
    required void Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      child: this,
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
