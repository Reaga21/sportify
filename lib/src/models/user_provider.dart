import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}