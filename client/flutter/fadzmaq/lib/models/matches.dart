import 'package:fadzmaq/models/profile.dart';

class MatchesData {
  List<ProfileContainer> matches;

  MatchesData({this.matches});

  factory MatchesData.fromJson(Map<String, dynamic> json) =>
      _matchesFromJson(json);

  /// Adds a [ProfileContainer] to the match list
  /// used when a new match occurs without having 
  /// to poll the server
  void addToMatchesModel(ProfileContainer pc) {
    matches.insert(0, pc);
  }
}

MatchesData _matchesFromJson(Map<String, dynamic> json) {
  var matchesJson = json['matches'] as List;
  List<ProfileContainer> matches = matchesJson != null
      ? matchesJson.map((i) => ProfileContainer.fromJson(i)).toList()
      : null;

  return MatchesData(
    matches: matches,
  );
}
