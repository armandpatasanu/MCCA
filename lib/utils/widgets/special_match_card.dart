import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SpecialMatchCard extends StatefulWidget {
  final snap;
  final sports_conf;
  final Function callbackFunction;

  SpecialMatchCard({
    Key? key,
    this.snap,
    required this.callbackFunction,
    this.sports_conf,
  }) : super(key: key);

  @override
  State<SpecialMatchCard> createState() => _SpecialMatchCardState();
}

class _SpecialMatchCardState extends State<SpecialMatchCard> {
  UserModel userData = StorageMethods().getEmptyUser();
  LocationModel locationData = StorageMethods().getEmptyLocation();
  bool isLoading = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      // decoration: BoxDecoration(color: Colors.red),
      height: 240,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xff7fcbd7),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 14),
                  blurRadius: 7,
                ),
              ],
              // image: DecorationImage(
              //   colorFilter: new ColorFilter.mode(
              //       Colors.black.withOpacity(0.8), BlendMode.dstATop),
              //   image: (widget.snap.startingTime.substring(0, 2) <= 13 &&
              //           widget.snap.startingTime.substring(0, 2) >= 8)
              //       ? new ExactAssetImage(
              //           'assets/images/period_images/night.jpg')
              //       : (widget.snap.startingTime.substring(0, 2) <= 19 &&
              //               widget.snap.startingTime.substring(0, 2) > 13)
              //           ? new ExactAssetImage(
              //               'assets/images/period_images/night.jpg')
              //           : new ExactAssetImage(
              //               'assets/images/period_images/night.jpg'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Positioned(
            right: 20,
            top: 0,
            child: Container(
              height: 115,
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
              child: Column(
                children: [
                  IconAndTextWidget(
                    icon: Icons.location_on,
                    text: widget.snap.locationName,
                    iconColor: Color.fromARGB(255, 66, 62, 100),
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconAndTextWidget(
                    icon: Icons.calendar_month,
                    text: widget.snap.matchDate,
                    iconColor: Color.fromARGB(255, 66, 62, 100),
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconAndTextWidget(
                    icon: Icons.access_alarm,
                    text: widget.snap.startingTime,
                    iconColor: Color.fromARGB(255, 66, 62, 100),
                    color: kPrimaryColor,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),

              width: 180,
              // margin: EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  kPrimaryLightColor,
                  Color(0xff7fcbd7),
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                // color: Colors.purple[200],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 6,
                      color: Color.fromARGB(255, 96, 155, 164),
                      offset: Offset(-3, 8))
                ],
              ),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Color.fromARGB(56, 202, 157, 215)),
            ),
          ),
          widget.snap.p1uid == FirebaseAuth.instance.currentUser!.uid
              ? Positioned(
                  right: 25,
                  top: 150,
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 51, 132, 145),
                          Color.fromARGB(255, 66, 62, 100)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 66, 62, 100),
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Text(
                        'Cancel',
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async {
                        await MatchServices().cancelMatch(widget.snap.matchId);
                        setState(() {});
                        widget.callbackFunction(widget.snap.locationName);
                      },
                    ),
                  ),
                )
              : MatchServices().checkUsersMatchConditions(widget.snap.sport,
                          widget.snap.difficulty, widget.sports_conf) ==
                      true
                  ? Positioned(
                      right: 25,
                      top: 150,
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: <Color>[Colors.green, Colors.black],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green,
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.play_circle),
                          onPressed: () async {
                            await MatchServices().matchPlayers(
                                widget.snap.matchId,
                                FirebaseAuth.instance.currentUser!.uid);
                            setState(() {});
                            widget.callbackFunction(widget.snap.locationName);
                          },
                        ),
                      ),
                    )
                  : Container(),
          Stack(
            children: [
              Container(
                height: 250,
              ),
              Positioned(
                top: 132,
                left: 5,
                bottom: 0,
                child: Container(
                  height: 70,
                  width: 230,
                  margin: EdgeInsets.only(left: 15, right: 20, bottom: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        kPrimaryLightColor,
                        Color(0xff7fcbd7),
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                      // color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 96, 155, 164),
                            blurRadius: 7,
                            spreadRadius: 2,
                            offset: Offset(4, 0)),
                      ]),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(30),
                  //     // border:
                  //     //     Border.all(color: Color.fromARGB(176, 250, 203, 211)),
                  //     color: Color.fromARGB(80, 202, 157, 215)),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(children: [
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Text(
                        widget.snap.p1Name + ', ' + widget.snap.p1Age,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 93, 58, 157),
                            color: Color.fromARGB(255, 32, 114, 127),
                            fontFamily: 'OpenSans'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: 25,
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.snap.sport,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              convertSportToIcon(widget.snap.sport, '',
                                  Color.fromARGB(255, 66, 62, 100)),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                ' -  ${widget.snap.difficulty}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ]),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 30,
                child: Container(
                    width: 120.0,
                    height: 120.0,
                    padding: EdgeInsets.all(5),
                    child: ProfilePic(profilePhoto: widget.snap.p1Profile),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              kPrimaryLightColor,
                              Color.fromARGB(255, 130, 68, 141),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        // color: Colors.purple[200],
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.45),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ])),
              ),
              Positioned(
                top: 20,
                left: 120,
                child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Text(
                      '${widget.snap.p1Country}',
                      style: TextStyle(fontSize: 28),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
