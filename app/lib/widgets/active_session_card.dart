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
            color: violetAccent.withOpacity(0.15), // Reduced from 0.3
            blurRadius: 15, // Reduced from 20
            spreadRadius: 1, // Reduced from 2
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
          intensity: 0.05, // Reduced from 0.1
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                // Main content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Chat interface with padding to make room for the back button
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: SizedBox(
                        height: 400,
                        child: ChatInterface(),
                      ),
                    ),
                  ],
                ),
              
                // Back button
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkGrey.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: violetAccent.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => sessionModel.endSession(),
                      tooltip: 'Back to menu',
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
