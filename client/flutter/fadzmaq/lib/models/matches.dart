import 'package:fadzmaq/models/hobbies.dart';

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
  final List<HobbyContainer> hobbyContainers;

  MatchProfileData({
    this.id,
    this.name,
    this.photo,
    this.hobbyContainers,
  });

  factory MatchProfileData.fromJson(Map<String, dynamic> json) {
    var hobbyContainersJson = json['hobbies'] as List;
    List<HobbyContainer> hobbyContainers = hobbyContainersJson != null
        ? hobbyContainersJson.map((i) => HobbyContainer.fromJson(i)).toList()
        : null;

    return MatchProfileData(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      hobbyContainers: hobbyContainers,
    );
  }
}
