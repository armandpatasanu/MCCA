import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/user_greeting/page_title_bar.dart';
import 'package:fitxkonnect/utils/user_greeting/under_part.dart';
import 'package:fitxkonnect/utils/widgets/age_widget.dart';
import 'package:fitxkonnect/utils/widgets/rounded_input_field.dart';
import 'package:fitxkonnect/utils/widgets/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';
import '../utils/widgets/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  String? _country;
  String? _age;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hidePass = true;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  @override
  void initState() {
    _hidePass = true;
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    String result = await AuthMethods().registerValidation(
      email: _emailController.text,
      password: _passwordController.text,
      age: _dateTimeController.text != ''
          ? (DateTime.now().year -
                  int.parse(_dateTimeController.text.substring(6, 10)))
              .toString()
          : '',
      fullName: _fullNameController.text,
      country: _country,
      file: _image,
      matches: [],
      sports: [],
      token: token,
    );

    setState(() {
      _isLoading = false;
    });
    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      showSnackBar('Your account has been successfully created!', context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String countryToChange = "";
    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 180),
                width: size.width,
                height: size.height / 2,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 64,
                              backgroundImage: AssetImage(
                                  'assets/images/reg_log/default_profile.png'),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color.fromARGB(255, 207, 157, 216),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const PageTitleBar(
                topPadding: 200,
                title: 'Create New Account',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 255.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            RoundedInputField(
                              hintText: "Email",
                              icon: Icons.email,
                              controller: _emailController,
                            ),
                            RoundedInputField(
                              hintText: "Full Name",
                              icon: Icons.person,
                              controller: _fullNameController,
                            ),
                            DateOfBirthField(
                              hintText: "Age",
                              icon: Icons.email,
                              controller: _dateTimeController,
                            ),
                            RoundedPasswordField(
                              controller: _passwordController,
                              passwordVisible: true,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: OutlinedButton.icon(
                                      icon: const Text(
                                        'Choose your country',
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
                                              _country = country.countryCode +
                                                  country.flagEmoji;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  _country != null
                                      ? Text('$_country',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))
                                      : Container(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RoundedButton(
                              isLoading: _isLoading,
                              text: 'REGISTER',
                              press: signUpUser,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UnderPart(
                              title: "Already have an account?",
                              navigatorText: "Login here",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
