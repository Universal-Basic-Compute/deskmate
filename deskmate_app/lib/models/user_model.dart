import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _lastName;
  String? _email;
  String? _learningStyle;
  bool _onboardingComplete = false;
  bool _isRegistering = false;
  String? _registrationError;
  String? _authToken;
  bool _isInitialized = false;

  String? get name => _name;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get learningStyle => _learningStyle;
  bool get onboardingComplete => _onboardingComplete;
  bool get isRegistering => _isRegistering;
  String? get registrationError => _registrationError;
  String? get authToken => _authToken;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _authToken != null;

  // Initialize user data from shared preferences
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Load auth token
    _authToken = prefs.getString('auth_token');
    
    // Load user data if authenticated
    if (_authToken != null) {
      _name = prefs.getString('user_first_name');
      _lastName = prefs.getString('user_last_name');
      _email = prefs.getString('user_email');
      _onboardingComplete = true;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  void setUserDetails({
    String? name,
    String? lastName,
    String? email,
    String? learningStyle,
  }) async {
    _name = name;
    _lastName = lastName;
    _email = email;
    _learningStyle = learningStyle;
    
    // Save to shared preferences
    if (_authToken != null) {
      final prefs = await SharedPreferences.getInstance();
      if (name != null) prefs.setString('user_first_name', name);
      if (lastName != null) prefs.setString('user_last_name', lastName);
      if (email != null) prefs.setString('user_email', email);
    }
    
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
  
  void setAuthToken(String token) async {
    _authToken = token;
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    
    notifyListeners();
  }
  
  Future<void> logout() async {
    // Clear auth token and user data
    _authToken = null;
    _name = null;
    _lastName = null;
    _email = null;
    _onboardingComplete = false;
    
    // Clear from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_first_name');
    await prefs.remove('user_last_name');
    await prefs.remove('user_email');
    
    notifyListeners();
  }
}
