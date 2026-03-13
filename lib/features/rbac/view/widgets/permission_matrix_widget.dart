import 'package:flutter/material.dart';
import '../../data/models/permission_model.dart';
import '../../data/models/permission_policy_model.dart';
import '../../../../core/theme/colors.dart';

enum PermissionState { allowed, denied, inherit }

class PermissionMatrixWidget extends StatefulWidget {
  final List<PermissionModel> allPermissions;
  final List<PermissionPolicyModel>? currentPolicies; // For groups
  final List<int>? currentRolePermissionIds; // For roles
  final bool isGroupMode;
  final Function(List<PermissionPolicyModel>)? onPoliciesChanged;
  final Function(List<int>)? onRolePermissionsChanged;

  const PermissionMatrixWidget({
    super.key,
    required this.allPermissions,
    this.currentPolicies,
    this.currentRolePermissionIds,
    this.isGroupMode = true,
    this.onPoliciesChanged,
    this.onRolePermissionsChanged,
  });

  @override
  State<PermissionMatrixWidget> createState() => _PermissionMatrixWidgetState();
}

class _PermissionMatrixWidgetState extends State<PermissionMatrixWidget> {
  // Local dirty state
  Map<int, PermissionState> _groupState = {};
  Set<int> _roleState = {};
  String _selectedModule = 'All';

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  @override
  void didUpdateWidget(PermissionMatrixWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPolicies != widget.currentPolicies ||
        oldWidget.currentRolePermissionIds != widget.currentRolePermissionIds) {
      _initializeState();
    }
  }

  void _initializeState() {
    if (widget.isGroupMode) {
      _groupState = {};
      for (var p in widget.allPermissions) {
        final policy = widget.currentPolicies?.firstWhere(
          (pol) => pol.permissionId == p.id,
          orElse:
              () => PermissionPolicyModel(
                permissionGroupId: 0,
                permissionId: p.id,
                allowed: false,
              ),
        );

        final hasPolicy =
            widget.currentPolicies?.any((pol) => pol.permissionId == p.id) ??
            false;

        if (!hasPolicy) {
          _groupState[p.id] = PermissionState.inherit;
        } else {
          _groupState[p.id] =
              policy!.allowed
                  ? PermissionState.allowed
                  : PermissionState.denied;
        }
      }
    } else {
      _roleState = Set.from(widget.currentRolePermissionIds ?? []);
    }
  }

  void _toggleGroupPermission(int permissionId, PermissionState newState) {
    setState(() {
      _groupState[permissionId] = newState;
    });
    _notifyChanges();
  }

  void _toggleRolePermission(int permissionId, bool? value) {
    setState(() {
      if (value == true) {
        _roleState.add(permissionId);
      } else {
        _roleState.remove(permissionId);
      }
    });
    _notifyChanges();
  }

  void _notifyChanges() {
    if (widget.isGroupMode) {
      final policies =
          _groupState.entries
              .where((e) => e.value != PermissionState.inherit)
              .map(
                (e) => PermissionPolicyModel(
                  permissionGroupId: 0,
                  permissionId: e.key,
                  allowed: e.value == PermissionState.allowed,
                ),
              )
              .toList();
      widget.onPoliciesChanged?.call(policies);
    } else {
      widget.onRolePermissionsChanged?.call(_roleState.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = [
      'All',
      ...widget.allPermissions.map((p) => p.module).toSet().toList()..sort(),
    ];
    final filteredPermissions =
        _selectedModule == 'All'
            ? widget.allPermissions
            : widget.allPermissions
                .where((p) => p.module == _selectedModule)
                .toList();

    // Group by module for display
    Map<String, List<PermissionModel>> grouped = {};
    for (var p in filteredPermissions) {
      grouped.putIfAbsent(p.module, () => []).add(p);
    }

    return Column(
      children: [
        // Module Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children:
                modules
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(m),
                          selected: _selectedModule == m,
                          onSelected:
                              (val) => setState(() => _selectedModule = m),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color:
                                _selectedModule == m
                                    ? Colors.white
                                    : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: AppColors.surfaceContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        // Matrix Body
        Expanded(
          child: ListView.builder(
            itemCount: grouped.keys.length,
            itemBuilder: (context, index) {
              final module = grouped.keys.elementAt(index);
              final perms = grouped[module]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.cardBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          module.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...perms.map((p) => _buildPermissionRow(p)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRow(PermissionModel p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBorder.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isGroupMode)
            _buildThreeStateToggle(p.id)
          else
            Checkbox(
              value: _roleState.contains(p.id),
              onChanged: (val) => _toggleRolePermission(p.id, val),
              activeColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThreeStateToggle(int permissionId) {
    final state = _groupState[permissionId] ?? PermissionState.inherit;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.check_rounded,
            color: AppColors.success,
            isSelected: state == PermissionState.allowed,
            onTap:
                () => _toggleGroupPermission(
                  permissionId,
                  PermissionState.allowed,
                ),
          ),
          const SizedBox(width: 4),
          _ToggleButton(
            icon: Icons.close_rounded,
            color: AppColors.error,
            isSelected: state == PermissionState.denied,
            onTap:
                () => _toggleGroupPermission(
                  permissionId,
                  PermissionState.denied,
                ),
          ),
          const SizedBox(width: 4),
          _ToggleButton(
            icon: Icons.minimize_rounded,
            color: AppColors.textTertiary,
            isSelected: state == PermissionState.inherit,
            onTap:
                () => _toggleGroupPermission(
                  permissionId,
                  PermissionState.inherit,
                ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : color.withOpacity(0.6),
        ),
      ),
    );
  }
}
