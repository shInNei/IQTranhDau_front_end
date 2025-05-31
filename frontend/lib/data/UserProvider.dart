import 'package:flutter/foundation.dart';
import '../models/player.dart';

class UserProvider with ChangeNotifier {
  Player? _currentUser;

  Player? get currentUser => _currentUser;

  void setCurrentUser(Player user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => _currentUser != null;
}