import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'dart:ui' as ui;
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final String password;
  const SearchPage({Key? key, required this.password}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => AppBloc()),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Container(
            child: FutureBuilder(
                future: Future.wait([
                  LocationServices().getMapOfLocations(),
                  SportServices().getListOfSports(),
                ]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        bottomNavigationBar: NaviBar(
                          password: widget.password,
                          index: 1,
                        ),
                        body: Container(
                          padding: EdgeInsets.only(top: 24),
                          child: Stack(children: [
                            Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new ExactAssetImage(
                                      'assets/images/map_screen/loading_map.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: new BackdropFilter(
                                filter: new ui.ImageFilter.blur(
                                    sigmaX: 1.0, sigmaY: 1.0),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                              ),
                            ),
                            Center(
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
                          ]),
                        ));
                  }
                  return MapScreen(
                    password: widget.password,
                    filteredSport: "LIST",
                    loc_maps: snapshot.data![0],
                    listOfSports: snapshot.data![1],
                  );
                })),
        // child: MapScreen(
        //   locations: [],
        // ),
      ),
    );
  }
}
