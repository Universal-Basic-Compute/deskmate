import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo with light effect
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect behind logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryYellow.withOpacity(0.15), // Reduced from 0.3
                    blurRadius: 20, // Reduced from 30
                    spreadRadius: 3, // Reduced from 5
                  ),
                ],
              ),
            ),
            // Logo with gradient
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return yellowOrangeGradient.createShader(bounds);
              },
              child: SvgPicture.asset(
                'assets/icons/app_icon.svg',
                height: 80,
                width: 80,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Title with light effect
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryYellow.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Welcome to DeskMate',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI-powered study companion',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
