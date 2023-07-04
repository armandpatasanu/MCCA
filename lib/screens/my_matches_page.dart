import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/main.dart';
import 'package:fitxkonnect/models/full_match_model.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/screens/add_match_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/rating_bar.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/full_match_widget.dart';
import 'package:fitxkonnect/utils/widgets/open_match_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyMatchesPage extends StatefulWidget {
  final String password;
  final UserModel user;
  const MyMatchesPage({
    Key? key,
    required this.user,
    required this.password,
  }) : super(key: key);

  @override
  _MyMatchesPageState createState() => _MyMatchesPageState();
}

class _MyMatchesPageState extends State<MyMatchesPage> {
  UserModel _userData = StorageMethods().getEmptyUser();
  String callbeck = "";

  callback(String value) {
    setState(() {
      callbeck = value;
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: UserServices()
          .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
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
        return Stack(children: [
          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                toolbarHeight: 10,
                //backgroundColor: Colors.purple,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.red],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                bottom: TabBar(
                  //isScrollable: true,
                  indicatorColor: Colors.white,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(icon: Icon(Icons.next_week), text: 'UpComing '),
                    Tab(icon: Icon(Icons.open_in_new), text: 'Opened '),
                    Tab(
                      icon: Icon(Icons.history),
                      text: 'History',
                    ),
                  ],
                ),
                elevation: 30,
                titleSpacing: 50,
              ),
              body: TabBarView(
                children: [
                  FutureBuilder<List<FullMatch>>(
                      future: MatchServices().getUsersMatched(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FullMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Container(
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
                          );
                        }
                        return createMatchesListView(context, snapshot);
                      }),
                  FutureBuilder<List<HomePageMatch>>(
                      future: MatchServices().getUserOpenMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<HomePageMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  itemBuilder: (context, index) {
                                    final colors = [
                                      Colors.black,
                                      Colors.purple
                                    ];
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
                        return createOpenMatchesListView(context, snapshot);
                      }),
                  FutureBuilder<List<FullMatch>>(
                      future: MatchServices().getUserEndedMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FullMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  itemBuilder: (context, index) {
                                    final colors = [
                                      Colors.black,
                                      Colors.purple
                                    ];
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
                        return createDecidedMatchesListView(context, snapshot);
                      }),
                ],
              ),
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
        ]);
      });

  Widget createMatchesListView(
      BuildContext context, AsyncSnapshot<List<FullMatch>> snapshot) {
    var values = snapshot.data!;
    return values.length == 0
        ? Container(
            color: Color.fromARGB(255, 250, 245, 245),
            child: Image.asset('assets/images/profile_screen/no_upcoming.jpg',
                fit: BoxFit.scaleDown),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? FullMatchCard(
                      match: values[index], callbackFunction: callback)
                  : Center(
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
            },
          );
  }

  Widget createDecidedMatchesListView(
      BuildContext context, AsyncSnapshot<List<FullMatch>> snapshot) {
    var values = snapshot.data!;

    return values.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Clear history for the moment',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.history_sharp,
                  color: Colors.black,
                  size: 32,
                ),
              ],
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? FullMatchCard(
                      match: values[index], callbackFunction: callback)
                  : Center(
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
            },
          );
  }

  Widget createOpenMatchesListView(
      BuildContext context, AsyncSnapshot<List<HomePageMatch>> snapshot) {
    var values = snapshot.data!;
    return values.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Currently you have no matches opened',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black)),
                  child: InkWell(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 32,
                    ),
                    onTap: () => Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            FutureBuilder<List<LocationModel>>(
                                future: LocationServices().getListOfLocations(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<LocationModel>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      !snapshot.hasData) {
                                    return Center(
                                      child: SpinKitCircle(
                                        size: 50,
                                        itemBuilder: (context, index) {
                                          final colors = [
                                            Colors.black,
                                            Colors.purple
                                          ];
                                          final color =
                                              colors[index % colors.length];
                                          return DecoratedBox(
                                            decoration:
                                                BoxDecoration(color: color),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return AddMatchPage(
                                    password: widget.password,
                                    locations: snapshot.data!,
                                  );
                                }),
                        transitionDuration: Duration(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? OpenMatchCard(
                      password: widget.password,
                      match: values[index],
                      callbackFunction: callback)
                  : Center(
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
            },
          );
  }
}
