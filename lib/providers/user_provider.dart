import 'package:instagram_flutter/resources/auth_method.dart';

import '../models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User get getUser => _user!;
  final AuthMethods _authMethods = AuthMethods();

  // refresh the user when there is any changes

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    // notify the listeners
    notifyListeners();
  }
}
