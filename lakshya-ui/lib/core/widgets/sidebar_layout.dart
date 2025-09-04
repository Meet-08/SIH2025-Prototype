import 'package:flutter/material.dart';
import 'package:lakshya/features/parent/view/widgets/parent_sidebar.dart';

class SidebarLayout extends StatefulWidget {
  final String role;
  final Widget child;

  const SidebarLayout({super.key, required this.role, required this.child});

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isSidebarOpen = false;

  final double sidebarWidth = 250;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      _isSidebarOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: toggleSidebar,
              ),
              title: Text(
                "${widget.role[0].toUpperCase()}${widget.role.substring(1)} Dashboard",
              ),
            ),
            body: widget.child,
          ),

          if (_isSidebarOpen)
            GestureDetector(
              onTap: toggleSidebar,
              child: Container(color: Colors.black54),
            ),

          SlideTransition(
            position: _slideAnimation,
            child: SizedBox(
              width: sidebarWidth,
              child: ParentSidebar(onClose: toggleSidebar),
            ),
          ),
        ],
      ),
    );
  }
}
