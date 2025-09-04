import 'package:flutter/material.dart';
import 'package:lakshya/core/widgets/sidebar_layout.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SidebarLayout(
      role: "parent",
      child: Center(child: Text("Parent Home Screen")),
    );
  }
}
