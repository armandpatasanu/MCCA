import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/age_widget.dart';
import 'package:fitxkonnect/utils/widgets/home_match_skelet.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:fitxkonnect/utils/widgets/special_match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // final snapshot;]
  final String password;
  HomePage({
    Key? key,
    required this.password,
    // this.snapshot,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, bool>> _sportsButtons = [];
  Future<List<Map<String, bool>>>? _getTaskAsync;
  int _counter = 0;
  int _diffValue = 0;
  int _dayValue = 0;
  List<bool> _diffSelected = [false, false, false];
  List<bool> _daySelected = [false, false, false];
  String callbeck = "not changed";
  String startingDate = "";
  String finalDate = "";
  final TextEditingController _startingDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();
  String _diffFilter = "all";
  String _dayFilter = "all";
  String _sportFilter = "all";

  @override
  void initState() {
    _getTaskAsync = SportServices().getButtonsSports();
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // AwesomeNotifications().actionSink.close();
    // AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  callback(String value) {
    setState(() {
      callbeck = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NaviBar(
        password: widget.password,
        index: 0,
      ),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      Flexible(
                        child: FutureBuilder<List<Map<String, bool>>>(
                            future: _getTaskAsync,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return Container();
                              }
                              _sportsButtons = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 35,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                _sportsButtons[index]
                                                            .values
                                                            .first ==
                                                        true
                                                    ? MaterialStateProperty.all(
                                                        Colors.red)
                                                    : MaterialStateProperty.all(
                                                        Color(0xff7fcbd7)),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.selected))
                                                  return Colors
                                                      .redAccent; //<-- SEE HERE
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              int found = 99;
                                              _counter = 0;
                                              for (int i = 0;
                                                  i < _sportsButtons.length;
                                                  i++) {
                                                if (_sportsButtons[i]
                                                        .values
                                                        .first ==
                                                    true) {
                                                  _counter++;
                                                  found = i;
                                                }
                                              }
                                              if (_counter == 0) {
                                                _sportsButtons[index].update(
                                                    _sportsButtons[index]
                                                        .keys
                                                        .first,
                                                    (value) => value = true);

                                                _sportFilter =
                                                    _sportsButtons[index]
                                                        .keys
                                                        .first;
                                              } else if (_counter == 1 &&
                                                  found == index) {
                                                _sportsButtons[found].update(
                                                    _sportsButtons[found]
                                                        .keys
                                                        .first,
                                                    (value) => value = false);
                                                _sportFilter = "all";
                                              } else if (_counter == 1 &&
                                                  found != index) {
                                                _sportsButtons[found].update(
                                                    _sportsButtons[found]
                                                        .keys
                                                        .first,
                                                    (value) => value = false);
                                                _sportsButtons[index].update(
                                                    _sportsButtons[index]
                                                        .keys
                                                        .first,
                                                    (value) => value = true);
                                                _sportFilter =
                                                    _sportsButtons[index]
                                                        .keys
                                                        .first;
                                              }
                                            });
                                          },
                                          // child: convertSportToIcon(
                                          //     snapshot.data![index].keys.first,
                                          //     '',
                                          //      Color(0xff7fcbd7)),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              snapshot.data![index].keys.first,
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ))),
              Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildDifficultyButton(
                            'assets/images/difficulty_icons/easy.png',
                            1,
                            'Beginner'),
                        SizedBox(
                          width: 10,
                        ),
                        buildDifficultyButton(
                            'assets/images/difficulty_icons/medium.png',
                            2,
                            'Ocasional'),
                        SizedBox(
                          width: 10,
                        ),
                        buildDifficultyButton(
                            'assets/images/difficulty_icons/hard.png',
                            3,
                            'Advanced'),
                      ],
                    ),
                  )),
              Container(
                  height: 50,
                  // alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 10,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        buildDayRadioText(
                          'assets/images/time_icons/morning.png',
                          1,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        buildDayRadioText(
                            'assets/images/time_icons/afternoon.png', 2),
                        SizedBox(
                          width: 15,
                        ),
                        buildDayRadioText(
                            'assets/images/time_icons/night.png', 3),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: InkWell(
                            child: Icon(
                              Icons.lock_reset,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _dayValue = 0;
                              _dayFilter = "all";
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.only(top: 10),
                    //   width: 40,
                    //   height: 40,
                    //   child: Text(
                    //     'From',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'OpenSans',
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      // alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 0),
                      width: 120,
                      // color: Colors.green,
                      child: DateTimeField(
                        resetIcon: Icon(
                          Icons.restore,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        controller: _startingDateController,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Starting Date',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        format: DateFormat('yyyy-MM-dd'),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            return date;
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      child: InkWell(
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.purple,
                          size: 28,
                        ),
                        onTap: () {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(top: 10, left: 0),
                    //   width: 20,
                    //   height: 40,
                    //   child: Text(
                    //     'To',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'OpenSans',
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      // alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 0),
                      width: 120,
                      // color: Colors.green,
                      child: DateTimeField(
                        resetIcon: Icon(
                          Icons.restore,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        controller: _finalDateController,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Final Date',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        format: DateFormat('yyyy-MM-dd'),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            return date;
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 301,
                padding: EdgeInsets.only(top: 20),
                child: FutureBuilder(
                    future: Future.wait([
                      MatchServices().getActualHomePageMatches(
                          _sportFilter,
                          _diffFilter,
                          _dayFilter,
                          _startingDateController.text,
                          _finalDateController.text),
                      UserServices().getSpecificUser(
                          FirebaseAuth.instance.currentUser!.uid),
                    ]),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return Container(
                          child: Stack(children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    LoadingMatchCard()),
                            Center(
                                child: Container(
                              height: 90,
                              child: Column(
                                children: [
                                  SpinKitCircle(
                                    size: 50,
                                    itemBuilder: (context, index) {
                                      final colors = [
                                        Colors.black,
                                        Colors.purple
                                      ];
                                      final color =
                                          colors[index % colors.length];
                                      return DecoratedBox(
                                        decoration: BoxDecoration(color: color),
                                      );
                                    },
                                  ),
                                  Text('Refreshing matches',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 16,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                          ]),
                        );
                      }
                      return snapshot.data![0].length == 0
                          ? Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 55, right: 40, bottom: 100),
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                    'assets/images/empty_list.png',
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              child: Column(children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 10,
                                    child: RefreshIndicator(
                                      strokeWidth: 3,
                                      displacement: 0,
                                      color: Colors.black,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      onRefresh: () {
                                        setState(() {});
                                        return Future.value(false);
                                      },
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data![0].length,
                                          itemBuilder: (context, index) =>
                                              SpecialMatchCard(
                                                  snap: snapshot.data![0]
                                                      [index],
                                                  sports_conf: snapshot.data![1]
                                                      .sports_configured,
                                                  callbackFunction: callback)),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDifficultyButton(String photo, int index, String diff) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: _diffSelected[index - 1] == true
              ? MaterialStateProperty.all(kPrimaryColor)
              : MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected))
                return Colors.redAccent; //<-- SEE HERE
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: () {
          setState(() {
            if (index == _diffValue) {
              _diffSelected[index - 1] = !_diffSelected[index - 1];
              _diffFilter = "all";
              _diffValue = 0;
            } else {
              for (int i = 0; i < _diffSelected.length; i++) {
                if (index - 1 != i) {
                  _diffSelected[i] = false;
                }
              }
              _diffSelected[index - 1] = !_diffSelected[index - 1];
              _diffFilter = getDifFromValue(index);
              _diffValue = index;
            }
          });
        },
        child: Row(
          children: [
            Image.asset(
              photo,
              width: 16,
              height: 25,
              fit: BoxFit.cover,
              // color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(diff,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    color: _diffSelected[index - 1] == true
                        ? Colors.white
                        : kPrimaryColor,
                  )),
            ),
          ],
        ));
  }

  Widget buildDayRadioText(String photo, int index) {
    return Row(
      children: [
        Image.asset(
          photo,
          width: 33,
          height: 33,
          fit: BoxFit.cover,
          // color: Colors.grey,
        ),
        Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.black,
              disabledColor: Colors.purple),
          child: Radio(
            value: index,
            activeColor: Colors.purple,
            groupValue: _dayValue,
            onChanged: (value) {
              setState(() {
                setState(() {
                  _dayFilter = getDayFromValue(index);
                  _dayValue = index;
                });
              });
            },
          ),
        ),
      ],
    );
  }
}
