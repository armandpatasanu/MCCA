import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SportIcon extends StatelessWidget {
  final String sport;
  final String difficulty;
  const SportIcon({
    Key? key,
    required this.sport,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.grey;
    IconData iconD = Icons.disabled_by_default;
    switch (difficulty) {
      case 'Beginner':
        iconColor = Colors.green;
        break;
      case 'Ocasional':
        iconColor = Colors.yellow;
        break;
      case 'Advanced':
        iconColor = Colors.red;
        break;
      default:
    }
    switch (sport) {
      case 'tenis':
        iconD = Icons.sports_tennis_outlined;
        break;
      case 'football':
        iconD = Icons.sports_football;
        break;
      case 'billiard':
        iconD = Icons.sports;
        break;
      default:
    }

    return Flexible(
      child: Icon(
        iconD,
        color: iconColor,
      ),
    );
  }
}
