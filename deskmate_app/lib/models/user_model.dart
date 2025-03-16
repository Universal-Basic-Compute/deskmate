import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _lastName;
  String? _email;
  String? _learningStyle;
  bool _onboardingComplete = false;
  bool _isRegistering = false;
  String? _registrationError;

  String? get name => _name;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get learningStyle => _learningStyle;
  bool get onboardingComplete => _onboardingComplete;
  bool get isRegistering => _isRegistering;
  String? get registrationError => _registrationError;

  void setUserDetails({
    String? name,
    String? lastName,
    String? email,
    String? learningStyle,
  }) {
    _name = name;
    _lastName = lastName;
    _email = email;
    _learningStyle = learningStyle;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }
  
  void setRegistering(bool value) {
    _isRegistering = value;
    notifyListeners();
  }

  void setRegistrationError(String? error) {
    _registrationError = error;
    notifyListeners();
  }
}
