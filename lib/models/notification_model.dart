import 'package:cloud_firestore/cloud_firestore.dart';

class Notif {
  // final String sender;
  final String notifId;
  final DateTime datePublished;
  final String notifTitle;
  final String notifText;
  final String receiver;
  final int type;

  const Notif({
    // required this.sender,
    required this.datePublished,
    required this.notifId,
    required this.notifTitle,
    required this.notifText,
    required this.receiver,
    required this.type,
  });

  static Notif fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notif(
      // sender: snapshot["sender"],
      datePublished: snapshot["datePublished"],
      notifId: snapshot["notifId"],
      notifText: snapshot["notifText"],
      notifTitle: snapshot["notifTitle"],
      receiver: snapshot["receiver"],
      type: snapshot["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        // "sender": sender,
        "datePublished": datePublished,
        "notifId": notifId,
        "notifText": notifText,
        "notifTitle": notifTitle,
        "receiver": receiver,
        "type": type,
      };
}
