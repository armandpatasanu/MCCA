class FullMatch {
  final String p1uid;
  final String p1Name;
  final String p1Country;
  final String p1Age;
  final String p1Profile;
  final String p2uid;
  final String p2Country;
  final String p2Age;
  final String p2Name;
  final String p2Profile;
  final String sport;
  final String difficulty;
  final String matchDate;
  final String matchId;
  final String startingTime;
  final String locationName;
  final String locationAddress;
  final String status;

  const FullMatch({
    required this.p1uid,
    required this.p1Name,
    required this.p1Age,
    required this.p1Country,
    required this.p1Profile,
    required this.p2uid,
    required this.p2Name,
    required this.p2Age,
    required this.p2Country,
    required this.p2Profile,
    required this.sport,
    required this.difficulty,
    required this.matchDate,
    required this.matchId,
    required this.startingTime,
    required this.locationName,
    required this.locationAddress,
    required this.status,
  });
}
