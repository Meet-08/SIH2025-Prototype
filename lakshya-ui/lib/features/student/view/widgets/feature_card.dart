import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/theme/app_colors.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/core/theme/theme.dart';

enum FeatureCardSize { compact, medium, large }

class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final FeatureCardSize size;
  final Color? accentColor;
  final Gradient? accentGradient;
  final String? imagePath;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.size = FeatureCardSize.medium,
    this.accentColor,
    this.accentGradient,
    this.imagePath,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _hoverController;
  late AnimationController _floatController;
  late Animation<double> _scale;
  late Animation<double> _hoverScale;
  late Animation<double> _floatOffset;
  late Animation<double> _glowIntensity;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Press animation
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    // Hover animation
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _floatOffset = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _glowIntensity = Tween<double>(begin: 0.15, end: 0.35).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start floating animation
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    _floatController.dispose();
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

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    final bool disableAnims =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!disableAnims) {
      if (hovering) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Color accent = widget.accentColor ?? AppColors.colorPrimary500;
    final Gradient? accentGrad = widget.accentGradient;

    // Responsive design calculations
    final bool isTablet = screenWidth > 600;
    final bool isDesktop = screenWidth > 1200;

    final BorderRadius borderRadius;
    final EdgeInsetsGeometry contentPadding;
    final double minHeight;
    final double iconSize;

    switch (widget.size) {
      case FeatureCardSize.compact:
        borderRadius = BorderRadius.circular(isDesktop ? 24 : 20);
        contentPadding = EdgeInsets.symmetric(
          horizontal: isDesktop ? 18 : 14,
          vertical: isDesktop ? 20 : 16,
        );
        minHeight = isDesktop ? 200 : (isTablet ? 190 : 180);
        iconSize = isDesktop ? 32 : (isTablet ? 30 : 28);
        break;
      case FeatureCardSize.medium:
        borderRadius = BorderRadius.circular(isDesktop ? 28 : 24);
        contentPadding = EdgeInsets.symmetric(
          horizontal: isDesktop ? 22 : 18,
          vertical: isDesktop ? 24 : 20,
        );
        minHeight = isDesktop ? 240 : (isTablet ? 230 : 220);
        iconSize = isDesktop ? 36 : (isTablet ? 34 : 32);
        break;
      case FeatureCardSize.large:
        borderRadius = BorderRadius.circular(isDesktop ? 32 : 28);
        contentPadding = EdgeInsets.all(isDesktop ? 28 : 24);
        minHeight = isDesktop ? 280 : (isTablet ? 270 : 260);
        iconSize = isDesktop ? 40 : (isTablet ? 38 : 36);
        break;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_scale, _hoverController, _floatController]),
      builder: (context, child) {
        final combinedScale = _scale.value * _hoverScale.value;
        final floatY =
            _floatOffset.value * (1.0 + 0.5 * _hoverController.value);

        return Transform.translate(
          offset: Offset(0, -floatY),
          child: Transform.scale(
            scale: combinedScale,
            child: Semantics(
              label: 'Feature card: ${widget.title}',
              button: true,
              child: Material(
                color: Colors.transparent,
                child: MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  child: InkWell(
                    onTap: widget.onTap,
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    onTapCancel: _onTapCancel,
                    borderRadius: borderRadius,
                    splashColor: accent.withValues(alpha: 0.15),
                    highlightColor: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(minHeight: minHeight),
                      margin: EdgeInsets.all(isDesktop ? 6 : 4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: borderRadius,
                        boxShadow: [
                          // Neumorphism top-left light shadow
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: _isHovered ? 25 : 20,
                            spreadRadius: _isHovered ? 2 : 0,
                            offset: Offset(
                              _isPressed ? -6 : -8,
                              _isPressed ? -6 : -8,
                            ),
                          ),
                          // Neumorphism bottom-right dark shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: _isHovered ? 25 : 20,
                            spreadRadius: _isHovered ? 1 : 0,
                            offset: Offset(
                              _isPressed ? 6 : 8,
                              _isPressed ? 6 : 8,
                            ),
                          ),
                          // Accent glow shadow
                          BoxShadow(
                            color: accent.withValues(
                              alpha: _glowIntensity.value,
                            ),
                            blurRadius: _isPressed
                                ? 35
                                : (_isHovered ? 32 : 28),
                            spreadRadius: _isPressed ? 2 : (_isHovered ? 1 : 0),
                            offset: Offset(
                              0,
                              _isPressed ? 15 : (_isHovered ? 12 : 10),
                            ),
                          ),
                          // Additional depth shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 40,
                            spreadRadius: -5,
                            offset: const Offset(0, 20),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: _isPressed ? 0.5 : (_isHovered ? 0.4 : 0.3),
                          ),
                          width: _isPressed ? 2.5 : (_isHovered ? 2 : 1.5),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Stack(
                          children: [
                            // Enhanced frosted glass blur backdrop
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(
                                  sigmaX: _isHovered ? 18 : 15,
                                  sigmaY: _isHovered ? 18 : 15,
                                ),
                                child: const SizedBox.shrink(),
                              ),
                            ),
                            // Primary gradient background
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient:
                                      accentGrad ??
                                      LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          accent.withValues(alpha: 0.85),
                                          accent.withValues(alpha: 0.65),
                                          accent.withValues(alpha: 0.75),
                                        ],
                                        stops: const [0.0, 0.6, 1.0],
                                      ),
                                ),
                              ),
                            ),
                            // Glass morphism overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.15),
                                      Colors.white.withValues(alpha: 0.05),
                                      Colors.black.withValues(alpha: 0.02),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Shimmer effect overlay
                            if (_isHovered)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: const Alignment(-1.0, -1.0),
                                      end: const Alignment(1.0, 1.0),
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withValues(alpha: 0.1),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            // Content
                            Padding(
                              padding: contentPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Top centered icon badge with enhanced styling
                                  Container(
                                    width: (iconSize * 2) + 5,
                                    height: (iconSize * 2) + 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        ((iconSize * 2) + 20) / 2,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: widget.imagePath != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              isDesktop ? 24 : 20,
                                            ),
                                            child: Image.asset(
                                              widget.imagePath!,
                                              width: iconSize * 2,
                                              height: iconSize * 2,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    // Fallback to icon if image fails to load
                                                    return Icon(
                                                      widget.icon,
                                                      size: iconSize,
                                                      color: Colors.white,
                                                    );
                                                  },
                                            ),
                                          )
                                        : Icon(
                                            widget.icon,
                                            size: iconSize,
                                            color: Colors.white,
                                          ),
                                  ),

                                  SizedBox(height: isDesktop ? 16 : 14),

                                  // Title with responsive typography
                                  Text(
                                    widget.title,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.h1.copyWith(
                                      fontSize: isDesktop
                                          ? 22
                                          : (isTablet ? 20 : 18),
                                      height: 1.15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.4,
                                          ),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  SizedBox(height: isDesktop ? 14 : 12),

                                  // Description with enhanced typography
                                  Flexible(
                                    child: Text(
                                      widget.description,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: isDesktop
                                            ? 16
                                            : (isTablet ? 15 : 14),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.95,
                                        ),
                                        height: 1.35,
                                        letterSpacing: 0.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            offset: const Offset(0, 1.5),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      maxLines: isDesktop ? 4 : 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  SizedBox(height: isDesktop ? 16 : 12),

                                  // Action indicator with enhanced styling
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: isDesktop ? 32 : 28,
                                      height: isDesktop ? 32 : 28,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          LucideIcons.arrow_right,
                                          color: Colors.white,
                                          size: isDesktop ? 18 : 16,
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
            ),
          ),
        );
      },
    );
  }
}
