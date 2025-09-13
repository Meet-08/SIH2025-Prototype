import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:getwidget/getwidget.dart';
import 'package:graphview/GraphView.dart';
import 'package:lakshya/features/student/models/career_map_model.dart';

class CareerRoadmapGraph extends StatefulWidget {
  final CareerMapModel careerMapModel;
  final VoidCallback? onResetGraph;
  final VoidCallback? onShowHelp;

  const CareerRoadmapGraph({
    super.key,
    required this.careerMapModel,
    this.onResetGraph,
    this.onShowHelp,
  });

  @override
  State<CareerRoadmapGraph> createState() => _CareerRoadmapGraphState();
}

class _CareerRoadmapGraphState extends State<CareerRoadmapGraph>
    with TickerProviderStateMixin {
  final Graph graph = Graph()..isTree = true;
  late BuchheimWalkerConfiguration builder;

  Map<int, Map<String, dynamic>> nodeData = {};
  Set<int> expandedNodes = {};
  Map<int, List<int>> nodeChildren = {};
  Map<int, int> nodeParent = {};
  Set<int> hiddenNodes = {};

  final TransformationController _transformationController =
      TransformationController();

  late Map<int, dynamic> nodeHierarchy;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeBuilder();
    _initializeHierarchy();
    _initializeRootNode();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeBuilder() {
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 100
      ..levelSeparation = 140
      ..subtreeSeparation = 120
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  void _initializeHierarchy() {
    nodeHierarchy = {};

    // Root
    nodeHierarchy[0] = {
      'data': {
        'type': 'start',
        'title': 'After 10th',
        'subtitle': 'Choose your stream',
      },
      'children': [1],
    };

    // After 10th Stream Node
    nodeHierarchy[1] = {
      'data': {
        'type': 'after10th',
        'title':
            'After 10th - ${widget.careerMapModel.after10th.recommendedStream}',
        'subtitle':
            'Recommended: ${widget.careerMapModel.after10th.recommendedStream}',
      },
      'children': [2],
      'color': Colors.teal,
    };

    // Subjects under After 10th
    final subjects = widget.careerMapModel.after10th.subjects;
    final after10SubjectsChildren = <int>[];
    int subjectIdStart = 101;
    for (int i = 0; i < subjects.length; i++) {
      after10SubjectsChildren.add(subjectIdStart + i);
      nodeHierarchy[subjectIdStart + i] = {
        'data': {'type': 'subject', 'title': subjects[i], 'subtitle': ''},
        'children': <int>[],
        'color': Colors.blueGrey,
      };
    }

    // After 12th Node
    nodeHierarchy[2] = {
      'data': {
        'type': 'after12th',
        'title': 'After 12th',
        'subtitle': 'Entrance Exams & Course Options',
      },
      'children': [200, 300],
      'color': Colors.indigo,
    };

    // Entrance exams category (200)
    final exams = widget.careerMapModel.after12th.entranceExams;
    final examChildIds = <int>[];
    int examStart = 201;
    for (int i = 0; i < exams.length; i++) {
      examChildIds.add(examStart + i);
      nodeHierarchy[examStart + i] = {
        'data': {'type': 'entranceExam', 'title': exams[i], 'subtitle': ''},
        'children': <int>[],
        'color': Colors.orange,
      };
    }
    nodeHierarchy[200] = {
      'data': {'type': 'category', 'title': 'Entrance Exams', 'subtitle': ''},
      'children': examChildIds,
      'color': Colors.orange,
    };

    // Course Options category placeholder (300)
    nodeHierarchy[300] = {
      'data': {
        'type': 'category',
        'title': 'Course Options (12th)',
        'subtitle': '',
      },
      'children': <int>[],
      'color': Colors.deepPurple,
    };

    // Courses (detailed nodes)
    final courses = widget.careerMapModel.courses;
    int courseIndex = 0;
    courses.forEach((courseKey, courseData) {
      final baseCourseId = 1000 + courseIndex * 100;
      final courseNodeId = baseCourseId;
      final specializationCategoryId = baseCourseId + 10;
      final specializationStart = specializationCategoryId + 1;
      final keySubjectsCategoryId = baseCourseId + 20;
      final keySubjectStart = keySubjectsCategoryId + 1;
      final careerPathsCategoryId = baseCourseId + 30;
      final careerCategoryStart = careerPathsCategoryId + 1;

      nodeHierarchy[courseNodeId] = {
        'data': {
          'type': 'course_option_detail',
          'title': courseData.name,
          'subtitle': '${courseData.duration} • $courseKey',
        },
        'children': <int>[],
        'color': Colors.purple,
      };

      (nodeHierarchy[300]['children'] as List).add(courseNodeId);

      // Specializations
      final specs = courseData.specializations;
      final specIds = <int>[];
      for (int i = 0; i < specs.length; i++) {
        final sid = specializationStart + i;
        specIds.add(sid);
        nodeHierarchy[sid] = {
          'data': {'type': 'specialization', 'title': specs[i], 'subtitle': ''},
          'children': <int>[],
          'color': Colors.teal.shade300,
        };
      }
      nodeHierarchy[specializationCategoryId] = {
        'data': {
          'type': 'category',
          'title': 'Specializations',
          'subtitle': '',
        },
        'children': specIds,
        'color': Colors.teal,
      };

      // Key Subjects
      final ks = courseData.keySubjects;
      final ksIds = <int>[];
      for (int i = 0; i < ks.length; i++) {
        final kid = keySubjectStart + i;
        ksIds.add(kid);
        nodeHierarchy[kid] = {
          'data': {'type': 'keySubject', 'title': ks[i], 'subtitle': ''},
          'children': <int>[],
          'color': Colors.blueAccent,
        };
      }
      nodeHierarchy[keySubjectsCategoryId] = {
        'data': {'type': 'category', 'title': 'Key Subjects', 'subtitle': ''},
        'children': ksIds,
        'color': Colors.blueAccent,
      };

      // Career Paths with subcategories
      final cp = courseData.careerPaths;
      int catPtr = careerCategoryStart;
      final cpCategoryIds = <int>[];

      void addListCategory(
        String title,
        List<String> items,
        Color color,
        String type,
      ) {
        if (items.isEmpty) return;
        final thisCategoryId = catPtr;
        catPtr += 100;
        cpCategoryIds.add(thisCategoryId);

        final itemIds = <int>[];
        int itemStart = thisCategoryId + 1;
        for (int i = 0; i < items.length; i++) {
          final iid = itemStart + i;
          itemIds.add(iid);
          nodeHierarchy[iid] = {
            'data': {'type': type, 'title': items[i], 'subtitle': ''},
            'children': <int>[],
            'color': color,
          };
        }

        nodeHierarchy[thisCategoryId] = {
          'data': {'type': 'category', 'title': title, 'subtitle': ''},
          'children': itemIds,
          'color': color,
        };
      }

      addListCategory('Industries', cp.industries, Colors.blue, 'industry');
      addListCategory('Job Roles', cp.jobRoles, Colors.green, 'job');
      addListCategory(
        'Government Exams',
        cp.governmentExams,
        Colors.orange,
        'exam',
      );
      addListCategory(
        'Entrepreneurship',
        cp.entrepreneurialOptions,
        Colors.red,
        'entrepreneur',
      );
      addListCategory(
        'Higher Education',
        cp.higherEducation,
        Colors.purple,
        'degree',
      );

      nodeHierarchy[careerPathsCategoryId] = {
        'data': {'type': 'category', 'title': 'Career Paths', 'subtitle': ''},
        'children': cpCategoryIds,
        'color': Colors.indigo,
      };

      nodeHierarchy[courseNodeId]['children'] = [
        specializationCategoryId,
        keySubjectsCategoryId,
        careerPathsCategoryId,
      ];

      courseIndex++;
    });

    _finalizeHierarchy();
  }

  void _finalizeHierarchy() {
    nodeData.clear();
    nodeChildren.clear();
    nodeParent.clear();

    nodeHierarchy.forEach((nodeId, nodeInfo) {
      nodeData[nodeId] = Map<String, dynamic>.from(nodeInfo['data'] as Map);
      nodeChildren[nodeId] = List<int>.from(nodeInfo['children'] as List);
      for (int childId in nodeChildren[nodeId]!) {
        nodeParent[childId] = nodeId;
      }
    });
  }

  void _initializeRootNode() {
    final nodes = List.from(graph.nodes);
    for (final n in nodes) {
      graph.removeNode(n);
    }

    final rootNode = Node.Id(0);
    graph.addNode(rootNode);
  }

  Widget rectangleWidget(int nodeId) {
    final data = nodeData[nodeId];
    if (data == null) return Container();

    final type = (data['type'] ?? 'unknown') as String;
    final title = (data['title'] ?? '') as String;
    final subtitle = (data['subtitle'] ?? '') as String;

    final isExpanded = expandedNodes.contains(nodeId);
    final hasChildren = (nodeChildren[nodeId]?.isNotEmpty ?? false);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: (type == 'start' && hasChildren && !isExpanded)
              ? _pulseAnimation.value
              : 1.0,
          child: _buildNodeCard(
            nodeId,
            type,
            title,
            subtitle,
            isExpanded,
            hasChildren,
          ),
        );
      },
    );
  }

  Widget _buildNodeCard(
    int nodeId,
    String type,
    String title,
    String subtitle,
    bool isExpanded,
    bool hasChildren,
  ) {
    final nodeStyle = _getNodeStyle(type);

    return GFCard(
      margin: const EdgeInsets.all(4),
      elevation: isExpanded ? 8 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: InkWell(
        onTap: hasChildren ? () => _expandNode(nodeId) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: nodeStyle.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: BoxConstraints(
            minWidth: _getNodeWidth(type),
            maxWidth: _getNodeMaxWidth(type),
            minHeight: _getNodeHeight(type),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: type == 'category'
                ? 20
                : (type == 'course_option_detail' ? 16 : 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and expansion indicator row
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      nodeStyle.icon,
                      color: nodeStyle.textColor,
                      size: type == 'course_option_detail' ? 24 : 20,
                    ),
                  ),
                  if (hasChildren) ...[
                    const SizedBox(width: 8),
                    GFBadge(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: GFBadgeShape.circle,
                      child: Icon(
                        isExpanded
                            ? LucideIcons.chevron_up
                            : LucideIcons.chevron_down,
                        color: nodeStyle.backgroundColor,
                        size: 14,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style: TextStyle(
                  color: nodeStyle.textColor,
                  fontSize: _getFontSize(type),
                  fontWeight: _getFontWeight(type),
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Subtitle (if exists)
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: nodeStyle.textColor.withValues(alpha: 0.8),
                    fontSize: _getFontSize(type) - 2,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Progress indicator for expanded nodes
              if (isExpanded) ...[
                const SizedBox(height: 8),
                GFProgressBar(
                  percentage: 1,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  progressBarColor: Colors.white,
                  lineHeight: 3,
                  radius: 1.5,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  NodeStyle _getNodeStyle(String type) {
    switch (type) {
      case 'start':
        return NodeStyle(
          backgroundColor: const Color(0xFF00838F), // Cyan 700
          textColor: Colors.white,
          icon: LucideIcons.flag,
        );
      case 'after10th':
        return NodeStyle(
          backgroundColor: const Color(0xFF00695C), // Teal 700
          textColor: Colors.white,
          icon: LucideIcons.graduation_cap,
        );
      case 'after12th':
        return NodeStyle(
          backgroundColor: const Color(0xFF3F51B5), // Indigo
          textColor: Colors.white,
          icon: LucideIcons.book_open,
        );
      case 'course_option_detail':
        return NodeStyle(
          backgroundColor: const Color(0xFF7B1FA2), // Purple 700
          textColor: Colors.white,
          icon: LucideIcons.book,
        );
      case 'category':
        return NodeStyle(
          backgroundColor: const Color(0xFF455A64), // Blue Grey 700
          textColor: Colors.white,
          icon: LucideIcons.folder_open,
        );
      case 'subject':
        return NodeStyle(
          backgroundColor: const Color(0xFF546E7A), // Blue Grey 600
          textColor: Colors.white,
          icon: LucideIcons.file_text,
        );
      case 'entranceExam':
        return NodeStyle(
          backgroundColor: const Color(0xFFE65100), // Deep Orange 900
          textColor: Colors.white,
          icon: LucideIcons.clipboard_list,
        );
      case 'specialization':
        return NodeStyle(
          backgroundColor: const Color(0xFF00897B), // Teal 600
          textColor: Colors.white,
          icon: LucideIcons.star,
        );
      case 'keySubject':
        return NodeStyle(
          backgroundColor: const Color(0xFF1976D2), // Blue 700
          textColor: Colors.white,
          icon: LucideIcons.bookmark,
        );
      case 'industry':
        return NodeStyle(
          backgroundColor: const Color(0xFF1565C0), // Blue 800
          textColor: Colors.white,
          icon: LucideIcons.building,
        );
      case 'job':
        return NodeStyle(
          backgroundColor: const Color(0xFF2E7D32), // Green 800
          textColor: Colors.white,
          icon: LucideIcons.briefcase,
        );
      case 'exam':
        return NodeStyle(
          backgroundColor: const Color(0xFFEF6C00), // Orange 800
          textColor: Colors.white,
          icon: LucideIcons.clipboard_check,
        );
      case 'degree':
        return NodeStyle(
          backgroundColor: const Color(0xFF6A1B9A), // Purple 800
          textColor: Colors.white,
          icon: LucideIcons.award,
        );
      case 'entrepreneur':
        return NodeStyle(
          backgroundColor: const Color(0xFFD32F2F), // Red 700
          textColor: Colors.white,
          icon: LucideIcons.lightbulb,
        );
      default:
        return NodeStyle(
          backgroundColor: const Color(0xFF757575), // Grey 600
          textColor: Colors.white,
          icon: LucideIcons.info,
        );
    }
  }

  double _getNodeWidth(String type) {
    switch (type) {
      case 'start':
      case 'course_option_detail':
      case 'category':
        return 220;
      case 'after10th':
      case 'after12th':
        return 180;
      default:
        return 160;
    }
  }

  double _getNodeMaxWidth(String type) => 280;

  double _getNodeHeight(String type) {
    switch (type) {
      case 'start':
        return 90;
      case 'category':
        return 85;
      case 'course_option_detail':
        return 80;
      default:
        return 70;
    }
  }

  double _getFontSize(String type) {
    switch (type) {
      case 'start':
        return 16;
      case 'after10th':
      case 'after12th':
      case 'course_option_detail':
        return 14;
      default:
        return 13;
    }
  }

  FontWeight _getFontWeight(String type) {
    switch (type) {
      case 'start':
      case 'category':
        return FontWeight.bold;
      case 'course_option_detail':
        return FontWeight.w600;
      default:
        return FontWeight.w500;
    }
  }

  void resetGraph() {
    setState(() {
      expandedNodes.clear();
      hiddenNodes.clear();
      final nodes = List.from(graph.nodes);
      for (final node in nodes) {
        if (node.key?.value != 0) {
          graph.removeNode(node);
        }
      }
    });
    _centerGraph();

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(LucideIcons.refresh_cw, color: Colors.white),
              SizedBox(width: 8),
              Text('Graph reset successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    widget.onResetGraph?.call();
  }

  void _expandNode(int nodeId) {
    if (expandedNodes.contains(nodeId)) {
      _collapseNode(nodeId);
    } else {
      _expandNodeImpl(nodeId);
    }
  }

  void _expandNodeImpl(int nodeId) {
    expandedNodes.add(nodeId);
    final parentNode = Node.Id(nodeId);
    final children = nodeChildren[nodeId] ?? [];

    final parent = nodeParent[nodeId];
    if (parent != null) {
      final siblings = nodeChildren[parent] ?? [];
      for (int siblingId in siblings) {
        if (siblingId != nodeId) {
          _hideNodeAndDescendants(siblingId);
        }
      }
    }

    for (int childId in children) {
      final childNode = Node.Id(childId);
      final nodeInfo = nodeHierarchy[childId];
      final color = nodeInfo?['color'] ?? Colors.grey;
      graph.addEdge(
        parentNode,
        childNode,
        paint: Paint()
          ..color = color.withValues(alpha: 0.7)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    setState(() {});
    _centerGraph();
  }

  void _collapseNode(int nodeId) {
    expandedNodes.remove(nodeId);

    final children = nodeChildren[nodeId] ?? [];
    for (int childId in children) {
      _removeNodeAndDescendants(childId);
    }

    final parent = nodeParent[nodeId];
    if (parent != null) {
      final siblings = nodeChildren[parent] ?? [];
      for (int siblingId in siblings) {
        if (siblingId != nodeId) {
          _showNodeAndDescendants(siblingId);
        }
      }
    }

    setState(() {});
    _centerGraph();
  }

  void _centerGraph() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _transformationController.value = Matrix4.identity();
      }
    });
  }

  void _hideNodeAndDescendants(int nodeId) {
    hiddenNodes.add(nodeId);
    final node = Node.Id(nodeId);
    if (graph.contains(node: node)) {
      graph.removeNode(node);
    }
    final children = nodeChildren[nodeId] ?? [];
    for (int childId in children) {
      _hideNodeAndDescendants(childId);
    }
  }

  void _showNodeAndDescendants(int nodeId) {
    hiddenNodes.remove(nodeId);
    final parent = nodeParent[nodeId];
    if (parent == null ||
        (expandedNodes.contains(parent) && !hiddenNodes.contains(parent))) {
      final parentNode = Node.Id(parent!);
      final childNode = Node.Id(nodeId);
      final nodeInfo = nodeHierarchy[nodeId];
      final color = nodeInfo?['color'] ?? Colors.grey;
      if (!graph.contains(node: childNode)) {
        graph.addEdge(
          parentNode,
          childNode,
          paint: Paint()
            ..color = color.withOpacity(0.7)
            ..strokeWidth = 2.0,
        );
      }
    }
  }

  void _removeNodeAndDescendants(int nodeId) {
    final node = Node.Id(nodeId);
    if (graph.contains(node: node)) {
      graph.removeNode(node);
    }
    expandedNodes.remove(nodeId);
    final children = nodeChildren[nodeId] ?? [];
    for (int childId in children) {
      _removeNodeAndDescendants(childId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        ),
      ),
      child: ClipRect(
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(40),
          minScale: 0.1,
          maxScale: 3.0,
          constrained: false,
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(
              builder,
              TreeEdgeRenderer(builder),
            ),
            paint: Paint()
              ..color = Colors.grey.shade400
              ..strokeWidth = 2.0
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              final nodeId = (node.key?.value as int?) ?? 0;
              return rectangleWidget(nodeId);
            },
          ),
        ),
      ),
    );
  }
}

class NodeStyle {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  NodeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}
