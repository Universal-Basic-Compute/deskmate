import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';
import '../widgets/welcome_header.dart';
import '../widgets/session_button.dart';
import '../widgets/active_session_card.dart';
import '../widgets/assistant_fab.dart';
import '../widgets/background_container.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final sessionModel = Provider.of<SessionModel>(context);

    // Check if onboarding is complete
    if (!userModel.onboardingComplete) {
      return const OnboardingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DeskMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WelcomeHeader(name: userModel.name ?? ''),
                const SizedBox(height: 48),
                if (!sessionModel.isSessionActive)
                  SessionButton(sessionModel: sessionModel)
                else
                  ActiveSessionCard(sessionModel: sessionModel),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const AssistantFab(),
    );
  }

}
