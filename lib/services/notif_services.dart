import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/notification_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/match_model.dart';

class NotifSerivces {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeNotif(String? notifId, String? title, String? text,
      String? currentUser, int type, UserModel sender, MatchModel match) async {
    Notif notif = Notif(
        datePublished: DateTime.now(),
        notifId: notifId!,
        notifTitle: title!,
        notifText: text!,
        receiver: currentUser!,
        type: type);
    await _firestore.collection('notifications').doc(notifId).set(
          notif.toJson(),
        );
  }

  Future<void> sendSchedule(
      int interval, String? body, int matchNotifId, String matchId) async {
    MatchModel m = await MatchServices().getCertainMatch(matchId);
    int id = createUniqueId();
    DateTime date = DateTime(
      int.parse(m.matchDate.substring(0, 4)),
      int.parse(m.matchDate.substring(6, 7)),
      int.parse(m.matchDate.substring(8, 10)),
      int.parse(m.startingTime.substring(0, 2)),
      int.parse(m.startingTime.substring(3, 5)),
    );
    DateTime scheduledDate = date.subtract(Duration(hours: 1));
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String cronExpression =
        "${scheduledDate.minute} ${scheduledDate.minute} ${scheduledDate.day} ${scheduledDate.month} *";
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: matchNotifId,
          channelKey: 'scheduled_channel',
          title: 'New match ahead! - 1 hour left!',
          body: body,
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDate));
  }

  Future<void> deleteNotification(String notifId) async {
    await _firestore.collection('notifications').doc(notifId).delete();
  }
}
