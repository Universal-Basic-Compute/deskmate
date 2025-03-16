import 'package:flutter/material.dart';
import '../widgets/light_cone_gradient.dart';
import '../theme/app_theme.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundGrey,
                Color(0xFF262626), // Slightly lighter dark grey
              ],
            ),
          ),
        ),
        // Light cone overlay
        const LightConeGradient(
          lightColor: primaryYellow,
          intensity: 0.08, // Reduced from 0.15
          alignment: Alignment.topCenter,
          child: SizedBox.expand(),
        ),
        // Main content
        child,
      ],
    );
  }
}
