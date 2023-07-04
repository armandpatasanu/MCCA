import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    required this.profilePhoto,
  }) : super(key: key);
  final String profilePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              profilePhoto,
            ),
          ),
        ],
      ),
    );
  }
}
