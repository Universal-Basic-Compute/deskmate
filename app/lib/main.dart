import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'models/session_model.dart';
import 'models/user_model.dart';
import 'models/message_model.dart'; // Add this import
import 'theme/app_theme.dart';
import 'widgets/light_cone_gradient.dart';

void main() {
  runApp(const DeskMateApp());
}

class DeskMateApp extends StatelessWidget {
  const DeskMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => SessionModel()),
        ChangeNotifierProvider(create: (_) => ChatModel()), // Add this provider
      ],
      child: MaterialApp(
        title: 'DeskMate',
        theme: appTheme(),
        home: const HomeScreen(),
        // Custom page transitions with light effects
        onGenerateRoute: (settings) {
          final Widget page = settings.name == '/onboarding' 
              ? const OnboardingScreen() 
              : const HomeScreen();
              
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Fade transition with light cone effect
              return FadeTransition(
                opacity: animation,
                child: Stack(
                  children: [
                    // Growing light cone effect during transition
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        return Opacity(
                          opacity: animation.value * 0.7,
                          child: LightConeGradient(
                            lightColor: primaryYellow,
                            intensity: 0.3 * animation.value,
                            alignment: Alignment.center,
                            child: const SizedBox.expand(),
                          ),
                        );
                      },
                    ),
                    child,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
