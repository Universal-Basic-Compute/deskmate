import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../widgets/light_cone_gradient.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_interface.dart';

class ActiveSessionCard extends StatelessWidget {
  final SessionModel sessionModel;

  const ActiveSessionCard({
    super.key,
    required this.sessionModel,
  });

  @override
  Widget build(BuildContext context) {
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
                // Chat interface
                const SizedBox(
                  height: 400, // Increased height since we removed other elements
                  child: ChatInterface(),
                ),
                
                const SizedBox(height: 16),
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
