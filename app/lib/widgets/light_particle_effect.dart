import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LightParticleEffect extends StatefulWidget {
  final Widget child;
  final Color particleColor;
  final bool active;
  final int particleCount;
  final Duration duration;

  const LightParticleEffect({
    super.key,
    required this.child,
    this.particleColor = primaryYellow,
    this.active = false,
    this.particleCount = 20,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<LightParticleEffect> createState() => _LightParticleEffectState();
}

class _LightParticleEffectState extends State<LightParticleEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _generateParticles();
    
    if (widget.active) {
      _controller.forward(from: 0.0);
    }
  }
  
  @override
  void didUpdateWidget(LightParticleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _generateParticles();
        _controller.forward(from: 0.0);
      }
    }
    
    if (widget.particleCount != oldWidget.particleCount) {
      _generateParticles();
    }
  }
  
  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (_) => Particle(
      color: widget.particleColor,
      random: _random,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.active)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              );
            },
          ),
      ],
    );
  }
}

class Particle {
  final double initialX;
  final double initialY;
  final double finalX;
  final double finalY;
  final double size;
  final Color color;
  final double opacity;
  final double speed;
  
  Particle({
    required Random random,
    required Color color,
  }) : 
    initialX = 0.5 + (random.nextDouble() - 0.5) * 0.2,
    initialY = 0.5 + (random.nextDouble() - 0.5) * 0.2,
    finalX = random.nextDouble(),
    finalY = random.nextDouble() * 0.5,
    size = 2.0 + random.nextDouble() * 6.0,
    opacity = 0.5 + random.nextDouble() * 0.5,
    speed = 0.7 + random.nextDouble() * 0.3,
    color = color;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  
  ParticlePainter({
    required this.particles,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate current position based on progress
      final particleProgress = (progress * particle.speed).clamp(0.0, 1.0);
      
      final currentX = lerpDouble(
        particle.initialX * size.width, 
        particle.finalX * size.width, 
        particleProgress
      );
      
      final currentY = lerpDouble(
        particle.initialY * size.height, 
        particle.finalY * size.height, 
        particleProgress
      );
      
      // Calculate current opacity (fade out towards the end)
      const fadeOutStart = 0.7;
      final currentOpacity = particle.opacity * 
          (particleProgress > fadeOutStart 
              ? 1.0 - ((particleProgress - fadeOutStart) / (1.0 - fadeOutStart))
              : 1.0);
      
      // Calculate current size (grow slightly then shrink)
      const growPeak = 0.3;
      final sizeFactor = particleProgress < growPeak
          ? 1.0 + particleProgress * 0.5
          : 1.5 - (particleProgress - growPeak) * 1.5;
      
      final currentSize = particle.size * sizeFactor;
      
      // Draw the particle
      final paint = Paint()
        ..color = particle.color.withOpacity(currentOpacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(currentX, currentY),
        currentSize,
        paint,
      );
      
      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(currentOpacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      
      canvas.drawCircle(
        Offset(currentX, currentY),
        currentSize * 1.8,
        glowPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
  
  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
