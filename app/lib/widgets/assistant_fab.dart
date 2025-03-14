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
          // Show a dialog with the chat interface
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: darkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                child: const ChatInterface(),
              ),
            ),
          );
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
