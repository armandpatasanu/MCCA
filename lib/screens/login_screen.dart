import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/screens/signup_screen.dart';
import 'package:fitxkonnect/utils/user_greeting/page_title_bar.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/user_greeting/under_part.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:fitxkonnect/utils/widgets/rounded_button.dart';
import 'package:fitxkonnect/utils/widgets/rounded_icon.dart';
import 'package:fitxkonnect/utils/widgets/rounded_input_field.dart';
import 'package:fitxkonnect/utils/widgets/rounded_password_field.dart';
import 'package:flutter/material.dart';

import '../utils/user_greeting/upside.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isResetPressed = false;
  bool _hidePass = false;

  void resetPassword() async {
    String result = await AuthMethods().resetPassword(
      email: _emailController.text.trim(),
    );

    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      showSnackBar(
          'Check your email in order to reset your password!', context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  void initState() {
    _hidePass = true;
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().logInUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print(result);

    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              HomePage(password: _passwordController.text.trim())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: isResetPressed == true
            ? SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      const Upside(
                        imgUrl: "assets/images/reg_log/login.png",
                      ),
                      const PageTitleBar(
                        title: 'Reset your password',
                        topPadding: 260,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 320.0),
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
                                height: 15,
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    const Text(
                                      "Enter your account's email",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'OpenSans',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RoundedInputField(
                                      hintText: "Email",
                                      icon: Icons.email,
                                      controller: _emailController,
                                    ),
                                    RoundedButton(
                                      isLoading: _isLoading,
                                      text: 'REQUEST',
                                      press: resetPassword,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    UnderPart(
                                      title: "Don't have an account?",
                                      navigatorText: "Register here",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUpScreen()));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
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
              )
            : SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      const Upside(
                        imgUrl: "assets/images/reg_log/login.png",
                      ),
                      const PageTitleBar(
                        title: 'Login to your account',
                        topPadding: 260,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 320.0),
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
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Welcome to",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Text(
                                    " FitXKonnekt",
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    RoundedInputField(
                                      hintText: "Email",
                                      icon: Icons.email,
                                      controller: _emailController,
                                    ),
                                    RoundedPasswordField(
                                      controller: _passwordController,
                                      passwordVisible: true,
                                    ),
                                    RoundedButton(
                                      textColor: Colors.black,
                                      isLoading: _isLoading,
                                      text: 'LOGIN',
                                      press: () {
                                        logInUser();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    UnderPart(
                                      title: "Don't have an account?",
                                      navigatorText: "Register here",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUpScreen()));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        onTap: () => setState(() {
                                              isResetPressed = true;
                                            })),
                                    const SizedBox(
                                      height: 20,
                                    )
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
      ),
    );
  }
}
