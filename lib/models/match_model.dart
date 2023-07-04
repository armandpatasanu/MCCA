import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String matchId;
  final String location;
  final String player1;
  final String player2;
  final String matchDate;
  final String startingTime;
  final DateTime datePublished;
  final String sport;
  final String difficulty;
  final String status;
  final int notificationId;

  const MatchModel({
    required this.matchId,
    required this.location,
    required this.player1,
    required this.player2,
    required this.matchDate,
    required this.startingTime,
    required this.datePublished,
    required this.sport,
    required this.difficulty,
    required this.status,
    required this.notificationId,
  });

  static MatchModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MatchModel(
      matchId: snapshot["matchId"],
      location: snapshot["location"],
      player1: snapshot["player1"],
      player2: snapshot["player2"],
      matchDate: snapshot["matchDate"],
      startingTime: snapshot["startingTime"],
      datePublished: snapshot["username"],
      sport: snapshot['sport'],
      difficulty: snapshot['difficulty'],
      status: snapshot['status'],
      notificationId: snapshot['notificationId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "matchId": matchId,
        "location": location,
        "player1": player1,
        "player2": player2,
        "matchDate": matchDate,
        "startingTime": startingTime,
        "datePublished": datePublished,
        'sport': sport,
        'difficulty': difficulty,
        'status': status,
        'notificationId': notificationId,
      };
}
