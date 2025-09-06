import 'package:flutter/material.dart';
import 'package:lakshya/core/widgets/custom_navigation_bar.dart';
import 'package:lakshya/features/student/view/screens/student_home_screen.dart';

final List<Widget> _pages = [
  const StudentHomeScreen(),
  const Scaffold(body: Center(child: Text("Colleges Page"))),
  const Scaffold(body: Center(child: Text("Scholarship Page"))),
  const Scaffold(body: Center(child: Text("Timeline Page"))),
];

class StudentLayoutScreen extends StatefulWidget {
  final int initialIndex;
  const StudentLayoutScreen({this.initialIndex = 0, super.key});

  @override
  State<StudentLayoutScreen> createState() => _StudentLayoutScreenState();
}

class _StudentLayoutScreenState extends State<StudentLayoutScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex] is StudentHomeScreen
          ? StudentHomeScreen(onTap: _onTabChange)
          : _pages[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
