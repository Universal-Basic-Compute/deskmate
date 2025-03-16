import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _learningStyle;
  bool _onboardingComplete = false;

  String? get name => _name;
  String? get email => _email;
  String? get learningStyle => _learningStyle;
  bool get onboardingComplete => _onboardingComplete;

  void setUserDetails({String? name, String? email, String? learningStyle}) {
    _name = name;
    _email = email;
    _learningStyle = learningStyle;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }
}
