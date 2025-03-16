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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                final userModel = Provider.of<UserModel>(context, listen: false);
                userModel.logout();
              } else if (value == 'settings') {
                // Navigate to settings
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                WelcomeHeader(name: userModel.name ?? ''),
                const SizedBox(height: 48),
                if (!sessionModel.isSessionActive)
                  SessionButton(sessionModel: sessionModel)
                else
                  ActiveSessionCard(sessionModel: sessionModel),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const AssistantFab(),
    );
  }

}
