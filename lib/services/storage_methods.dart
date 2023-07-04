import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> getDownloadUrl(String userId) {
    return _storage.ref().child('profilePics').child(userId).getDownloadURL();
  }

  LocationModel getEmptyLocation() {
    return LocationModel(
      schedule: "",
      contact: [],
      sports: [],
      locationId: "",
      name: "",
      geopoint: GeoPoint(0, 0),
      distance: "",
    );
  }

  UserModel getEmptyUser() {
    return UserModel(
      age: "",
      uid: "",
      profilePhoto: "",
      email: "",
      fullName: "",
      country: "",
      matches: [],
      sports: [],
      sports_configured: [],
      sports_not_configured: [],
      notifications: [],
      token: '',
    );
  }
}
