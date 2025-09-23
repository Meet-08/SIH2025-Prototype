// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

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
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _initializeBuilder() {
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 120
      ..levelSeparation = 160
      ..subtreeSeparation = 140
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  void _initializeHierarchy() {
    nodeHierarchy = {};

    // Root - Using orange theme
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
        'title': 'Science Stream',
        'subtitle': 'PCM / PCB / PCMB',
      },
      'children': [],
    };

    // Subjects under After 10th
    final subjects = widget.careerMapModel.after10th.subjects;
    final after10SubjectsChildren = <int>[];
    int subjectIdStart = 101;
    for (int i = 0; i < subjects.length; i++) {
      final subjectId = subjectIdStart + i;
      nodeHierarchy[subjectId] = {
        'data': {
          'type': 'subject',
          'title': subjects[i],
          'subtitle': '',
        },
        'children': [],
      };
      after10SubjectsChildren.add(subjectId);
    }
    nodeHierarchy[1]!['children'] = after10SubjectsChildren;

    // After 12th Node
    nodeHierarchy[2] = {
      'data': {
        'type': 'after12th',
        'title': 'After 12th',
        'subtitle': 'Choose your path',
      },
      'children': [200, 300],
    };

    // Entrance exams category (200)
    final exams = widget.careerMapModel.after12th.entranceExams;
    final examChildIds = <int>[];
    int examStart = 201;
    for (int i = 0; i < exams.length; i++) {
      final examId = examStart + i;
      nodeHierarchy[examId] = {
        'data': {'type': 'entranceExam', 'title': exams[i], 'subtitle': ''},
        'children': [],
      };
      examChildIds.add(examId);
    }
    nodeHierarchy[200] = {
      'data': {'type': 'category', 'title': 'Entrance Exams', 'subtitle': ''},
      'children': examChildIds,
    };

    // Course Options category placeholder (300)
    nodeHierarchy[300] = {
      'data': {
        'type': 'category',
        'title': 'Course Options',
        'subtitle': 'Available courses',
      },
      'children': [],
    };

    // Courses (detailed nodes)
    final courses = widget.careerMapModel.courses;
    int courseIndex = 0;
    courses.forEach((courseKey, courseData) {
      final courseId = 1000 + courseIndex;
      
      // Create main course node
      nodeHierarchy[courseId] = {
        'data': {
          'type': 'course_option_detail',
          'title': courseKey,
          'subtitle': courseData.duration,
        },
        'children': [],
      };

      // Add specializations
      final specializations = courseData.specializations;
      final specializationIds = <int>[];
      for (int i = 0; i < specializations.length; i++) {
        final specId = courseId * 10 + i + 1;
        nodeHierarchy[specId] = {
          'data': {
            'type': 'specialization',
            'title': specializations[i],
            'subtitle': '',
          },
          'children': [],
        };
        specializationIds.add(specId);

        // Add career paths for each specialization
        final careerPaths = courseData.careerPaths;
        final careerIds = <int>[];
        final careerPathsList = careerPaths.jobRoles.take(3).toList();
        for (int j = 0; j < careerPathsList.length; j++) {
          final careerId = specId * 10 + j + 1;
          nodeHierarchy[careerId] = {
            'data': {
              'type': 'job',
              'title': careerPathsList[j],
              'subtitle': '',
            },
            'children': [],
          };
          careerIds.add(careerId);
        }
        if (careerIds.isNotEmpty) {
          nodeHierarchy[specId]!['children'] = careerIds;
        }
      }

      if (specializationIds.isNotEmpty) {
        nodeHierarchy[courseId]!['children'] = specializationIds;
      }

      nodeHierarchy[300]!['children'].add(courseId);
      courseIndex++;
    });

    _finalizeHierarchy();
  }

  void _finalizeHierarchy() {
    nodeData.clear();
    nodeChildren.clear();
    nodeParent.clear();

    nodeHierarchy.forEach((nodeId, nodeInfo) {
      nodeData[nodeId] = nodeInfo['data'];
      final children = (nodeInfo['children'] as List<int>?) ?? [];
      nodeChildren[nodeId] = children;
      for (int childId in children) {
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
      animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
      builder: (context, child) {
        final scale = nodeId == 0 ? _pulseAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: _buildModernNodeCard(
            nodeId,
            type,
            title,
            subtitle,
            isExpanded,
            hasChildren,
            key,
          ),
        );
      },
    );
  }

  Widget _buildModernNodeCard(
    int nodeId,
    String type,
    String title,
    String subtitle,
    bool isExpanded,
    bool hasChildren,
    GlobalKey key,
  ) {
    final nodeStyle = _getModernNodeStyle(type);
    final isRootNode = nodeId == 0;

    return Container(
      key: key,
      width: _getNodeWidth(type),
      constraints: BoxConstraints(
        maxWidth: _getNodeMaxWidth(type),
        minHeight: _getNodeHeight(type),
      ),
      child: GestureDetector(
        onTap: hasChildren ? () => _expandNode(nodeId) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isExpanded ? 0.6 : 0.3),
              width: isExpanded ? 2.5 : 1.5,
            ),
            boxShadow: [
              // Neumorphism light shadow
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                blurRadius: isExpanded ? 20 : 15,
                offset: Offset(
                  isExpanded ? -8 : -6,
                  isExpanded ? -8 : -6,
                ),
              ),
              // Neumorphism dark shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: isExpanded ? 20 : 15,
                offset: Offset(
                  isExpanded ? 8 : 6,
                  isExpanded ? 8 : 6,
                ),
              ),
              // Orange glow for root and expanded nodes
              if (isRootNode || isExpanded)
                BoxShadow(
                  color: nodeStyle.primaryColor.withOpacity(
                    isRootNode ? _glowAnimation.value : 0.4,
                  ),
                  blurRadius: isRootNode ? 25 : 20,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: nodeStyle.gradient,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                        Colors.black.withOpacity(0.05),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon and expansion indicator row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              nodeStyle.icon,
                              color: Colors.white,
                              size: type == 'course_option_detail' ? 28 : 24,
                            ),
                          ),
                          if (hasChildren) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isExpanded
                                    ? LucideIcons.chevron_up
                                    : LucideIcons.chevron_down,
                                color: nodeStyle.primaryColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title with enhanced styling
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _getFontSize(type),
                          fontWeight: _getFontWeight(type),
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Subtitle (if exists)
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: _getFontSize(type) - 2,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Progress indicator for expanded nodes
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white,
                                Colors.white.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ModernNodeStyle _getModernNodeStyle(String type) {
    // Base orange gradient colors from the feature card
    const primaryOrange = Color(0xFFFF9500);
    const secondaryOrange = Color(0xFFFF6B35);
    
    switch (type) {
      case 'start':
        return ModernNodeStyle(
          primaryColor: primaryOrange,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryOrange, secondaryOrange],
          ),
          icon: LucideIcons.play,
        );
      case 'after10th':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF8C00),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF8C00),
              const Color(0xFFFF7F50),
            ],
          ),
          icon: LucideIcons.school,
        );
      case 'after12th':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF7F50),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF7F50),
              const Color(0xFFFF6347),
            ],
          ),
          icon: LucideIcons.graduation_cap,
        );
      case 'course_option_detail':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF6347),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6347),
              const Color(0xFFFF4500),
            ],
          ),
          icon: LucideIcons.book_open,
        );
      case 'category':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF7043),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF7043),
              const Color(0xFFFF5722),
            ],
          ),
          icon: LucideIcons.layers,
        );
      case 'subject':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF8A65),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF8A65),
              const Color(0xFFFF7043),
            ],
          ),
          icon: LucideIcons.book,
        );
      case 'entranceExam':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF9800),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF9800),
              const Color(0xFFFF8F00),
            ],
          ),
          icon: LucideIcons.file_text,
        );
      case 'specialization':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFA726),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFA726),
              const Color(0xFFFF9800),
            ],
          ),
          icon: LucideIcons.target,
        );
      case 'keySubject':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFB74D),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFB74D),
              const Color(0xFFFFA726),
            ],
          ),
          icon: LucideIcons.bookmark,
        );
      case 'industry':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFCC02),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFCC02),
              const Color(0xFFFFB300),
            ],
          ),
          icon: LucideIcons.building,
        );
      case 'job':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFD54F),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFD54F),
              const Color(0xFFFFCC02),
            ],
          ),
          icon: LucideIcons.briefcase,
        );
      case 'exam':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFE082),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFE082),
              const Color(0xFFFFD54F),
            ],
          ),
          icon: LucideIcons.shield_check,
        );
      case 'degree':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFFF59D),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF59D),
              const Color(0xFFFFE082),
            ],
          ),
          icon: LucideIcons.scroll,
        );
      case 'entrepreneur':
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF5722),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF5722),
              const Color(0xFFE64A19),
            ],
          ),
          icon: LucideIcons.lightbulb,
        );
      default:
        return ModernNodeStyle(
          primaryColor: const Color(0xFFFF9500),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF9500).withOpacity(0.8),
              const Color(0xFFFF6B35).withOpacity(0.8),
            ],
          ),
          icon: LucideIcons.circle,
        );
    }
  }

  double _getNodeWidth(String type) {
    switch (type) {
      case 'start':
      case 'course_option_detail':
      case 'category':
        return 240;
      case 'after10th':
      case 'after12th':
        return 200;
      default:
        return 180;
    }
  }

  double _getNodeMaxWidth(String type) => 300;

  double _getNodeHeight(String type) {
    switch (type) {
      case 'start':
        return 100;
      case 'course_option_detail':
        return 110;
      case 'category':
        return 95;
      default:
        return 85;
    }
  }

  double _getFontSize(String type) {
    switch (type) {
      case 'start':
        return 18;
      case 'course_option_detail':
        return 16;
      case 'category':
        return 15;
      default:
        return 14;
    }
  }

  FontWeight _getFontWeight(String type) {
    switch (type) {
      case 'start':
        return FontWeight.w800;
      case 'course_option_detail':
      case 'category':
        return FontWeight.w700;
      default:
        return FontWeight.w600;
    }
  }

  void resetGraph() {
    setState(() {
      expandedNodes.clear();
      hiddenNodes.clear();
      _initializeRootNode();
    });
    _resetView();

    // Show success feedback with orange theme
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Graph reset successfully!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFFFF9500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
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
      final parentNodeObj = Node.Id(parent);
      if (!graph.contains(edge: Edge(parentNodeObj, parentNode))) {
        graph.addEdge(parentNodeObj, parentNode);
      }
    }

    for (int childId in children) {
      final childNode = Node.Id(childId);
      if (!graph.contains(node: childNode)) {
        graph.addNode(childNode);
      }
      if (!graph.contains(edge: Edge(parentNode, childNode))) {
        graph.addEdge(parentNode, childNode);
      }
      hiddenNodes.remove(childId);
    }

    setState(() {});
    _focusOnNode(nodeId);
  }

  void _collapseNode(int nodeId) {
    expandedNodes.remove(nodeId);

    final children = nodeChildren[nodeId] ?? [];
    for (int childId in children) {
      _hideNodeAndDescendants(childId);
    }

    final parent = nodeParent[nodeId];
    if (parent != null) {
      final parentNode = Node.Id(parent);
      final currentNode = Node.Id(nodeId);
      if (graph.contains(edge: Edge(parentNode, currentNode))) {
        graph.removeEdge(Edge(parentNode, currentNode));
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
      final viewerKey = _viewerKey;

      if (nodeKey?.currentContext == null || viewerKey.currentContext == null) {
        _animateSmallNudge();
        return;
      }

      try {
        final nodeBox = nodeKey!.currentContext!.findRenderObject() as RenderBox?;
        final viewerBox = viewerKey.currentContext!.findRenderObject() as RenderBox?;

        if (nodeBox == null || viewerBox == null) {
          _animateSmallNudge();
          return;
        }

        final nodeCenter = nodeBox.localToGlobal(
          Offset(nodeBox.size.width / 2, nodeBox.size.height / 2),
        );
        final viewerCenter = Offset(
          viewerBox.size.width / 2,
          viewerBox.size.height / 2,
        );

        final currentMatrix = Matrix4.fromList(
          _transformationController.value.storage,
        );
        final currentScale = _getScaleFromMatrix(currentMatrix);

        final translation = viewerCenter - nodeCenter;
        final targetMatrix = Matrix4.identity()
          ..scale(currentScale)
          ..translate(translation.dx / currentScale, translation.dy / currentScale);

        _clampAndAnimateToMatrix(targetMatrix);
      } catch (e) {
        _animateSmallNudge();
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
    final double scale = _getScaleFromMatrix(targetRaw).clamp(_minScale, _maxScale);

    // Extract translation
    final targetStorage = targetRaw.storage;
    final tx = targetStorage[12];
    final ty = targetStorage[13];

    final Matrix4 clampedMatrix = Matrix4.identity()
      ..scale(scale)
      ..translate(tx, ty);

    _animateToMatrix(clampedMatrix);
  }

  void _resetView() {
    _animateToMatrix(Matrix4.identity());
  }

  Matrix4 _lerpMatrix4(Matrix4 a, Matrix4 b, double t) {
    final result = Matrix4.identity();
    for (int i = 0; i < 16; i++) {
      result.storage[i] = a.storage[i] + (b.storage[i] - a.storage[i]) * t;
    }
    return result;
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    if (!mounted) return;

    final Matrix4 startMatrix = Matrix4.fromList(
      _transformationController.value.storage,
    );

    late AnimationController animController;
    animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
    );

    animation.addListener(() {
      final t = animation.value;
      final interpolated = _lerpMatrix4(startMatrix, targetMatrix, t);
      if (mounted) {
        _transformationController.value = interpolated;
      }
    });

    animController.forward().then((_) => animController.dispose());
  }

  void _hideNodeAndDescendants(int nodeId) {
    hiddenNodes.add(nodeId);
    expandedNodes.remove(nodeId);

    final node = Node.Id(nodeId);
    if (graph.contains(node: node)) {
      graph.removeNode(node);
    }

    final children = nodeChildren[nodeId] ?? [];
    for (int childId in children) {
      _hideNodeAndDescendants(childId);
    }
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            const Color(0xFFFF9500).withOpacity(0.02),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: InteractiveViewer(
        key: _viewerKey,
        transformationController: _transformationController,
        minScale: _minScale,
        maxScale: _maxScale,
        boundaryMargin: const EdgeInsets.all(100),
        child: GraphView(
          graph: graph,
          algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
          paint: Paint()
            ..color = const Color(0xFFFF9500).withOpacity(0.6)
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke,
          builder: (Node node) {
            final nodeId = node.key!.value as int;
            return rectangleWidget(nodeId);
          },
        ),
      ),
    );
  }
}

class ModernNodeStyle {
  final Color primaryColor;
  final Gradient gradient;
  final IconData icon;

  ModernNodeStyle({
    required this.primaryColor,
    required this.gradient,
    required this.icon,
  });
}

