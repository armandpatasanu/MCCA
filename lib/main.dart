import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/services/local_push_notif.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/notif_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBkgHandler(RemoteMessage msg) async {}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  UserModel sender =
      await UserServices().getSpecificUser(message.data['sender']);
  NotifSerivces().storeNotif(
      (message.notification.hashCode).toString(),
      message.notification!.title,
      message.notification!.body,
      FirebaseAuth.instance.currentUser!.uid,
      message.data['id'],
      sender,
      MatchServices().getEmptyMatch());
  if (message.data['id'] == 1) {
    NotifSerivces().sendSchedule(
        5,
        message.notification!.body!,
        int.parse(message.data['matchNotifId']),
        message.data['matchId'].toString());
  } else if (message.data['id'] == 2) {
    AwesomeNotifications()
        .cancelSchedule(int.parse(message.data['matchNotifId']));
  }
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void listenScheduled() {
  AwesomeNotifications()
      .createdStream
      .asBroadcastStream()
      .listen((notification) {
    Future.delayed(Duration(seconds: 5)).then((value) {
      int id = createUniqueId();
      NotifSerivces().storeNotif(
          id.toString(),
          notification.title,
          notification.body,
          FirebaseAuth.instance.currentUser!.uid,
          3,
          StorageMethods().getEmptyUser(),
          MatchServices().getEmptyMatch());
    });
  });
}

void listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      UserModel sender =
          await UserServices().getSpecificUser(message.data['sender']);

      await NotifSerivces().storeNotif(
          (notification.hashCode).toString(),
          notification.title,
          notification.body,
          FirebaseAuth.instance.currentUser!.uid,
          1,
          sender,
          MatchServices().getEmptyMatch());
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'launch_background',
          ),
        ),
      );

      if (int.parse(message.data['id']) == 1) {
        NotifSerivces().sendSchedule(
            5,
            message.notification!.body!,
            int.parse(message.data['matchNotifId']),
            message.data['matchId'].toString());
      } else if (int.parse(message.data['id']) == 2) {
        AwesomeNotifications()
            .cancelSchedule(int.parse(message.data['matchNotifId']));
      }
    }
  });
}

void loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();

  requestPermission();

  loadFCM();

  listenFCM();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Matches reminders',
      defaultColor: Colors.purple,
      importance: NotificationImportance.High,
      playSound: true,
      enableVibration: true,
      locked: true,
    )
  ]);

  listenScheduled();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 5))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitxKonnect',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges().asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return HomePage(
                  password: '',
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: SpinKitCircle(
                      size: 50,
                      itemBuilder: (context, index) {
                        final colors = [Colors.black, Colors.purple];
                        final color = colors[index % colors.length];
                        return DecoratedBox(
                          decoration: BoxDecoration(color: color),
                        );
                      },
                    ),
                  ),
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
