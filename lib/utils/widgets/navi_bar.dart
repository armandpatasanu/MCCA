import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/screens/add_match_page.dart';
import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../services/location_services.dart';

class NaviBar extends StatefulWidget {
  final String password;
  final int index;
  const NaviBar({Key? key, required this.index, required this.password})
      : super(key: key);

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int index = 0;

  void buildBody(BuildContext context) {
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SearchPage(
              password: widget.password,
            ),
            transitionDuration: Duration(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                FutureBuilder<List<LocationModel>>(
                    future: LocationServices().getListOfLocations(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<LocationModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return Scaffold(
                          bottomNavigationBar:
                              NaviBar(index: 2, password: widget.password),
                          body: Container(
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
                      return AddMatchPage(
                        password: widget.password,
                        locations: snapshot.data!,
                      );
                    }),
            transitionDuration: Duration(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ProfilePage(password: widget.password),
            transitionDuration: Duration(),
          ),
        );
        break;
      // default:
      //   return FutureBuilder(
      //       future: MatchServices().getHomePageMatches(),
      //       builder: (BuildContext context,
      //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }
      //         return HomePage(snapshot: snapshot);
      //       });
      default:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(
              password: widget.password,
            ),
            transitionDuration: Duration(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      backgroundColor: Colors.white,
      containerHeight: 65,
      selectedIndex: widget.index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(
            Icons.feed,
          ),
          title: Text('Home'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.search),
          title: Text('Explore'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.add),
          title: Text('MatchUp'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('Profile'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
      ],
      onItemSelected: (index) => setState(() {
        this.index = index;
        buildBody(context);
      }),
    );
  }
}
