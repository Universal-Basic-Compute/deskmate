import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;

  const WelcomeHeader({
    super.key,
    required this.name,
  });

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
        Text(
          'Welcome, ${name.isNotEmpty ? name : "Student"}!',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Ready to boost your productivity?',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
