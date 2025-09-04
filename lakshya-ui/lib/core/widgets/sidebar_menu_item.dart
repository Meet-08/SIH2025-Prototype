import 'package:flutter/material.dart';
import 'package:lakshya/core/core.dart';

class SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;
  final bool isSelected;

  const SidebarMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.routeName,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: isSelected ? AppColors.primaryContainer : Colors.transparent,
      hoverColor: AppColors.surfaceContainer,
      onTap: () {
        // Prevent unnecessary navigation if already selected
        if (ModalRoute.of(context)?.settings.name != routeName) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
