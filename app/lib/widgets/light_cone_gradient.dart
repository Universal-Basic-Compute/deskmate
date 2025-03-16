import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

enum LightConeEffect {
  static,
  breathing,
  pulsing,
  shifting
}

class LightConeGradient extends StatefulWidget {
  final Widget child;
  final Color lightColor;
  final double intensity;
  final AlignmentGeometry alignment;
  final LightConeEffect effect;
  final Duration animationDuration;
  
  const LightConeGradient({
    super.key,
    required this.child,
    this.lightColor = primaryYellow,
    this.intensity = 0.08, // Reduced from 0.15
    this.alignment = Alignment.topCenter,
    this.effect = LightConeEffect.static,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<LightConeGradient> createState() => _LightConeGradientState();
}

class _LightConeGradientState extends State<LightConeGradient> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _intensityAnimation;
  late Animation<Alignment> _positionAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    // Create animations based on effect type
    _setupAnimations();
    
    // Start animation if not static
    if (widget.effect != LightConeEffect.static) {
      _controller.repeat(reverse: true);
    }
  }
  
  void _setupAnimations() {
    switch (widget.effect) {
      case LightConeEffect.breathing:
        _intensityAnimation = Tween<double>(
          begin: widget.intensity * 0.5, // Reduced from 0.7
          end: widget.intensity * 1.2, // Reduced from 1.3
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
        
      case LightConeEffect.pulsing:
        _intensityAnimation = TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: widget.intensity,
              end: widget.intensity * 1.3, // Reduced from 1.5
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: widget.intensity * 1.3, // Reduced from 1.5
              end: widget.intensity,
            ),
            weight: 1,
          ),
        ]).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
        
      case LightConeEffect.shifting:
        // Create a subtle position shift animation
        final Alignment baseAlignment = widget.alignment is Alignment 
            ? widget.alignment as Alignment 
            : Alignment.topCenter;
            
        _positionAnimation = Tween<Alignment>(
          begin: Alignment(
            baseAlignment.x - 0.1,
            baseAlignment.y is double ? (baseAlignment.y) - 0.1 : -0.6,
          ),
          end: Alignment(
            baseAlignment.x + 0.1,
            baseAlignment.y is double ? (baseAlignment.y) + 0.1 : -0.4,
          ),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
        
      case LightConeEffect.static:
      default:
        // No animation for static effect
        break;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For static effect, return the original implementation
    if (widget.effect == LightConeEffect.static) {
      return _buildStaticLightCone();
    }
    
    // For animated effects, return the appropriate animated builder
    switch (widget.effect) {
      case LightConeEffect.breathing:
      case LightConeEffect.pulsing:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _buildAnimatedLightCone(
              intensity: _intensityAnimation.value,
              child: child!,
            );
          },
          child: widget.child,
        );
        
      case LightConeEffect.shifting:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _buildAnimatedLightCone(
              alignment: _positionAnimation.value,
              child: child!,
            );
          },
          child: widget.child,
        );
        
      default:
        return _buildStaticLightCone();
    }
  }
  
  Widget _buildStaticLightCone() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: widget.alignment == Alignment.topCenter 
              ? const Alignment(0.0, -0.5) 
              : (widget.alignment == Alignment.bottomCenter 
                  ? const Alignment(0.0, 0.5) 
                  : widget.alignment as Alignment),
          radius: 1.2,
          colors: [
            widget.lightColor.withOpacity(widget.intensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7],
        ),
      ),
      child: widget.child,
    );
  }
  
  Widget _buildAnimatedLightCone({
    double? intensity,
    Alignment? alignment,
    required Widget child,
  }) {
    final effectiveIntensity = intensity ?? widget.intensity;
    final effectiveAlignment = alignment ?? 
        (widget.alignment == Alignment.topCenter 
            ? const Alignment(0.0, -0.5) 
            : (widget.alignment == Alignment.bottomCenter 
                ? const Alignment(0.0, 0.5) 
                : widget.alignment as Alignment));
    
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: effectiveAlignment,
          radius: 1.2,
          colors: [
            widget.lightColor.withOpacity(effectiveIntensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7],
        ),
      ),
      child: child,
    );
  }
}
