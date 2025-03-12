import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../widgets/light_cone_gradient.dart';
import '../theme/app_theme.dart';

class ActiveSessionCard extends StatelessWidget {
  final SessionModel sessionModel;

  const ActiveSessionCard({
    super.key,
    required this.sessionModel,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate elapsed time
    final elapsedDuration = sessionModel.sessionStartTime != null
        ? DateTime.now().difference(sessionModel.sessionStartTime!)
        : Duration.zero;
    
    final minutes = elapsedDuration.inMinutes;
    final seconds = elapsedDuration.inSeconds % 60;
    
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: violetAccent.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        color: darkGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: violetAccent, width: 2),
        ),
        child: LightConeGradient(
          lightColor: violetAccent,
          intensity: 0.1,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: violetAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Session in Progress',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Timer with glow effect
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: violetAccent.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return violetGradient.createShader(bounds);
                    },
                    child: Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // End session button with glow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => sessionModel.endSession(),
                    icon: const Icon(Icons.stop),
                    label: const Text('End Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 46),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
