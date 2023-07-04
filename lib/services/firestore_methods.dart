import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createMatch(
    String player1,
    String? locationName,
    String matchDate,
    String sport,
    String difficulty,
    String status,
  ) async {
    String result = "whatever";
    try {
      if (sport == "Choose a sport") {
        result = "Please select a sport!";
      } else if (locationName == null) {
        result = "Please select a location!";
      } else if (matchDate == "") {
        result = "Select a valid match date!";
      } else {
        String matchId = const Uuid().v1();
        int id = createUniqueId();
        String locationId =
            await LocationServices().getLocationId(locationName);
        String sportId = await SportServices().getSportIdBasedOfName(sport);
        MatchModel match = MatchModel(
          matchId: matchId,
          location: locationId,
          player1: player1,
          player2: "",
          matchDate: matchDate.substring(0, 10),
          startingTime: matchDate.substring(11, 16),
          datePublished: DateTime.now(),
          sport: sport,
          difficulty: difficulty,
          status: status,
          notificationId: id,
        );

        LocationModel matchLocation =
            await LocationServices().getCertainLocation(locationId);

        List locations_sports = matchLocation.sports;

        bool found = false;
        int numberOfMatches;
        locations_sports.forEach((element) {
          if (element["sport"] == sportId) {
            found = true;
            numberOfMatches = element["matches"] + 1;
            element.update("matches", (value) => numberOfMatches);
          }
        });

        if (found == true) {
          _firestore
              .collection('locations')
              .doc(locationId)
              .update({'sports': locations_sports});
        } else {
          Map<String, dynamic> map = {
            'sport': sportId,
            'matches': 1,
          };
          locations_sports.add(map);
          _firestore
              .collection('locations')
              .doc(locationId)
              .update({'sports': locations_sports});
        }

        // List<String> sports = [];
        // sports.add(sportId);
        // _firestore
        //     .collection('locations')
        //     .doc(locationId)
        //     .update({'sports': FieldValue.arrayUnion(sports)});

        _firestore.collection('matches').doc(matchId).set(
              match.toJson(),
            );

        result = "success";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
