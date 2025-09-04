import 'package:flutter/material.dart';
import 'package:lakshya/core/widgets/sidebar_menu_item.dart';

class ParentSidebar extends StatelessWidget {
  final VoidCallback onClose;

  const ParentSidebar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      width: 220,
      color: Colors.deepPurple.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // leave space equal to AppBar height
          const SizedBox(height: kToolbarHeight),

          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ),

          const SizedBox(height: 20),

          // Sidebar menu items
          SidebarMenuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            routeName: "/dashboard",
            isSelected: currentRoute == "/dashboard",
          ),
          SidebarMenuItem(
            icon: Icons.people,
            title: "Manage Users",
            routeName: "/manageUsers",
            isSelected: currentRoute == "/manageUsers",
          ),
        ],
      ),
    );
  }
}
