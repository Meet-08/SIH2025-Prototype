import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/theme/app_colors.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/core/theme/theme.dart';

// Visual size variants for FeatureCard
enum FeatureCardSize { compact, medium, large }

class FeatureCard extends StatefulWidget {
  final String title;
  final String? subtitle; // optional secondary line under title
  final String description;
  final IconData icon;
  final VoidCallback onTap; // primary tap
  final FeatureCardSize size;
  final Color? accentColor; // per-card color accent
  final Gradient? accentGradient; // optional per-card gradient

  const FeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.description,
    required this.icon,

    required this.onTap,
    this.size = FeatureCardSize.medium,
    this.accentColor,
    this.accentGradient,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(
        milliseconds: 140,
      ), // press scale timing per spec
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.985,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    final bool disableAnims =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!disableAnims) {
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    final bool disableAnims =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!disableAnims) {
      _pressController.reverse();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    final bool disableAnims =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!disableAnims) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accentColor ?? AppColors.colorPrimary500;
    final Gradient? accentGrad = widget.accentGradient;
    final BorderRadius borderRadius;
    final EdgeInsetsGeometry contentPadding;
    final double minHeight;
    switch (widget.size) {
      case FeatureCardSize.compact:
        borderRadius = BorderRadius.circular(20);
        contentPadding = const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        );
        minHeight = 180;
        break;
      case FeatureCardSize.medium:
        borderRadius = BorderRadius.circular(24);
        contentPadding = const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        );
        minHeight = 220;
        break;
      case FeatureCardSize.large:
        borderRadius = BorderRadius.circular(28);
        contentPadding = const EdgeInsets.all(24);
        minHeight = 260;
        break;
    }

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Semantics(
            // Accessibility pattern; replace placeholders with real metadata
            label: 'Open item: <title> — <meta>', // Example pattern from spec
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: borderRadius,
                splashColor: accent.withValues(alpha: 0.10),
                highlightColor: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(minHeight: minHeight),
                  margin: const EdgeInsets.all(4), // grid gutter compatibility
                  decoration: BoxDecoration(
                    color: Colors.transparent, // glass overlay handles fill
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(-8, -8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(8, 8),
                      ),
                      BoxShadow(
                        color: accent.withValues(alpha: _isPressed ? 0.3 : 0.2),
                        blurRadius: _isPressed ? 30 : 25,
                        offset: Offset(0, _isPressed ? 12 : 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: _isPressed ? 0.4 : 0.3,
                      ),
                      width: _isPressed ? 2 : 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Stack(
                      children: [
                        // Frosted glass blur backdrop
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: const SizedBox.shrink(),
                          ),
                        ),
                        // Gradient background overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient:
                                  accentGrad ??
                                  LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      accent.withValues(alpha: 0.8),
                                      accent.withValues(alpha: 0.6),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                        // No extra glass overlay; keep vibrant gradients like the design
                        const SizedBox.shrink(),
                        Padding(
                          padding: contentPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top centered icon badge
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 1.2,
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 14),
                              // Title centered
                              Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.h2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              // Description centered
                              Expanded(
                                child: Text(
                                  widget.description,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.35,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.18,
                                        ),
                                        offset: const Offset(0, 1),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Bottom-right circular '?' indicator
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.arrow_right,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
