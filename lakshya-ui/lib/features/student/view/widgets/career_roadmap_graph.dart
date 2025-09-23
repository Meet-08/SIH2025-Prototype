// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:getwidget/getwidget.dart';
import 'package:graphview/GraphView.dart';
import 'package:lakshya/features/student/models/career_map_model.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class CareerRoadmapGraph extends StatefulWidget {
  final CareerMapModel careerMapModel;
  final VoidCallback? onResetGraph;
  final VoidCallback? onShowHelp;

  const CareerRoadmapGraph({
    super.key,
    this.onResetGraph,
    this.onShowHelp,
    required this.careerMapModel,
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

  // Keys to measure node positions and viewer
  final Map<int, GlobalKey> _nodeKeys = {};
  final GlobalKey _viewerKey = GlobalKey();

  late Map<int, dynamic> nodeHierarchy;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Scale bounds
  final double _minScale = 0.2;
  final double _maxScale = 3.0;

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
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _transformationController.dispose();
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
      final baseCourseId = 1000 + courseIndex * 1000;
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
    if (data == null) return const SizedBox();

    final type = (data['type'] ?? 'unknown') as String;
    final title = (data['title'] ?? '') as String;
    final subtitle = (data['subtitle'] ?? '') as String;

    final isExpanded = expandedNodes.contains(nodeId);
    final hasChildren = (nodeChildren[nodeId]?.isNotEmpty ?? false);

    // Ensure a GlobalKey for this node exists
    final key = _nodeKeys.putIfAbsent(nodeId, () => GlobalKey());

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: (type == 'start' && hasChildren && !isExpanded)
              ? _pulseAnimation.value
              : 1.0,
          child: Container(
            key: key,
            child: _buildNodeCard(
              nodeId,
              type,
              title,
              subtitle,
              isExpanded,
              hasChildren,
            ),
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
                      color: Colors.white.withValues(alpha: 0.12),
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
                    color: nodeStyle.textColor.withValues(alpha: 0.88),
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
          backgroundColor: const Color(0xFF1E88E5),
          textColor: Colors.white,
          icon: LucideIcons.play,
        );
      case 'after10th':
        return NodeStyle(
          backgroundColor: const Color(0xFF43A047),
          textColor: Colors.white,
          icon: LucideIcons.school,
        );
      case 'after12th':
        return NodeStyle(
          backgroundColor: const Color(0xFF5E35B1),
          textColor: Colors.white,
          icon: LucideIcons.graduation_cap,
        );
      case 'course_option_detail':
        return NodeStyle(
          backgroundColor: const Color(0xFF8E24AA),
          textColor: Colors.white,
          icon: LucideIcons.book_open,
        );
      case 'category':
        return NodeStyle(
          backgroundColor: const Color(0xFF5C6BC0),
          textColor: Colors.white,
          icon: LucideIcons.layers,
        );
      case 'subject':
        return NodeStyle(
          backgroundColor: const Color(0xFF42A5F5),
          textColor: Colors.white,
          icon: LucideIcons.library,
        );
      case 'entranceExam':
        return NodeStyle(
          backgroundColor: const Color(0xFFE65100),
          textColor: Colors.white,
          icon: LucideIcons.file_text,
        );
      case 'specialization':
        return NodeStyle(
          backgroundColor: const Color(0xFF26A69A),
          textColor: Colors.white,
          icon: LucideIcons.target,
        );
      case 'keySubject':
        return NodeStyle(
          backgroundColor: const Color(0xFF3F51B5),
          textColor: Colors.white,
          icon: LucideIcons.bookmark,
        );
      case 'industry':
        return NodeStyle(
          backgroundColor: const Color(0xFF00796B),
          textColor: Colors.white,
          icon: LucideIcons.factory,
        );
      case 'job':
        return NodeStyle(
          backgroundColor: const Color(0xFF388E3C),
          textColor: Colors.white,
          icon: LucideIcons.user_check,
        );
      case 'exam':
        return NodeStyle(
          backgroundColor: const Color(0xFFD84315),
          textColor: Colors.white,
          icon: LucideIcons.shield_check,
        );
      case 'degree':
        return NodeStyle(
          backgroundColor: const Color(0xFF512DA8),
          textColor: Colors.white,
          icon: LucideIcons.scroll,
        );
      case 'entrepreneur':
        return NodeStyle(
          backgroundColor: const Color(0xFFD32F2F),
          textColor: Colors.white,
          icon: LucideIcons.lightbulb,
        );
      default:
        return NodeStyle(
          backgroundColor: const Color(0xFF607D8B),
          textColor: Colors.white,
          icon: LucideIcons.circle,
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
    _resetView();

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
          ..color = (color as Color).withValues(alpha: 0.75)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    setState(() {});
    _focusOnNode(nodeId);
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
    _focusOnNode(nodeParent[nodeId] ?? 0);
  }

  /// Focus on node by computing the node's on-screen center and animating the
  /// InteractiveViewer transformation so the node becomes centered (clamped).
  void _focusOnNode(int nodeId) {
    // Slight delay to let the layout reflow after adding nodes.
    Future.delayed(const Duration(milliseconds: 120), () async {
      if (!mounted) return;

      final nodeKey = _nodeKeys[nodeId];
      final viewerContext = _viewerKey.currentContext;
      final nodeContext = nodeKey?.currentContext;

      if (viewerContext == null || nodeContext == null) {
        // fallback: nudge a bit
        _animateSmallNudge();
        return;
      }

      final viewerBox = viewerContext.findRenderObject() as RenderBox;
      final nodeBox = nodeContext.findRenderObject() as RenderBox?;

      if (nodeBox == null) {
        _animateSmallNudge();
        return;
      }

      // Node center in global coordinates
      final nodeTopLeftGlobal = nodeBox.localToGlobal(Offset.zero);
      final nodeCenterGlobal =
          nodeTopLeftGlobal +
          Offset(nodeBox.size.width / 2, nodeBox.size.height / 2);

      // Viewer center in global coordinates
      final viewerTopLeftGlobal = viewerBox.localToGlobal(Offset.zero);
      final viewerCenterGlobal =
          viewerTopLeftGlobal +
          Offset(viewerBox.size.width / 2, viewerBox.size.height / 2);

      final deltaGlobal = nodeCenterGlobal - viewerCenterGlobal;

      // Current matrix and its inverse
      final current = Matrix4.fromList(_transformationController.value.storage);
      final inv = Matrix4.fromList(current.storage);
      // ignore: unrelated_type_equality_checks
      final bool invertible = inv.invert() == true;

      if (!invertible) {
        _animateSmallNudge();
        return;
      }

      final v.Vector3 deltaLocalVec = inv.transform3(
        v.Vector3(deltaGlobal.dx, deltaGlobal.dy, 0),
      );

      // Compute target scale (optionally adjust to show children)
      final double currentScale = _getScaleFromMatrix(current);
      double targetScale = currentScale;
      // if too zoomed out, slightly zoom in when focusing on a node with children
      if (expandedNodes.contains(nodeId) && currentScale < 0.85) {
        targetScale = math.min(0.95, _maxScale);
      }
      targetScale = targetScale.clamp(_minScale, _maxScale);

      // Build target matrix: start from current and translate by -deltaLocal
      final Matrix4 target = Matrix4.fromList(current.storage);

      // If scale needs to change, create composed matrices without using deprecated methods
      if ((targetScale - currentScale).abs() > 0.001) {
        // We'll scale about the viewer center: translate -> scale -> translate back
        final Offset viewerCenterLocal = inv
            .transform3(
              v.Vector3(viewerCenterGlobal.dx, viewerCenterGlobal.dy, 0),
            )
            .let((v) => Offset(v.x, v.y));

        // Build translation and scale matrices explicitly
        final Matrix4 toViewerCenter = Matrix4.translationValues(
          viewerCenterLocal.dx,
          viewerCenterLocal.dy,
          0.0,
        );
        final Matrix4 scaleMat = Matrix4.diagonal3Values(
          targetScale,
          targetScale,
          1.0,
        );
        final Matrix4 fromViewerCenter = Matrix4.translationValues(
          -viewerCenterLocal.dx,
          -viewerCenterLocal.dy,
          0.0,
        );

        // Compose: T(viewerCenter) * S(scale) * T(-viewerCenter)
        final Matrix4 composed = Matrix4.identity();
        composed.multiply(toViewerCenter);
        composed.multiply(scaleMat);
        composed.multiply(fromViewerCenter);

        // apply current transform afterwards and then translate by -deltaLocal
        composed.multiply(target);
        composed.multiply(
          Matrix4.translationValues(-deltaLocalVec.x, -deltaLocalVec.y, 0.0),
        );

        _clampAndAnimateToMatrix(composed);
      } else {
        // No scale change - simply translate by -deltaLocalVec (use translation matrix)
        target.multiply(
          Matrix4.translationValues(-deltaLocalVec.x, -deltaLocalVec.y, 0.0),
        );
        _clampAndAnimateToMatrix(target);
      }
    });
  }

  // Small smooth nudge when we cannot compute exact location.
  void _animateSmallNudge() {
    final Matrix4 current = Matrix4.fromList(
      _transformationController.value.storage,
    );
    final Matrix4 t = Matrix4.fromList(current.storage);
    // small upward translation
    t.translateByVector3(v.Vector3(0.0, -40.0, 0.0));
    _clampAndAnimateToMatrix(t);
  }

  double _getScaleFromMatrix(Matrix4 m) {
    // assume uniform scaling and no rotation. Use m.storage[0]
    final storage = m.storage;
    return storage[0].abs();
  }

  void _clampAndAnimateToMatrix(Matrix4 targetRaw) {
    if (!mounted) return;

    // Extract scale and clamp it
    final double scale = _getScaleFromMatrix(
      targetRaw,
    ).clamp(_minScale, _maxScale);

    // Normalize targetRaw scale to clamped scale while preserving translation proportion
    final Matrix4 normalized = Matrix4.identity();
    // We'll compute translation so that normalized * child = desired. Simpler approach:
    // create a new matrix with clamped scale and copy rotation if any (rotation unlikely).
    normalized.multiply(Matrix4.diagonal3Values(scale, scale, 1.0));

    // Try to copy translation components from targetRaw adjusted for scale difference.
    // Extract translation from targetRaw
    final tx = targetRaw.storage[12];
    final ty = targetRaw.storage[13];

    // When scale changed, translation must be adjusted. We'll set normalized translation to tx,ty
    normalized.setTranslationRaw(tx, ty, targetRaw.storage[14]);

    // Clamp translation magnitude to avoid runaway values (very large graphs)
    const double maxTranslate = 20000;
    final clampedTx = normalized.storage[12].clamp(-maxTranslate, maxTranslate);
    final clampedTy = normalized.storage[13].clamp(-maxTranslate, maxTranslate);
    normalized.setTranslationRaw(clampedTx, clampedTy, normalized.storage[14]);

    _animateToMatrix(normalized);
  }

  void _resetView() {
    if (mounted) {
      final targetMatrix = Matrix4.identity();
      _animateToMatrix(targetMatrix);
    }
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    final currentMatrix = _transformationController.value;

    // Create a Tween for smooth matrix transformation
    final AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final Animation<Matrix4> animation =
        Matrix4Tween(begin: currentMatrix, end: targetMatrix).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
        );

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
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
            ..color = (color as Color).withValues(alpha: 0.75)
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
          key: _viewerKey,
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(1000),
          minScale: _minScale,
          maxScale: _maxScale,
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

// tiny helper to use returned Vector3 from transform3 inline
extension _Let<T> on T {
  R let<R>(R Function(T) fn) => fn(this);
}
