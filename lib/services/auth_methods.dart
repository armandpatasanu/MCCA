import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snap);
  }

  Future<String> registerValidation({
    required String email,
    required String password,
    required String? age,
    required Uint8List? file,
    required String fullName,
    required String? country,
    required List matches,
    required List sports,
    required String? token,
  }) async {
    String result = 'success';
    try {
      if (email.isEmpty) {
        result = 'Email field cannot be empty!';
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else if (fullName.isEmpty) {
        result = 'Full name field cannot be empty!';
      } else if (age == '') {
        result = 'Please select your datebirth!';
      } else if (password.isEmpty) {
        result = 'Password field cannot be empty!';
      } else if (password.length < 6) {
        result = 'Password length too short!';
      } else if (country == null) {
        result = 'Please select your country!';
      } else if (file == null) {
        result = 'Please select a picture!';
      } else {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl =
            await StorageMethods().uploadImageToStorage('profilePics', file);

        List<String> notConfiguredSports =
            await SportServices().getListOfSportsName();

        UserModel user = UserModel(
          age: age!,
          fullName: fullName,
          uid: credential.user!.uid,
          profilePhoto: photoUrl,
          email: email,
          country: country,
          matches: matches,
          sports: sports,
          sports_configured: [],
          sports_not_configured: notConfiguredSports,
          notifications: [],
          token: token,
        );

        _firestore.collection('users').doc(credential.user!.uid).set(
              user.toJson(),
            );
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = 'success';
    try {
      if (email.isEmpty) {
        result = 'Email field cannot be empty!';
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else if (password.isEmpty) {
        result = 'Password field cannot be empty!';
      } else if (password.length < 6) {
        result = 'Password length too short!';
      } else {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } catch (error) {
      result = "Invalid username or password!";
    }
    return result;
  }

  Future<String> resetPassword({
    required String email,
  }) async {
    String result = 'success';
    try {
      if (email.isEmpty) {
        result = 'Email field cannot be empty!';
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else {
        await _auth.sendPasswordResetEmail(email: email);
      }
    } on FirebaseAuthException catch (error) {
      result = error.message.toString();
    }

    return result;
  }

  Future logOutUser() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
