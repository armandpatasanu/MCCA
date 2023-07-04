import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/utils.dart';

class SportServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SportModel> getSpecificSportFromId(String sportId) async {
    var result = await _firestore.collection('sports').doc(sportId).get();

    SportModel searchedSport = SportModel.fromSnap(result);
    return searchedSport;
  }

  Future<SportModel> getSpecificSportFromName(String sportName) async {
    List<SportModel> sports = await getListOfSports();
    String searchedSportId = "";

    sports.forEach((element) {
      if (element.name == sportName) {
        searchedSportId = element.sportId;
      }
    });
    var result =
        await _firestore.collection('sports').doc(searchedSportId).get();

    SportModel searchedSport = SportModel.fromSnap(result);
    return searchedSport;
  }

  Future<List<dynamic>> getUsersSportsPlayed(String userId) async {
    UserModel user = await UserServices().getSpecificUser(userId);
    List users_sports = user.sports_configured;
    for (var map in users_sports) {}
    return users_sports;
  }

  Future<List<SportModel>> getListOfSports() async {
    var ref = await FirebaseFirestore.instance
        .collection('sports')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> sportsList = ref.docs;
    List<SportModel> sports = [];

    sportsList.forEach((DocumentSnapshot snap) {
      sports.add(SportModel.fromSnap(snap));
    });

    return sports;
  }

  Future<List<Map<String, bool>>> getButtonsSports() async {
    List<SportModel> sports = await getListOfSports();
    List<Map<String, bool>> myList = [];

    sports.forEach((SportModel snap) {
      Map<String, bool> map = {
        '${snap.name}': false,
      };
      myList.add(map);
    });

    return myList;
  }

  Future<String> getSportNameBasedOfId(String sportId) async {
    SportModel sport = SportModel.fromSnap(
        await _firestore.collection('sports').doc(sportId).get());
    return sport.name;
  }

  Future<String> getSportIdBasedOfName(String name) async {
    var ref = await FirebaseFirestore.instance.collection('sports').get();
    List<DocumentSnapshot> documentList = ref.docs;
    String wantedId = "";

    for (var snap in documentList) {
      if (snap['name'] == name) {
        wantedId =
            (await SportServices().getSpecificSportFromName(snap['name']))
                .sportId;
      }
    }
    ;
    return wantedId;
  }

  Future<List<String>> getNotConfiguredSports(uid) async {
    List<dynamic> playedSports = await getUsersSportsPlayed(uid);
    List<String> playedSports_strings = [];
    List<SportModel> allSports = await getListOfSports();
    List<String> allSports_strings = [];
    List<String> wantedSports = [];

    for (var map in playedSports) {
      playedSports_strings.add(map['sport']);
    }

    for (var sport in allSports) {
      allSports_strings.add(sport.name);
    }

    for (var name in allSports_strings) {
      if (!playedSports_strings.contains(name)) {
        wantedSports.add(name);
      }
    }
    return wantedSports;
  }

  Future<List<String>> getListOfSportsId() async {
    List<SportModel> sports = await getListOfSports();
    List<String> wantedList = [];
    sports.forEach((element) {
      wantedList.add(element.sportId);
    });

    return wantedList;
  }

  Future<List<String>> getListOfSportsName() async {
    List<SportModel> sports = await getListOfSports();
    List<String> wantedList = [];
    sports.forEach((element) {
      wantedList.add(element.name);
    });

    return wantedList;
  }

  Future<String> addSport(String uid, String dif, String sport) async {
    UserModel user = await UserServices().getSpecificUser(uid);
    List<dynamic> users_sports = user.sports_configured;
    String result = "success";

    if (sport == "Choose a sport") {
      result = 'Please select a sport';
    } else if (dif == "all") {
      result = 'Please select a difficulty';
    } else {
      Map<String, String> map = {
        'difficulty': dif,
        'sport': sport,
      };

      users_sports.add(map);
      users_sports.sort((a, b) =>
          a['sport'].toLowerCase().compareTo(b['sport'].toLowerCase()));

      _firestore
          .collection('users')
          .doc(uid)
          .update({'sports_configured': users_sports});

      _firestore.collection('users').doc(uid).update({
        'sports_not_configured': FieldValue.arrayRemove([sport])
      });
    }

    return result;
  }

  Future<void> deleteSport(String uid, String sport) async {
    UserModel user = await UserServices().getSpecificUser(uid);
    List<String> users_sports = await getNotConfiguredSports(uid);
    List<dynamic> sports_to_be_upd = await getUsersSportsPlayed(uid);
    List<dynamic> to_be_added = [];
    // String sportId =
    //     (await SportServices().getSpecificSportFromName(sport)).sportId;
    for (var map in sports_to_be_upd) {
      if (map['sport'] != sport) {
        to_be_added.add(map);
      }
    }
    sports_to_be_upd.sort(
        (a, b) => a['sport'].toLowerCase().compareTo(b['sport'].toLowerCase()));

    users_sports.add(sport);
    users_sports.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _firestore
        .collection('users')
        .doc(uid)
        .update({'sports_not_configured': users_sports});

    _firestore
        .collection('users')
        .doc(uid)
        .update({'sports_configured': to_be_added});
  }

  Future<void> saveSportsConfiguration(
      String uid, List<int> difficulties) async {
    UserModel user = await UserServices().getSpecificUser(uid);
    List<dynamic> sports_configured = await getUsersSportsPlayed(uid);
    int i = 0;

    for (var map in sports_configured) {
      map["difficulty"] = getDifFromValue(difficulties[i]);
      i++;
    }
    _firestore
        .collection('users')
        .doc(uid)
        .update({'sports_configured': sports_configured});
  }
}
