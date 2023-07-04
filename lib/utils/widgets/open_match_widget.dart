import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/rating_bar.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OpenMatchCard extends StatefulWidget {
  final HomePageMatch match;
  final String password;
  final Function callbackFunction;

  OpenMatchCard({
    Key? key,
    required this.match,
    required this.password,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<OpenMatchCard> createState() => _OpenMatchCardState();
}

class _OpenMatchCardState extends State<OpenMatchCard> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.only(left: 10),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 128, 210, 223),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 14),
                  blurRadius: 7,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: CustomPaint(
              size: Size(120, 250),
              painter: CustomCardShapePainter(
                  20, Color(0xff6DC8F3), Color(0xff73A1F9)),
            ),
          ),
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 95,
                    width: 95,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.match.p1Profile,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.match.p1Name,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      Text(
                        '${widget.match.sport} · ${widget.match.difficulty} ·',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              widget.match.matchDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.lock_clock,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              widget.match.startingTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              widget.match.locationName,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: Center(
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_forever_outlined),
                  color: Colors.white,
                  onPressed: () async {
                    await MatchServices().cancelMatch(widget.match.matchId);
                    setState(() {});
                    widget.callbackFunction('callback');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
