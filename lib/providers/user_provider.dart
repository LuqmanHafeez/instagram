import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get getUser {
    return _user;
  }

  Future<void> refreshUser() async {
    User user = await AuthMethod().getUserDetails();

    _user = user;
    notifyListeners();
  }
}
