import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String profilePhoto;
  final String age;
  final String fullName;
  final String country;
  final List matches;
  final List sports;
  final List sports_configured;
  final List sports_not_configured;
  final List notifications;
  final String? token;

  const UserModel({
    required this.age,
    required this.uid,
    required this.profilePhoto,
    required this.email,
    required this.fullName,
    required this.country,
    required this.matches,
    required this.sports,
    required this.sports_configured,
    required this.sports_not_configured,
    required this.notifications,
    required this.token,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot["uid"],
      age: snapshot["age"],
      fullName: snapshot["fullName"],
      email: snapshot["email"],
      profilePhoto: snapshot["profilePhoto"],
      country: snapshot["country"],
      matches: snapshot["matches"],
      sports: snapshot["sports"],
      sports_configured: snapshot["sports_configured"],
      sports_not_configured: snapshot["sports_not_configured"],
      notifications: snapshot["notifications"],
      token: snapshot["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "age": age,
        "uid": uid,
        "email": email,
        "profilePhoto": profilePhoto,
        "fullName": fullName,
        "country": country,
        "matches": matches,
        "sports": sports,
        "sports_configured": sports_configured,
        "sports_not_configured": sports_not_configured,
        "notifications": notifications,
        "token": token,
      };
}
