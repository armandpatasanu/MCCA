import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ConfigureSportPage extends StatefulWidget {
  final String password;
  final List<String> not_conf_sports;
  final List<dynamic> conf_sports;
  final UserModel user;
  ConfigureSportPage(
      {Key? key,
      required this.user,
      required this.not_conf_sports,
      required this.conf_sports,
      required this.password})
      : super(key: key);

  @override
  State<ConfigureSportPage> createState() => _ConfigureSportPageState();
}

class _ConfigureSportPageState extends State<ConfigureSportPage> {
  String? _sport;
  String? _difficulty;
  List<bool> _isSelected = List.generate(3, (index) => false);
  bool _isFirstContainerVisible = false;
  bool _isSecondContainerVisible = false;
  String _diffFilter = "all";
  List<bool> _diffSelected = [false, false, false];
  int _diffValue = 0;
  List<int> _diffValuez = [];
  int _dayValue = 0;
  String _dayFilter = "all";
  String sportName = "Choose a sport";

  @override
  void initState() {
    super.initState();
    _diffValuez = List.generate(
        widget.conf_sports.length,
        (index) =>
            getIntFromDifficulty(widget.conf_sports[index].values.first));
  }

  addSport(String uid, String dif, String sport) async {
    String result = await SportServices().addSport(uid, dif, sport);

    if (result == 'success') {
      _diffValuez.add(getIntFromDifficulty(dif));
      clearFields();
      showSnackBar('$sport has been configured!', context);
    } else {
      showSnackBar(result, context);
    }
  }

  saveSports(String userId) async {
    showSnackBar('Succesfully updated the sports!', context);
    for (int i = 0; i < _diffValuez.length; i++) {}

    await SportServices().saveSportsConfiguration(userId, _diffValuez);
  }

  void deleteSport(String uid, String sport, int ind) async {
    await SportServices().deleteSport(uid, sport);
    // _diffValuez.removeAt(ind);

    showSnackBar("$sport has been deleted!", context);
  }

  Future<String> getNameFromId(String id) async {
    return (await SportServices().getSpecificSportFromId(id)).name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NaviBar(
        password: widget.password,
        index: 3,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
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
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Material(
                color: Colors.white,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePic(profilePhoto: widget.user.profilePhoto),
                      Text(
                        widget.user.fullName + ', ' + widget.user.country,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfff575861)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 5),
                                ]),
                            child: TextButton.icon(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              label: Text(
                                'Add sport',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSecondContainerVisible = false;
                                  _isFirstContainerVisible =
                                      !_isFirstContainerVisible;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 5),
                                ]),
                            child: TextButton.icon(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              label: Text(
                                'Edit sport',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFirstContainerVisible = false;
                                  _isSecondContainerVisible =
                                      !_isSecondContainerVisible;
                                });
                              },
                              icon: Icon(
                                Icons.edit_note,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildFirstContainer(snapshot),
                      buildSecondContainer(snapshot),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget buildSportsDropDown(AsyncSnapshot snapshot) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                sportName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: snapshot.data!['sports_not_configured']
            .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                  value: item,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.star,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                        ),
                        TextSpan(
                            text: item as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            sportName = value.toString();
          });
        },
        icon: const Icon(Icons.arrow_downward_sharp),
        iconSize: 21,
        iconEnabledColor: Colors.black,
        buttonHeight: 50,
        buttonWidth: 180,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black26,
          ),
          color: Colors.white,
        ).copyWith(
          boxShadow: kElevationToShadow[2],
        ),
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 200,
        dropdownPadding: null,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
      ),
    );
  }

  @override
  Widget buildFirstContainer(AsyncSnapshot snapshot) {
    return AnimatedContainer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 35),
              child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      buildSportsDropDown(snapshot),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/easy.png',
                              1,
                              'Beginner'),
                          SizedBox(
                            width: 10,
                          ),
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/medium.png',
                              2,
                              'Ocasional'),
                          SizedBox(
                            width: 10,
                          ),
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/hard.png',
                              3,
                              'Advanced'),
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    label: Text('Configure'),
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      addSport(widget.user.uid, _diffFilter, sportName);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5),
            ]),
        duration: Duration(seconds: 0),
        // color: Colors.red,
        height: _isFirstContainerVisible
            ? MediaQuery.of(context).size.height * 0.3
            : 0.0,
        width: _isFirstContainerVisible
            ? MediaQuery.of(context).size.width * 0.7
            : 0.0);
  }

  void clearFields() {
    sportName = "Choose a sport";
    for (int i = 0; i < 3; i++) {
      _diffSelected[i] = false;
    }
    setState(() {});
    _diffValue = 0;
    _diffFilter = "all";
  }

  int getIntFromDifficulty(String dif) {
    switch (dif) {
      case 'Beginner':
        return 1;
      case 'Ocasional':
        return 2;
      case 'Advanced':
        return 3;
      default:
        return 9;
    }
  }

  @override
  Widget buildSecondContainer(AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Center(
        child: AnimatedContainer(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 0),
                height: 38,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sport',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 120,
                    ),
                    Text('Difficulty',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                height: 175,
                // color: Colors.blue,
                padding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: snapshot.data!["sports_configured"].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        title: Row(
                          children: [
                            InkWell(
                                child: Icon(Icons.delete,
                                    color: Color.fromARGB(255, 185, 31, 31)),
                                onTap: () {
                                  deleteSport(
                                      widget.user.uid,
                                      snapshot.data!["sports_configured"][index]
                                          .values.last,
                                      index);
                                  setState(() {});
                                }),
                            Text(
                              snapshot.data!["sports_configured"][index].values
                                  .last,
                              style: TextStyle(
                                color: Color.fromARGB(255, 62, 47, 94),
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 144,
                          height: 20,
                          child: Row(
                            children: [
                              buildDiffRadioText(1, index),
                              buildDiffRadioText(2, index),
                              buildDiffRadioText(3, index),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    color: Colors.white),
                child: IconButton(
                  icon: Icon(Icons.save, color: Colors.green),
                  onPressed: () {
                    saveSports(FirebaseAuth.instance.currentUser!.uid);
                  },
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5),
              ]),
          duration: Duration(seconds: 0),
          // color: Colors.red,
          height: _isSecondContainerVisible
              ? MediaQuery.of(context).size.height * 0.36
              : 0.0,
          width: _isSecondContainerVisible
              ? MediaQuery.of(context).size.width * 0.8
              : 0.0,
        ),
      ),
    );
  }

  Widget buildDifficultyRadioText(String photo, int index, String diff) {
    return Column(
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: _diffSelected[index - 1] == true
                  ? MaterialStateProperty.all(kPrimaryColor)
                  : MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected))
                    return Colors.redAccent;
                  return null;
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
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                  // color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )),
        Text(diff,
            style: TextStyle(
              color: _diffSelected[index - 1] == true
                  ? Colors.purple
                  : kPrimaryColor,
            )),
      ],
    );
  }

  Widget buildDiffRadioText(int index, int index2) {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: Color.fromARGB(255, 62, 47, 94),
          disabledColor: Colors.blue),
      child: Radio(
        activeColor: index == 1
            ? Colors.green
            : index == 2
                ? Colors.amber
                : Colors.red,
        value: index,
        groupValue: _diffValuez[index2],
        onChanged: (value) {
          setState(() {
            setState(() {
              _dayFilter = getDayFromValue(index);
              _diffValuez[index2] = index;
            });
          });
        },
      ),
    );
  }
}
