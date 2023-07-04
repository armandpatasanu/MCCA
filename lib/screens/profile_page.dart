import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/configure_sport_page.dart';
import 'package:fitxkonnect/screens/edit_profile.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/screens/my_matches_page.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_menu.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/custom_details_button.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:fitxkonnect/utils/widgets/profile_sport_icon.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/location_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class ProfilePage extends StatefulWidget {
  final String password;
  ProfilePage({Key? key, required this.password}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double pinPillPosition = PIN_INVISIBLE_POSITION;
  bool isEditVisible = false;
  Color? _sportsColor;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          UserServices()
              .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
          SportServices().getNotConfiguredSports(
              FirebaseAuth.instance.currentUser!.uid), //REDESIGN NEEDED!
          SportServices().getUsersSportsPlayed(FirebaseAuth
              .instance.currentUser!.uid) // REDESIGN NEEDED, no more
          // "sports" field used for UserModel
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> user) {
          if (user.connectionState == ConnectionState.waiting ||
              !user.hasData) {
            return Scaffold(
              bottomNavigationBar: NaviBar(
                index: 3,
                password: widget.password,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.purple,
                    Colors.black,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: Center(
                  child: SpinKitCircle(
                    size: 50,
                    itemBuilder: (context, index) {
                      final colors = [Colors.black, Colors.white];
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
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Colors.purple, Colors.black]),
                  ),
                ),
                // backgroundColor: Colors.purple,
                toolbarHeight: 40,
                actions: [
                  IconButton(
                    onPressed: () async {
                      await AuthMethods().logOutUser();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => LoginScreen()),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NotificationsPage(
                                password: widget.password,
                              )));
                    },
                    icon: Icon(
                      Icons.notifications,
                    ),
                  ),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.purple,
                    Colors.black,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 130, 68, 141),
                                  Color.fromARGB(255, 40, 39, 39),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            // color: Colors.purple[200],
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ]),
                        child: ProfilePic(
                            profilePhoto: user.data![0].profilePhoto ?? ''),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${user.data![0].fullName}, ${user.data![0].age}',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        user.data![0].country,
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(user.data![0].email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(height: 2),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sports Played:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: user.data![2].length,
                              itemBuilder: (context, index) {
                                switch (user.data![2][index]['difficulty']) {
                                  case 'Beginner':
                                    _sportsColor = Colors.green;
                                    break;
                                  case 'Ocasional':
                                    _sportsColor = Colors.amber;
                                    break;
                                  case 'Advanced':
                                    _sportsColor = Colors.red;
                                    break;
                                }
                                return Row(
                                  children: [
                                    convertSportToIcon(
                                      user.data![2][index]['sport'],
                                      '',
                                      _sportsColor!,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ProfileMenu(
                        text: "Sports Configuration",
                        icon: 'assets/images/profile_screen/edit_sport.png',
                        press: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                ConfigureSportPage(
                              password: widget.password,
                              user: user.data![0],
                              not_conf_sports: user.data![1],
                              conf_sports: user.data![2],
                            ),
                            transitionDuration: Duration(),
                          ));
                        },
                      ),
                      ProfileMenu(
                        text: "Edit Profile",
                        icon: 'assets/images/profile_screen/edit_profile.png',
                        press: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => FutureBuilder(
                                      future: UserServices().getSpecificUser(
                                          //add another future builder for
                                          //configured sports, so the button won't reload in the page
                                          // pass the list as parameters, another example in map page already done
                                          FirebaseAuth
                                              .instance.currentUser!.uid),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<UserModel> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Scaffold(
                                            bottomNavigationBar: NaviBar(
                                                index: 3,
                                                password: widget.password),
                                            body: Container(
                                              color: Colors.white,
                                              child: Center(
                                                child: SpinKitCircle(
                                                  size: 50,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final colors = [
                                                      Colors.white,
                                                      Colors.purple
                                                    ];
                                                    final color = colors[
                                                        index % colors.length];
                                                    return DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: color),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return EditProfilePage(
                                            password: widget.password,
                                            snap: snapshot.data!);
                                      })));
                        },
                      ),
                      ProfileMenu(
                        text: "My Matches",
                        icon:
                            'assets/images/profile_screen/my_matches_icon.png',
                        press: () async {
                          await MatchServices().handleMatched();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => MyMatchesPage(
                                        password: widget.password,
                                        user: user.data![0],
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: NaviBar(
                password: widget.password,
                index: 3,
              ),
            ),
          ]);
        });
  }
}
