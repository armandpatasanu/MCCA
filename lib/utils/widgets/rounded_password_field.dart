import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  bool passwordVisible;
  RoundedPasswordField({
    Key? key,
    required this.controller,
    required this.passwordVisible,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontFamily: 'OpenSans'),
        controller: widget.controller,
        obscureText: widget.passwordVisible,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintText: "Password",
            hintStyle: TextStyle(fontFamily: 'OpenSans', color: kPrimaryColor),
            suffixIcon: IconButton(
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  widget.passwordVisible = !widget.passwordVisible;
                });
              },
              icon: Icon(widget.passwordVisible == false
                  ? Icons.visibility
                  : Icons.visibility_off),
              color: kPrimaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }
}
