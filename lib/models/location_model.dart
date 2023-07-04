import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String locationId;
  final String schedule;
  final String name;
  final GeoPoint geopoint;
  final List contact;
  final List sports;
  final String distance;

  const LocationModel({
    required this.locationId,
    required this.contact,
    required this.schedule,
    required this.sports,
    required this.name,
    required this.geopoint,
    required this.distance,
  });

  static LocationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return LocationModel(
      schedule: snapshot["schedule"] ?? '',
      contact: snapshot["contact"],
      sports: snapshot["sports"],
      locationId: snapshot["locationId"],
      name: snapshot["name"],
      geopoint: snapshot["geopoint"],
      distance: snapshot["distance"],
    );
  }

  Map<String, dynamic> toJson() => {
        "locationId": locationId,
        "schedule": schedule,
        "sports": sports,
        "contact": contact,
        "name": name,
        "geopoint": geopoint,
        "distance": distance,
      };
}
