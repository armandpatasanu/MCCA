import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/screens/details_page.dart';
import 'package:fitxkonnect/screens/filter_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/custom_details_button.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_spinkit/flutter_spinkit.dart';

class FilterLocationScreen extends StatefulWidget {
  final List<Map<LocationModel, List<String>>> map_loc;
  final String password;
  final List<SportModel> sports;
  FilterLocationScreen({
    Key? key,
    required this.sports,
    required this.map_loc,
    required this.password,
  }) : super(key: key);

  @override
  State<FilterLocationScreen> createState() => _FilterLocationScreenState();
}

class _FilterLocationScreenState extends State<FilterLocationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _locationController = TextEditingController();
  List<Map<LocationModel, List<String>>> _locations = [];
  List<Map<LocationModel, List<String>>> initialList = [];
  List<String> _sportsAtLocation = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<LocationModel> oof = [];

    _locations = widget.map_loc;
    initialList = widget.map_loc;
  }

  void searchLocations(String v) {
    if (v == "") {
      _locations = widget.map_loc;
    }
    final searchQuery = v.toLowerCase();
    final List<Map<LocationModel, List<String>>> filteredLocations = [];
    initialList.forEach((element) {
      if (element.keys.first.name.toLowerCase().contains(searchQuery)) {
        filteredLocations.add(element);
      }
    });
    _locations = filteredLocations;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      // bottomNavigationBar: NaviBar(index: 1),
      body: Container(
        width: 500,
        height: 850,
        color: Colors.white,
        child: Stack(
          children: [
            // Container(
            //   color: Colors.white,
            //   child: TextButton.icon(
            //     //onPressed: handleMarkers,
            //     icon: Icon(Icons.sports_tennis),
            //     label: Text('Only this'),
            //   ),
            // ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    margin: EdgeInsets.only(top: 42, left: 15),
                    height: 40,
                    width: 210,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.white,
                      //     Color.fromRGBO(255, 188, 143, 1),
                      //   ],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.withOpacity(0.10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.3),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 1),
                      //   )
                      // ]),
                    ),
                    child: Container(
                      height: 30,
                      width: 50,
                      child: Row(
                        children: [
                          Icon(Icons.search, color: kPrimaryLightColor),
                          Flexible(
                            child: TextFormField(
                              onChanged: (value) => searchLocations(value),
                              controller: _locationController,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Search in Timișoara',
                                  hintStyle: const TextStyle(
                                    fontFamily: "Netflix",
                                    fontSize: 15,
                                    letterSpacing: 0.0,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 37, left: 10),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.white,
                      //     Color.fromRGBO(255, 188, 143, 1),
                      //   ],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.withOpacity(0.10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.3),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 1),
                      //   )
                      // ]),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  MapScreen(
                                password: widget.password,
                                loc_maps: _locations,
                                filteredSport: "LIST",
                                listOfSports: widget.sports,
                              ),
                              transitionDuration: Duration(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'MAP',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Netflix",
                                // fontWeight: FontWeight.w600,
                                fontWeight: ui.FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
            Positioned(
              top: 110,
              child: Container(
                height: 750,
                // color: Colors.amber,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: _tabController, children: [
                  RefreshIndicator(
                    strokeWidth: 3,
                    displacement: 0,
                    color: Colors.black,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    onRefresh: () async {
                      _locations = await LocationServices().getMapOfLocations();
                      setState(() {});
                      return Future.value(false);
                    },
                    child: ListView.builder(
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            trailing: SizedBox(
                              width: 90,
                              height: 25,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount:
                                      _locations[index].values.first.length,
                                  itemBuilder: (context, indecs) {
                                    return convertSportToIcon(
                                        _locations[index].values.first[indecs],
                                        '',
                                        Colors.grey);
                                  }),
                            ),
                            leading: Column(
                              children: [
                                const Icon(
                                  Icons.social_distance,
                                  color: Colors.grey,
                                ),
                                Text(
                                  _locations[index].keys.first.distance + " km",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              _locations[index].keys.first.name,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              _locations[index].keys.first.contact[0],
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () => {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1,
                                              animation2) =>
                                          FutureBuilder(
                                              future: Future.wait([
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child(
                                                        "locationPics/backgroundPics/${_locations[index].keys.first.locationId}.jpg")
                                                    .getDownloadURL(),
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child(
                                                        "locationPics/profilePics/${_locations[index].keys.first.locationId}.jpg")
                                                    .getDownloadURL(),
                                                LocationServices()
                                                    .getCertainLocation(
                                                        _locations[index]
                                                            .keys
                                                            .first
                                                            .locationId),
                                                UserServices().getSpecificUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid),
                                              ]),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<List<dynamic>>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: SpinKitCircle(
                                                          size: 50,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final colors = [
                                                              Colors.black,
                                                              Colors.purple
                                                            ];
                                                            final color =
                                                                colors[index %
                                                                    colors
                                                                        .length];
                                                            return DecoratedBox(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color:
                                                                          color),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return DetailPage(
                                                    password: widget.password,
                                                    backIcon: true,
                                                    bkg: snapshot.data![0],
                                                    profile: snapshot.data![1],
                                                    location: snapshot.data![2],
                                                    user: snapshot.data![3],
                                                    map_loc: widget.map_loc,
                                                    sports: widget.sports,
                                                    locationId:
                                                        _locations[index]
                                                            .keys
                                                            .first
                                                            .locationId);
                                              }),
                                      transitionDuration: Duration(),
                                    ),
                                  )
                                });
                      },
                    ),
                  ),
                  // Container(height: 600, child: EditPr()),
                  Container(
                    color: Colors.white,
                    child: FilterPage(
                        password: widget.password,
                        map_loc: widget.map_loc,
                        sports: widget.sports),
                  ),
                ]),
              ),
            ),
            Positioned(
              top: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      indicatorColor: Colors.orange,
                      indicatorWeight: 4,
                      labelPadding: const EdgeInsets.only(left: 0, right: 0),
                      controller: _tabController,
                      labelColor: kPrimaryLightColor,
                      unselectedLabelColor: Colors.grey,
                      // isScrollable: true,
                      tabs: [
                        Tab(text: "LOCATIONS"),
                        Tab(text: "FILTER"),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
