import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AssistantFab extends StatelessWidget {
  const AssistantFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryYellow.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          // Open AI assistant
        },
        tooltip: 'Ask DeskMate',
        backgroundColor: darkGrey,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return yellowOrangeGradient.createShader(bounds);
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
