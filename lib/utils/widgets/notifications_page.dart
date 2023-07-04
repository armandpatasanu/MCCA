import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/fcm_notif_services.dart';
import 'package:fitxkonnect/services/notif_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotificationsPage extends StatefulWidget {
  final String password;
  const NotificationsPage({Key? key, required this.password}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            // .orderBy('datePublished', descending: true)

            .where('receiver',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
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
          return Scaffold(
            body: snapshot.data.docs.length == 0
                ? Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                                'assets/images/notif_screen/no_notifications.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.9,
                          right: 20,
                          child: Material(
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.black,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.home),
                                  color: Colors.white,
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  password: widget.password,
                                                ))),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      child: snapshot.data.docs[index]
                                                  .get('type') ==
                                              1
                                          ? Icon(
                                              Icons.notification_add,
                                              color: Colors.black,
                                              size: 38,
                                            )
                                          : Image.asset(
                                              'assets/images/notif_screen/1hour_left.png'),
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        border: Border.all(
                                            color: snapshot.data.docs[index]
                                                        .get('type') ==
                                                    1
                                                ? Colors.black
                                                : Colors.red),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              118,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    .get('notifTitle'),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 16),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                thickness: 1,
                                              ),
                                              Text(
                                                  snapshot.data.docs[index]
                                                      .get('notifText'),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          // color: Colors.red,
                                        ),
                                        Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: Container(
                                                width: 35,
                                                height: 35,
                                                // color: Colors.amber,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await NotifSerivces()
                                                        .deleteNotification(
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'notifId'));
                                                  },
                                                  child: Icon(
                                                    Icons.auto_delete,
                                                    color: Color.fromARGB(
                                                        255, 144, 21, 12),
                                                    size: 28,
                                                  ),
                                                ))),
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: snapshot.data.docs[index]
                                                    .get('type') ==
                                                1
                                            ? Colors.black
                                            : Colors.orange),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.85,
                          right: 20,
                          child: Material(
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.black,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.home),
                                  color: Colors.white,
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  password: widget.password,
                                                ))),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
