import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'models/session_model.dart';
import 'models/user_model.dart';
import 'models/message_model.dart';
import 'theme/app_theme.dart';
import 'widgets/light_cone_gradient.dart';

void main() {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter error: ${details.exception}');
  };
  
  // Catch other errors
  runZonedGuarded(() {
    runApp(const DeskMateApp());
  }, (Object error, StackTrace stack) {
    print('Caught error: $error');
    print(stack);
  });
}

class DeskMateApp extends StatelessWidget {
  const DeskMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => SessionModel()),
        ChangeNotifierProvider(create: (_) => ChatModel()),
      ],
      child: Consumer<UserModel>(
        builder: (context, userModel, _) {
          // Initialize user model if not already initialized
          if (!userModel.isInitialized) {
            userModel.initialize();
            return MaterialApp(
              title: 'DeskMate',
              theme: appTheme(),
              home: const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryYellow),
                  ),
                ),
              ),
            );
          }
          
          return MaterialApp(
            title: 'DeskMate',
            theme: appTheme(),
            home: userModel.isAuthenticated ? const HomeScreen() : const LoginScreen(),
            // Custom page transitions with light effects
            onGenerateRoute: (settings) {
              Widget page;
              if (settings.name == '/onboarding') {
                page = const OnboardingScreen();
              } else if (settings.name == '/login') {
                page = const LoginScreen();
              } else {
                page = const HomeScreen();
              }
                
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
                              opacity: animation.value * 0.5, // Reduced from 0.7
                              child: LightConeGradient(
                                lightColor: primaryYellow,
                                intensity: 0.15 * animation.value, // Reduced from 0.3
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
          );
        },
      ),
    );
  }
}
