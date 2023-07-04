import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = const UserModel(
    age: '',
    uid: '',
    profilePhoto: '',
    email: '',
    fullName: '',
    country: '',
    matches: [],
    sports: [],
    sports_configured: [],
    sports_not_configured: [],
    notifications: [],
    token: '',
  );
  final AuthMethods _authMethods = AuthMethods();

  UserModel getUser() {
    return _user;
  }

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
