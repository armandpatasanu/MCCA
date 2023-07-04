import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:fitxkonnect/utils/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingMatchCard extends StatefulWidget {
  LoadingMatchCard({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingMatchCard> createState() => _LoadingMatchCardState();
}

class _LoadingMatchCardState extends State<LoadingMatchCard> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(bottom: 20),
      height: 240,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
          Positioned(
            left: 160,
            top: 0,
            child: Container(
              height: 115,
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Skeleton(),
                  SizedBox(
                    height: 15,
                  ),
                  Skeleton(),
                  SizedBox(
                    height: 15,
                  ),
                  Skeleton(),
                ],
              ),
              width: 180,
              // margin: EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: 150,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Container(child: SmallCircleSkeleton()),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 250,
              ),
              Positioned(
                top: 132,
                left: 5,
                child: Container(
                  height: 70,
                  width: 230,
                  margin: EdgeInsets.only(left: 15, right: 20, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Skeleton(),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 10,
                          width: 120,
                          color: Colors.grey.withOpacity(0.1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 35,
                child: CircleSkeleton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
