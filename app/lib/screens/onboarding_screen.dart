import 'package:flutter/material.dart';
import '../widgets/background_container.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_form.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: BackgroundContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  OnboardingHeader(),
                  SizedBox(height: 40),
                  OnboardingForm(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
