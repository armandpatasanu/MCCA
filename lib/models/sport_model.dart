import 'package:cloud_firestore/cloud_firestore.dart';

class SportModel {
  final String sportId;
  final String name;
  final List playedAt;

  const SportModel({
    required this.sportId,
    required this.name,
    required this.playedAt,
  });

  static SportModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SportModel(
      sportId: snapshot["sportId"],
      name: snapshot["name"],
      playedAt: snapshot["playedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sportId": sportId,
        "name": name,
        "playedAt": playedAt,
      };
}
