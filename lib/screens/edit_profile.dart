import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/firestore_methods.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/user_greeting/page_title_bar.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/date_time_picker.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:fitxkonnect/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  final String password;
  final UserModel snap;

  EditProfilePage({
    Key? key,
    required this.snap,
    required this.password,
  }) : super(key: key);
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String sportName = "Tenis";
  String? _country;
  Uint8List? _image;
  bool _passwordVisible = true;

  void initState() {
    addData();
    _country = widget.snap.country;
  }

  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  String? selectedValue;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.snap;
    //_image = Uint8List.fromList(widget.snap.profilePhoto.codeUnits);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 95 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 530 : 250,
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildSignupSection(user),
                  ],
                ),
              ),
            ),
          ),
          buildSaveButton(false, user),
          buildCancelButton(false, user),
          buildGoBackButton(),
        ],
      ),
    );
  }

  Container buildSignupSection(UserModel user) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 10,
                        blurRadius: 20,
                        color: Colors.green.withOpacity(0.3),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                ),
                child: _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10),
          const Text(
            'Edit your profile',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: Color(0xfff575861)),
          ),
          SizedBox(height: 25),
          buildTextField(Icons.person, user.fullName, _fullNameController),
          SizedBox(height: 10),
          buildTextField(Icons.email, user.email, _emailController),
          SizedBox(height: 10),
          buildPassField(Icons.lock, 'password', _passwordController),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: OutlinedButton.icon(
                    icon: const Text(
                      'Edit your country',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: 'OpenSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 1.0,
                        color: kPrimaryColor,
                      ),
                    ),
                    label: const Icon(
                      Icons.map,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: false,
                        showWorldWide: false,
                        onSelect: (Country country) {
                          setState(() {
                            _country = country.countryCode + country.flagEmoji;
                          });
                        },
                      );
                    },
                  ),
                ),
                _country != null
                    ? Text(_country!,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton(bool showShadow, UserModel user) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 570 : 430,
      right: 0,
      left: 150,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5),
            ],
          ),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green,
                      kPrimaryColor,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      updateUserData(
                        user,
                      );
                      print(user.profilePhoto);
                    },
                    child: _isLoading
                        ? const Center(
                            child: SpinKitCircle(
                              size: 24,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.save_alt,
                            color: Colors.white,
                          ),
                  ),
                )
              : Center(),
        ),
      ),
    );
  }

  Widget buildGoBackButton() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: 110,
      right: 280,
      left: 0,
      child: Center(
        child: InkWell(
          child: Icon(
            Icons.undo,
            color: Colors.green,
            size: 32,
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        password: widget.password,
                      ))),
        ),
      ),
    );
  }

  Widget buildCancelButton(bool showShadow, UserModel user) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 570 : 430,
      right: 150,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5),
            ],
          ),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.grey,
                      kPrimaryColor,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ],
                  ),
                  child: InkWell(
                    onTap: () => resetFields(user),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              : Center(),
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

  Widget buildPassField(
      IconData icon, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        obscureText: _passwordVisible,
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
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(_passwordVisible == false
                ? Icons.visibility
                : Icons.visibility_off),
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void clearTextFields() {
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void resetFields(UserModel user) {
    clearTextFields();
    _country = user.country;
    _image = null;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> updateUserData(UserModel user) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String result = "";
      User uzer = FirebaseAuth.instance.currentUser!;

      _image != null
          ? result = await UserServices().updateUser(
              user.uid,
              uzer,
              _fullNameController.text != ''
                  ? _fullNameController.text
                  : user.fullName,
              _emailController.text != '' ? _emailController.text : user.email,
              user.email,
              _passwordController.text,
              widget.password,
              _country!,
              _image ?? Uint8List.fromList([]),
              true,
            )
          : result = result = await UserServices().updateUser(
              user.uid,
              uzer,
              _fullNameController.text != ''
                  ? _fullNameController.text
                  : user.fullName,
              _emailController.text != '' ? _emailController.text : user.email,
              user.email,
              _passwordController.text,
              widget.password,
              _country!,
              _image ?? Uint8List.fromList([]),
              false,
            );

      if (result == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('successfully edited !', context);
        UserModel user2 = await UserServices()
            .getSpecificUser(FirebaseAuth.instance.currentUser!.uid);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  password: widget.password,
                  snap: user2,
                )));
        // clearTextFields();
        setState(() {});
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(result, context);
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }
}
