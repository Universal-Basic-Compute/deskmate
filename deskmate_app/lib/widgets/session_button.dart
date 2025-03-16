import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../theme/app_theme.dart';

class SessionButton extends StatelessWidget {
  final SessionModel sessionModel;

  const SessionButton({
    super.key,
    required this.sessionModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primaryYellow.withOpacity(0.15), // Reduced from 0.3
            blurRadius: 10, // Reduced from 15
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: yellowOrangeGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton.icon(
          onPressed: () => sessionModel.startSession(),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Study Session'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: darkGrey,
            shadowColor: Colors.transparent,
            minimumSize: const Size(240, 50),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
