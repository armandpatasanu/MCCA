import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/services/firestore_methods.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/date_time_picker.dart';
import 'package:fitxkonnect/utils/widgets/locations_dropdown.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/toggle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:fitxkonnect/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMatchPage extends StatefulWidget {
  final String password;
  final List<LocationModel> locations;
  @override
  _AddMatchPageState createState() => _AddMatchPageState();
  AddMatchPage({
    Key? key,
    required this.password,
    required this.locations,
  }) : super(key: key);
}

class _AddMatchPageState extends State<AddMatchPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();

  bool _isLoading = false;
  List<bool> _isSelected = [false, false, false];
  String? selectedValue;
  List<LocationModel> _locations = [];
  List<LocationModel> _initialLocations = [];
  List<Map<LocationModel, List<String>>> lol = [];

  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  String sportName = "Choose a sport";
  String difficulty = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialLocations = widget.locations;
    _locations = widget.locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NaviBar(
        password: widget.password,
        index: 2,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Future.wait([
            UserServices()
                .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
            SportServices()
                .getUsersSportsPlayed(FirebaseAuth.instance.currentUser!.uid),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(
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
              );
            }
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.bounceInOut,
                  top: 200,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.bounceInOut,
                    height: isSignupScreen ? 380 : 250,
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.45),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildSignupSection(snapshot.data![1], _locations),
                        ],
                      ),
                    ),
                  ),
                ),
                buildBottomHalfContainer(),
                buildPicContainer(snapshot.data![0].profilePhoto),
              ],
            );
          }),
    );
  }

  Container buildSignupSection(
      List<dynamic> snap, List<LocationModel> locations) {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a match',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: Color(0xfff575861)),
          ),
          //buildTextField(Icons.place, "Location", _locationController),
          // buildTextField(Icons.sports_kabaddi, "Sport", _sportController),

          buildSportsDropwDownList(snap),
          SizedBox(
            height: 10,
          ),

          buildLocationsDropDown(locations),
          // LocationsDropDownList(),
          SizedBox(
            height: 18,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 25,
                    color: Colors.purple,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Select Match Date",
                      style: TextStyle(fontSize: 21, color: textColor1)),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                height: 50,
                width: 250,
                // padding: EdgeInsets.only(left: 35),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20)),

                child: DateTimeField(
                  resetIcon: Icon(
                    Icons.restore,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                  controller: _dateTimeController,
                  style: TextStyle(fontSize: 16, color: textColor1),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: 'Day/Month/Year - Time',
                    hintStyle: TextStyle(fontSize: 16, color: textColor1),
                  ),
                  format: DateFormat('yyyy-MM-dd HH:mm::ss'),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()));
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: 555,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.35),
                      blurRadius: 7,
                      spreadRadius: 2),
                ]),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.purple,
                  Colors.black,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              child: InkWell(
                onTap: () => createMatch(),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  Widget buildPicContainer(String url) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: 120,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 130, 68, 141),
                Color.fromARGB(255, 40, 39, 39),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              // color: Colors.purple[200],
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.45),
                    blurRadius: 15,
                    spreadRadius: 5),
              ]),
          child: ProfilePic(
            profilePhoto: url,
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        style: TextStyle(color: kPrimaryColor),
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: textColor1),
        ),
      ),
    );
  }

  var setDefaultMake = true, setDefaultMakeModel = true;
  Widget buildSportsDropwDownList(List<dynamic> snap) {
    return DropdownButton2(
      hint: Text(
        sportName,
        style: TextStyle(color: textColor1),
      ),
      icon: Icon(
        Icons.arrow_downward,
        size: 18,
        color: Colors.purple,
      ),
      isExpanded: false,
      items: snap.map((whatdeactual) {
        return DropdownMenuItem(
            value: whatdeactual['sport'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                convertSportToIcon(whatdeactual['sport'], '', Colors.grey),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${whatdeactual['sport']}",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("[${whatdeactual['difficulty']}]",
                    style: TextStyle(color: Colors.purple)),
              ],
            ));
      }).toList(),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      // dropdownElevation: 8,
      offset: Offset(-20, 0),
      dropdownWidth: 250,
      scrollbarRadius: const Radius.circular(40),
      onChanged: (value) async {
        List<LocationModel> lmao = await LocationServices()
            .getLocationsWhereSportIsPlayed(value.toString());

        setState(
          () {
            _locations = lmao;
            sportName = value.toString();
            for (var m in snap) {
              if (m['sport'] == sportName) {
                difficulty = m['difficulty'];
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget buildLocationsDropDown(List<LocationModel> locations) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 25,
            ),
            Icon(
              Icons.list,
              size: 18,
              color: Colors.purple,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                "Pick location",
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
        items: locations
            .map((item) => DropdownMenuItem<String>(
                  value: item.name,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(item.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor1,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        icon: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        dropdownWidth: 220,
        iconSize: 15,
        iconEnabledColor: Colors.purple,
        buttonHeight: 50,
        buttonWidth: 250,
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

  void clearTextFields() {
    _dateTimeController.clear();
    _locationController.clear();
    sportName = "Choose a sport";
    selectedValue = null;
    _sportController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateTimeController.dispose();
    _locationController.dispose();

    _sportController.dispose();
    super.dispose();
  }

  createMatch() async {
    String result = await FirestoreMethods().createMatch(
      FirebaseAuth.instance.currentUser!.uid,
      selectedValue,
      _dateTimeController.text,
      sportName,
      difficulty,
      'open',
    );

    if (result == 'success') {
      showSnackBar('succesfully created a match!', context);
      clearTextFields();
      _locations = _initialLocations;
    } else {
      showSnackBar(result, context);
    }
  }
}
