import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportButton extends StatelessWidget {
  const SportButton(
      {Key? key, this.press, this.textColor = Colors.amber, required this.text})
      : super(key: key);
  final String text;
  final Function()? press;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        ElevatedButton(onPressed: () {}, child: Text(text)),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
