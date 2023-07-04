import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/dp_match_model.dart';
import 'package:fitxkonnect/models/full_match_model.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/notif_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MatchModel>> getMatchesBasedOnLocation(String locationId) async {
    var ref = await FirebaseFirestore.instance.collection('matches').get();
    List<DocumentSnapshot> documentList = ref.docs;
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      if (snap['location'] == locationId && snap['status'] == 'open') {
        wantedMatches.add(MatchModel.fromSnap(snap));
      }
    });
    return wantedMatches;
  }

  MatchModel getEmptyMatch() {
    return MatchModel(
      matchId: "",
      location: "",
      player1: "",
      player2: "",
      matchDate: "",
      startingTime: "",
      datePublished: DateTime.now(),
      sport: "",
      difficulty: "",
      status: "",
      notificationId: 0,
    );
  }

  Future<List<MatchModel>> getMatchesBasedOnSport(String sportName) async {
    List<MatchModel> wantedMatches = [];
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .where('sport', isEqualTo: sportName)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));
      if (m.status == 'open') {
        wantedMatches.add(m);
      }
    });
    return wantedMatches;
  }

  List<MatchModel> getMatchesBasedOnDifficulty(
      String diff, List<MatchModel> list) {
    List<MatchModel> wantedMatches = [];
    list.forEach((element) {
      if (element.difficulty == diff) {
        wantedMatches.add(element);
      }
    });
    return wantedMatches;
  }

  List<MatchModel> getMatchesBasedOnStartingAndFinal(
      String st, String fi, List<MatchModel> list) {
    var dateFormat = DateFormat('y-MM-dd');
    List<MatchModel> wantedMatches = [];
    if (st != "" && fi != "") {
      DateTime start = DateTime(
        int.parse(st.substring(0, 4)),
        int.parse(st.substring(6, 7)),
        int.parse(st.substring(8, 10)),
      );
      DateTime finalmente = DateTime(
        int.parse(fi.substring(0, 4)),
        int.parse(fi.substring(6, 7)),
        int.parse(fi.substring(8, 10)),
      );
      list.forEach((element) {
        DateTime date = DateTime(
          int.parse(element.matchDate.substring(0, 4)),
          int.parse(element.matchDate.substring(6, 7)),
          int.parse(element.matchDate.substring(8, 10)),
        );
        if (start.isBefore(date) && finalmente.isAfter(date)) {
          wantedMatches.add(element);
        }
      });
    } else if (st != "" && fi == "") {
      {
        DateTime start = DateTime(
          int.parse(st.substring(0, 4)),
          int.parse(st.substring(6, 7)),
          int.parse(st.substring(8, 10)),
        );
        list.forEach((element) {
          DateTime date = DateTime(
            int.parse(element.matchDate.substring(0, 4)),
            int.parse(element.matchDate.substring(6, 7)),
            int.parse(element.matchDate.substring(8, 10)),
          );
          if (start.isBefore(date)) {
            wantedMatches.add(element);
          }
        });
      }
    } else if (st == "" && fi != "") {
      {
        DateTime finalmente = DateTime(
          int.parse(fi.substring(0, 4)),
          int.parse(fi.substring(6, 7)),
          int.parse(fi.substring(8, 10)),
        );
        list.forEach((element) {
          DateTime date = DateTime(
            int.parse(element.matchDate.substring(0, 4)),
            int.parse(element.matchDate.substring(6, 7)),
            int.parse(element.matchDate.substring(8, 10)),
          );
          if (finalmente.isAfter(date)) {
            wantedMatches.add(element);
          }
        });
      }
    }
    return wantedMatches;
  }

  List<MatchModel> getMatchesBasedOnDay(String diff, List<MatchModel> list) {
    List<MatchModel> wantedMatches = [];
    int startingHour = 99;
    int finishHour = 99;
    int hour = 0;
    switch (diff) {
      case 'Morning':
        startingHour = 10;
        finishHour = 13;
        break;
      case 'Afternoon':
        startingHour = 14;
        finishHour = 19;
        break;
      case 'Night':
        startingHour = 20;
        finishHour = 24;
        break;
    }

    list.forEach((element) {
      hour = int.parse(element.startingTime.substring(0, 2));
      if (hour <= finishHour && hour >= startingHour) {
        wantedMatches.add(element);
      }
    });
    return wantedMatches;
  }

  Future<List<MatchModel>> getAllHomePageMatches() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('datePublished', descending: true)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;

    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));

      if (m.status == 'open') {
        wantedMatches.add(m);
      }
    });

    return wantedMatches;
  }

  Future<List<MatchModel>> getAllFullMatches() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('datePublished', descending: true)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;

    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));

      if (m.status == 'played') {
        wantedMatches.add(m);
      }
    });

    return wantedMatches;
  }

  Future<List<HomePageMatch>> getActualHomePageMatches(
      String sportFilter,
      String diffFilter,
      String dayFilter,
      String startingTime,
      String finalTime) async {
    List<MatchModel> filteredOnce = [];
    if (sportFilter == "all") {
      filteredOnce = await MatchServices().getAllHomePageMatches();
    } else {
      filteredOnce = await MatchServices().getMatchesBasedOnSport(sportFilter);
    }
    List<MatchModel> filteredTwice = [];
    if (diffFilter == "all") {
      filteredTwice = filteredOnce;
    } else {
      filteredTwice =
          MatchServices().getMatchesBasedOnDifficulty(diffFilter, filteredOnce);
    }
    List<MatchModel> filteredThird = [];
    if (dayFilter == "all") {
      filteredThird = filteredTwice;
    } else {
      filteredThird =
          MatchServices().getMatchesBasedOnDay(dayFilter, filteredTwice);
    }
    List<MatchModel> filtered4 = [];
    if (startingTime == "" && finalTime == "") {
      filtered4 = filteredThird;
    } else {
      if (startingTime == "") {
        startingTime = DateFormat('y-MM-dd').format(DateTime.now());

        filtered4 = MatchServices().getMatchesBasedOnStartingAndFinal(
            startingTime, finalTime, filteredThird);
      } else {
        filtered4 = MatchServices().getMatchesBasedOnStartingAndFinal(
            startingTime, finalTime, filteredThird);
      }
    }
    List<HomePageMatch> neededMatches = [];

    for (var match in filtered4) {
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(HomePageMatch(
          p1uid: user.uid,
          p1Name: user.fullName,
          p1Age: user.age,
          p1Country: user.country.substring(2),
          p1Profile: user.profilePhoto,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.matchDate,
          startingTime: match.startingTime,
          locationName: location.name,
          matchId: match.matchId));
    }
    return neededMatches;
  }

  Future<List<MatchModel>> getFullMatches() async {
    List<MatchModel> matches = await MatchServices().getListOfMatches();
    List<MatchModel> fullMatches = [];
    for (var m in matches) {
      if (m.player2 != "") {
        fullMatches.add(m);
      }
    }
    return fullMatches;
  }

  Future<List<FullMatch>> getActualFullMatches() async {
    List<MatchModel> fullMatches = await getFullMatches();

    List<FullMatch> neededMatches = [];
    for (var match in fullMatches) {
      UserModel user1 = await UserServices().getSpecificUser(match.player1);
      UserModel user2 = await UserServices().getSpecificUser(match.player2);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(FullMatch(
        p1uid: user1.uid,
        p1Name: user1.fullName,
        p1Age: user1.age,
        p1Country: user1.country,
        p1Profile: user1.profilePhoto,
        p2uid: user2.uid,
        p2Name: user2.fullName,
        p2Age: user2.age,
        p2Country: user2.country,
        p2Profile: user2.profilePhoto,
        sport: match.sport,
        difficulty: match.difficulty,
        matchDate: match.matchDate,
        startingTime: match.startingTime,
        locationName: location.name,
        matchId: match.matchId,
        status: match.status,
        locationAddress: location.contact[0],
      ));
    }
    return neededMatches;
  }

  Future<List<DetailsPageMatch>> getActualDetailsPageMatches(
      String locationId) async {
    List<MatchModel> allMatches =
        await MatchServices().getMatchesBasedOnLocation(locationId);
    List<DetailsPageMatch> neededMatches = [];

    for (var match in allMatches) {
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(DetailsPageMatch(
          p1uid: user.uid,
          p1Name: user.fullName,
          p1Age: user.age,
          p1Profile: user.profilePhoto,
          p1Country: user.country,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.matchDate,
          startingTime: match.startingTime,
          matchId: match.matchId));
    }
    return neededMatches;
  }

  Stream<List<DetailsPageMatch>> getStreamActualDetailsPageMatches(
      String locationId) async* {
    List<MatchModel> allMatches =
        await MatchServices().getMatchesBasedOnLocation(locationId);
    List<DetailsPageMatch> neededMatches = [];

    for (var match in allMatches) {
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(DetailsPageMatch(
          p1uid: user.uid,
          p1Name: user.fullName,
          p1Age: user.age,
          p1Profile: user.profilePhoto,
          p1Country: user.country,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.matchDate,
          startingTime: match.startingTime,
          matchId: match.matchId));
    }
    yield neededMatches;
  }

  Future<List<MatchModel>> getListOfMatches() async {
    var ref = await FirebaseFirestore.instance.collection('matches').get();
    List<DocumentSnapshot> documentList = ref.docs;
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      wantedMatches.add(MatchModel.fromSnap(snap));
    });
    return wantedMatches;
  }

  Future<List<FullMatch>> getUserEndedMatches(String userId) async {
    List<FullMatch> generalMatches =
        await MatchServices().getActualFullMatches();
    List<FullMatch> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'played' || element.status == 'abandoned') &&
          (element.p1uid == userId || element.p2uid == userId)) {
        endedMatches.add(element);
      }
    });
    return endedMatches;
  }

  Future<List<HomePageMatch>> getUserOpenMatches(String userId) async {
    List<HomePageMatch> generalMatches = await MatchServices()
        .getActualHomePageMatches("all", "all", "all", "", "");

    List<HomePageMatch> matchesToCome = [];
    generalMatches.forEach((element) async {
      if (element.p1uid == userId) {
        matchesToCome.add(element);
      }
    });

    return matchesToCome;
  }

  Future<List<FullMatch>> getUsersMatched(String userId) async {
    List<FullMatch> generalMatches =
        await MatchServices().getActualFullMatches();

    List<FullMatch> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'matched') &&
          (element.p1uid == userId || element.p2uid == userId)) {
        endedMatches.add(element);
      }
    });

    return endedMatches;
  }

  Future<int> getNumberOfMatchesOpenBasedOnLocation(String location) async {
    int myRes;
    var result = await _firestore
        .collection('matches')
        .where('location', isEqualTo: location)
        .where('status', isEqualTo: 'open')
        .get();

    myRes = result.docs.length;
    return myRes;
  }

  Future<void> abandonMatch(String matchId, String whoPressed) async {
    MatchModel match = await MatchServices().getCertainMatch(matchId);
    UserModel u2 = await UserServices().getSpecificUser(match.player2);
    MatchModel m = await MatchServices().getCertainMatch(matchId);
    UserModel u = await UserServices().getSpecificUser(m.player1);
    LocationModel location =
        await LocationServices().getCertainLocation(match.location);

    if (u.uid == whoPressed) {
      UserServices().sendPushMessage(
          "Match of ${m.sport} from ${m.matchDate} is now abandoned!",
          'You abandoned a match!',
          u.token!,
          match.player1,
          2,
          m.notificationId,
          m.matchId);

      UserServices().sendPushMessage(
          'Opponent: ${u.fullName} abandoned the match of ${m.sport} from ${m.matchDate}.',
          'A match has been abandoned!',
          u2.token!,
          match.player1,
          2,
          m.notificationId,
          matchId);
    } else {
      UserServices().sendPushMessage(
          "Match of ${m.sport} from ${m.matchDate} is now abandoned!",
          'You abandoned a match!',
          u2.token!,
          match.player1,
          2,
          m.notificationId,
          matchId);

      UserServices().sendPushMessage(
          'Opponent: ${u.fullName} abandoned the match of ${m.sport} from ${m.matchDate}.',
          'A match has been abandoned!',
          u.token!,
          match.player1,
          2,
          m.notificationId,
          matchId);
    }

    await FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId) // <-- Doc ID where data should be updated.
        .update({
      'status': 'abandoned',
    });
  }

  Future<void> matchPlayers(String matchId, String player2Id) async {
    var collection = FirebaseFirestore.instance.collection('matches');
    UserModel u2 = await UserServices().getSpecificUser(player2Id);
    MatchModel m = await MatchServices().getCertainMatch(matchId);
    UserModel u = await UserServices().getSpecificUser(m.player1);
    LocationModel location =
        await LocationServices().getCertainLocation(m.location);

    MatchModel match = await MatchServices().getCertainMatch(matchId);
    List locations_sports = location.sports;
    SportModel matchSport =
        await SportServices().getSpecificSportFromName(match.sport);
    int numberOfMatches;
    locations_sports.forEach((element) {
      if (element["sport"] == matchSport.sportId) {
        numberOfMatches = element["matches"];
        if (numberOfMatches > 0) {
          numberOfMatches = element["matches"] - 1;
        }
        element.update("matches", (value) => numberOfMatches);
      }
    });
    await _firestore
        .collection('locations')
        .doc(match.location)
        .update({'sports': locations_sports});

    // notification sent to the opponent
    UserServices().sendPushMessage(
        'Opponent: ${u2.fullName} in a match of ${m.sport}.\nLocation: ${location.name}\nDate: ${m.matchDate}\nStarting at: ${m.startingTime}',
        'Get ready! You have a new match!',
        u.token!,
        player2Id,
        1,
        m.notificationId,
        matchId);

    collection.doc(matchId) // <-- Doc ID where data should be updated.
        .update({
      'player2': player2Id,
      'status': 'matched',
    });
    //creating local notification for myself that I matched him

    UserServices().sendPushMessage(
        "Get ready for a match of ${m.sport}.\nLocation: ${location.name}\nDate: ${m.matchDate}\nStarting at: ${m.startingTime}",
        'You matched with ${u.fullName}',
        u2.token!,
        player2Id,
        1,
        m.notificationId,
        matchId);
  }

  Future<MatchModel> getCertainMatch(String matchId) async {
    MatchModel location = MatchModel.fromSnap(
        await _firestore.collection('matches').doc(matchId).get());

    return location;
  }

  Future<void> cancelMatch(String matchId) async {
    try {
      MatchModel match = await MatchServices().getCertainMatch(matchId);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);

      List locations_sports = location.sports;

      SportModel matchSport =
          await SportServices().getSpecificSportFromName(match.sport);
      int numberOfMatches;
      locations_sports.forEach((element) {
        if (element["sport"] == matchSport.sportId) {
          numberOfMatches = element["matches"];
          if (numberOfMatches > 0) {
            numberOfMatches = element["matches"] - 1;
          }
          element.update("matches", (value) => numberOfMatches);
        }
      });

      await _firestore
          .collection('locations')
          .doc(match.location)
          .update({'sports': locations_sports});
      await _firestore.collection('matches').doc(matchId).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  bool checkUsersMatchConditions(
      String matchSport, String matchDif, List<dynamic> sp_cf) {
    List<dynamic> sports_configured = sp_cf;

    bool conditionsPassed = false;

    for (var map in sports_configured) {
      if (map["sport"] == matchSport && map["difficulty"] == matchDif) {
        conditionsPassed = true;
      }
    }
    return conditionsPassed;
  }

  Future<void> handleMatched() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('datePublished', descending: true)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;
    var collection = FirebaseFirestore.instance.collection('matches');
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));
      DateTime date = DateTime(
        int.parse(m.matchDate.substring(0, 4)),
        int.parse(m.matchDate.substring(6, 7)),
        int.parse(m.matchDate.substring(8, 10)),
        int.parse(m.startingTime.substring(0, 2)),
        int.parse(m.startingTime.substring(3, 5)),
      );
      if (m.status == 'matched' && DateTime.now().isAfter(date)) {
        collection.doc(m.matchId) // <-- Doc ID where data should be updated.
            .update({
          'status': 'played',
        });
      }
    });
  }
}
