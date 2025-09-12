import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/widgets/loader.dart';
import 'package:lakshya/features/student/view/widgets/career_roadmap_graph.dart';
import 'package:lakshya/features/student/viewmodel/career_map_view_model.dart';

class CourseToCareerMappingScreen extends ConsumerStatefulWidget {
  const CourseToCareerMappingScreen({super.key});

  @override
  ConsumerState<CourseToCareerMappingScreen> createState() =>
      _CourseToCareerMappingScreenState();
}

class _CourseToCareerMappingScreenState
    extends ConsumerState<CourseToCareerMappingScreen> {
  String? _selectedCareerField;
  Key _graphKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _selectedCareerField = careerFields.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(careerMapViewModelProvider.notifier)
          .fetchCareerMap(careerFields.first);
    });
  }

  void _onCareerFieldSelected(String? careerField) {
    if (careerField != null) {
      setState(() {
        _selectedCareerField = careerField;
      });
      ref.read(careerMapViewModelProvider.notifier).fetchCareerMap(careerField);
      _resetGraph();
    }
  }

  void _resetGraph() {
    setState(() {
      _graphKey = UniqueKey();
    });
  }

  void _onGraphReset() {
    // Callback when the graph has been reset
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Career Roadmap Explorer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Educational Roadmap',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _resetGraph,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset View',
          ),
          IconButton(
            onPressed: () => _showHelpDialog(context),
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                DropdownButton(
                  items: careerFields
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: _onCareerFieldSelected,
                  hint: const Text("Select Career Field"),
                  value: _selectedCareerField,
                ),
                Icon(Icons.touch_app, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Follow your educational roadmap: 10th → 12th → Graduation → Career • Tap to explore paths',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Make sure the graph area is constrained by Expanded to avoid overflow
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final careerMapState = ref.watch(careerMapViewModelProvider);
                return careerMapState?.when(
                      data: (careerModel) {
                        return CareerRoadmapGraph(
                          key: _graphKey,
                          careerMapModel: careerModel,
                          onResetGraph: _onGraphReset,
                          onShowHelp: () => _showHelpDialog(context),
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text(
                            'Error loading career map: $error',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      },
                      loading: () {
                        return const Center(child: Loader());
                      },
                    ) ??
                    const Center(child: Loader());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            onPressed: _resetGraph,
            backgroundColor: Colors.indigo.shade600,
            foregroundColor: Colors.white,
            heroTag: "reset",
            tooltip: 'Reset to root node',
            child: const Icon(Icons.refresh, size: 20),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () => _showHelpDialog(context),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            heroTag: "help",
            tooltip: 'Help & Instructions',
            child: const Icon(Icons.help_outline, size: 20),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        // Make the dialog content scrollable to prevent overflow on small heights
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                Icons.touch_app,
                'Tap nodes to expand career paths',
              ),
              _buildHelpItem(Icons.zoom_in, 'Pinch to zoom in/out'),
              _buildHelpItem(Icons.pan_tool, 'Drag to navigate the graph'),
              _buildHelpItem(Icons.refresh, 'Use refresh button to reset view'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
