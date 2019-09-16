class MatchesData {
  List<MatchProfileData> matches;

  MatchesData({this.matches});

  factory MatchesData.fromJson(Map<String, dynamic> json) =>
      _matchesFromJson(json);
}

MatchesData _matchesFromJson(Map<String, dynamic> json) {
  var matchesJson = json['matches'] as List;
  List<MatchProfileData> matches = matchesJson != null
      ? matchesJson.map((i) => MatchProfileData.fromJson(i)).toList()
      : null;

  return MatchesData(
    matches: matches,
  );
}

class MatchProfileData {
  final String id;
  final String name;
  final String photo;

  MatchProfileData({this.id, this.name, this.photo});

  factory MatchProfileData.fromJson(Map<String, dynamic> json) {
    return MatchProfileData(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}
