import 'package:flutter/material.dart';
import '../../data/models/role_model.dart';
import '../../../../core/theme/colors.dart';

class RoleCard extends StatelessWidget {
  final RoleModel role;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelected;

  const RoleCard({
    super.key,
    required this.role,
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
        gradient: isSelected ? AppColors.secondaryGradient : null,
        color: isSelected ? null : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? AppColors.secondary.withOpacity(0.3)
                    : AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                          role.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Custom Permissions Role',
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white.withOpacity(0.8)
                                    : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.white.withOpacity(0.2)
                              : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color:
                            isSelected
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
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
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 12),
                                Text('Edit Role'),
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
                                  'Delete Role',
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
                    icon: Icons.shield_outlined,
                    label: '${role.permissionIds.length} Permissions',
                    color:
                        isSelected
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.secondaryContainer,
                    textColor:
                        isSelected ? Colors.white : AppColors.secondaryDark,
                  ),
                  const SizedBox(width: 12),
                  _Badge(
                    icon: Icons.people_outline,
                    label: '${role.memberCount} Members',
                    color:
                        isSelected
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.infoContainer,
                    textColor: isSelected ? Colors.white : AppColors.infoDark,
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
