import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:http/http.dart' as http;

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getSpecificUser(String userId) async {
    var result = await _firestore.collection('users').doc(userId).get();
    UserModel searchedUser = UserModel.fromSnap(result);
    return searchedUser;
  }

  Future<List<String>> getListOfUsersUIDS() async {
    var ref = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> usersList = ref.docs;
    List<UserModel> users = [];
    List<String> my_list = [];

    usersList.forEach((DocumentSnapshot snap) {
      users.add(UserModel.fromSnap(snap));
    });

    users.forEach((element) {
      my_list.add(element.uid);
    });

    return my_list;
  }

  Future<String> updateUser(
      String userId,
      User user,
      String fullName,
      String email,
      String actualEmail,
      String pass,
      String actualPass,
      String country,
      Uint8List file,
      bool modifyPicture) async {
    int counter = 0;
    String result = "success";

    try {
      if (pass.isEmpty) {
        result = "Please enter your password!";
      } else if (email != actualEmail && pass.isEmpty) {
        result = "Please enter your password in order to change the email";
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else {
        if (actualPass == pass && modifyPicture == true) {
          await user.updateEmail(email);
          UserCredential result = await user
              .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: email,
            password: pass,
          ));
          String url =
              await StorageMethods().uploadImageToStorage('profilePics', file);
          await _firestore.collection('users').doc(userId).update({
            'fullName': fullName,
            'email': email,
            'country': country,
            'profilePhoto': url,
          });
        } else if (actualPass == pass && modifyPicture == false) {
          await user.updateEmail(email);
          UserCredential result = await user
              .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: email,
            password: pass,
          ));
          await _firestore.collection('users').doc(userId).update({
            'fullName': fullName,
            'email': email,
            'country': country,
          });
        } else {
          result = "Wrong password!";
        }
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Stream<UserModel> userStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromSnap(snapshot));
  }

  void sendPushMessage(String body, String title, String token, String sender,
      int type, int matchNotifId, String matchId) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA20fBAmM:APA91bFcnrBWmLkTCw4WHBExrTx1ZkBvFSVDdhG7ZCxXWg_oiTnlH2WOX9AxXM910p5PjIS57qSiMZiAqzNvsd8yWRt2xJd6Tl4L6MBHFhAh41nrKOBddyD3gMDwhTj6AWk7nzHYwpoY',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'sender': sender,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'sender': sender,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': type,
              'status': 'done',
              'matchId': matchId,
              'matchNotifId': matchNotifId,
            },
            "to": token,
          },
        ),
      );
    } catch (e) {}
  }
}
