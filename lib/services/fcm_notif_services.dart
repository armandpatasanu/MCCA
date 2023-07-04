// import 'dart:async';
// import 'dart:convert' show json;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;

// abstract class IFCMNotificationService {
//   Future<void> sendNotificationToUser({
//     required String fcmToken,
//     required String title,
//     required String body,
//   });
//   Future<void> sendNotificationToGroup({
//     required String group,
//     required String title,
//     required String body,
//   });
//   Future<void> unsubscribeFromTopic({
//     required String topic,
//   });
//   Future<void> subscribeToTopic({
//     required String topic,
//   });
// }

// class FCMNotificationService extends IFCMNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
//   final String _contentType = 'application/json';
//   final String _authorization =
//       'key=AAAA20fBAmM:APA91bFcnrBWmLkTCw4WHBExrTx1ZkBvFSVDdhG7ZCxXWg_oiTnlH2WOX9AxXM910p5PjIS57qSiMZiAqzNvsd8yWRt2xJd6Tl4L6MBHFhAh41nrKOBddyD3gMDwhTj6AWk7nzHYwpoY';

//   Future<http.Response> _sendNotification(
//     String to,
//     String title,
//     String body,
//   ) async {
//     try {
//       final dynamic data = json.encode(
//         {
//           'to': to,
//           'priority': 'high',
//           'notification': {
//             'title': title,
//             'body': body,
//           },
//           'content_available': true
//         },
//       );
//       http.Response response = await http.post(
//         Uri.parse(_endpoint),
//         body: data,
//         headers: {
//           'Content-Type': _contentType,
//           'Authorization': _authorization
//         },
//       );

//       return response;
//     } catch (error) {
//       throw Exception(error);
//     }
//   }

//   @override
//   Future<void> unsubscribeFromTopic({required String topic}) {
//     return _firebaseMessaging.unsubscribeFromTopic(topic);
//   }

//   @override
//   Future<void> subscribeToTopic({required String topic}) {
//     return _firebaseMessaging.subscribeToTopic(topic);
//   }

//   @override
//   Future<void> sendNotificationToUser({
//     required String fcmToken,
//     required String title,
//     required String body,
//   }) {
//     return _sendNotification(
//       fcmToken,
//       title,
//       body,
//     );
//   }

//   @override
//   Future<void> sendNotificationToGroup(
//       {required String group, required String title, required String body}) {
//     return _sendNotification('/topics/' + group, title, body);
//   }
// }

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // handle when app in active state
    forgroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();

    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  forgroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
  }

  terminateNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data.containsKey('data')) {
        // Handle data message
        streamCtlr.sink.add(initialMessage.data['data']);
      }
      if (initialMessage.data.containsKey('notification')) {
        // Handle notification message
        streamCtlr.sink.add(initialMessage.data['notification']);
      }
      // Or do other work.
      titleCtlr.sink.add(initialMessage.notification!.title!);
      bodyCtlr.sink.add(initialMessage.notification!.body!);
    }
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
