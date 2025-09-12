import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../models/career_map_model.dart';

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

class _CareerRoadmapGraphState extends State<CareerRoadmapGraph> {
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

  @override
  void initState() {
    print(widget.careerMapModel.courses);
    super.initState();
    _initializeBuilder();
    _initializeHierarchy();
    _initializeRootNode();
  }

  void _initializeBuilder() {
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 80
      ..levelSeparation = 120
      ..subtreeSeparation = 100
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
      print(courseData.name);
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

    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? icon;

    switch (type) {
      case 'start':
        backgroundColor = Colors.teal.shade600;
        icon = Icons.flag;
        break;
      case 'after10th':
        backgroundColor = Colors.teal.shade700;
        icon = Icons.school;
        break;
      case 'after12th':
        backgroundColor = Colors.indigo.shade600;
        icon = Icons.assignment;
        break;
      case 'course_option_detail':
        backgroundColor = Colors.deepPurple.shade600;
        icon = Icons.menu_book;
        break;
      case 'category':
        backgroundColor = Colors.grey.shade700;
        icon = Icons.category;
        break;
      case 'subject':
        backgroundColor = Colors.blueGrey.shade600;
        icon = Icons.menu_book_outlined;
        break;
      case 'entranceExam':
        backgroundColor = Colors.orange.shade600;
        icon = Icons.gavel;
        break;
      case 'specialization':
        backgroundColor = Colors.teal.shade400;
        icon = Icons.star;
        break;
      case 'keySubject':
        backgroundColor = Colors.blueAccent.shade400;
        icon = Icons.list_alt;
        break;
      case 'industry':
        backgroundColor = Colors.blue.shade500;
        icon = Icons.business;
        break;
      case 'job':
        backgroundColor = Colors.green.shade500;
        icon = Icons.work;
        break;
      case 'exam':
        backgroundColor = Colors.orange.shade500;
        icon = Icons.quiz;
        break;
      case 'degree':
        backgroundColor = Colors.purple.shade500;
        icon = Icons.school_outlined;
        break;
      case 'entrepreneur':
        backgroundColor = Colors.red.shade500;
        icon = Icons.lightbulb;
        break;
      default:
        backgroundColor = Colors.grey.shade400;
        icon = Icons.help_outline;
    }

    return Material(
      elevation: expandedNodes.contains(nodeId) ? 6 : 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _expandNode(nodeId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: expandedNodes.contains(nodeId)
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: textColor,
                    size: type == 'course_option_detail' ? 24 : 20,
                  ),
                  if ((nodeChildren[nodeId]?.isNotEmpty ?? false) &&
                      !expandedNodes.contains(nodeId))
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: textColor,
                        size: 16,
                      ),
                    ),
                  if (expandedNodes.contains(nodeId))
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.remove_circle_outline,
                        color: textColor,
                        size: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: _getFontSize(type),
                  fontWeight: _getFontWeight(type),
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getNodeWidth(String type) {
    switch (type) {
      case 'start':
      case 'course_option_detail':
      case 'category':
        return 200;
      case 'after10th':
      case 'after12th':
        return 160;
      default:
        return 140;
    }
  }

  double _getNodeMaxWidth(String type) => 250;

  double _getNodeHeight(String type) {
    switch (type) {
      case 'category':
        return 80;
      default:
        return 60;
    }
  }

  double _getFontSize(String type) {
    switch (type) {
      case 'start':
        return 16;
      case 'after10th':
      case 'after12th':
        return 14;
      default:
        return 12;
    }
  }

  FontWeight _getFontWeight(String type) {
    switch (type) {
      case 'start':
        return FontWeight.bold;
      default:
        return FontWeight.normal;
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
      graph.addEdge(parentNode, childNode, paint: Paint()..color = color);
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
        graph.addEdge(parentNode, childNode, paint: Paint()..color = color);
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
    return ClipRect(
      child: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(20),
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
            ..color = Colors.grey
            ..strokeWidth = 1.0,
          builder: (Node node) {
            final nodeId = (node.key?.value as int?) ?? 0;
            return rectangleWidget(nodeId);
          },
        ),
      ),
    );
  }
}
