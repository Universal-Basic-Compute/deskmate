import 'package:flutter/foundation.dart';

class SessionModel extends ChangeNotifier {
  bool _isSessionActive = false;
  DateTime? _sessionStartTime;
  int _focusMinutes = 25;
  int _breakMinutes = 5;
  int _completedSessions = 0;

  bool get isSessionActive => _isSessionActive;
  DateTime? get sessionStartTime => _sessionStartTime;
  int get focusMinutes => _focusMinutes;
  int get breakMinutes => _breakMinutes;
  int get completedSessions => _completedSessions;

  void startSession() {
    _isSessionActive = true;
    _sessionStartTime = DateTime.now();
    notifyListeners();
  }

  void endSession() {
    _isSessionActive = false;
    _completedSessions++;
    notifyListeners();
  }

  void updateTimerSettings({int? focusMinutes, int? breakMinutes}) {
    if (focusMinutes != null) _focusMinutes = focusMinutes;
    if (breakMinutes != null) _breakMinutes = breakMinutes;
    notifyListeners();
  }
}
