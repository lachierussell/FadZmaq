import 'package:fadzmaq/models/models.dart';
import 'dart:core';

// Dart does not support instantiating from a generic type aparemeter
// To allow us to get generic types back from our requests
// We need to maintain a map of types to factory functions
// Add any new class created to handle requests below
T fromJson<T>(Map<String, dynamic> json) {
  if (T == ProfileData) {
    return ProfileData.fromJson(json) as T;
  }
  if (T == MatchesData) {
    return MatchesData.fromJson(json) as T;
  }
  throw UnimplementedError();
}

class ProfileData {
  final String userId;
  final String name;
  final int age;

  ProfileData({this.userId, this.name, this.age});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    var profile = json['profile'];

    return ProfileData(
      userId: profile['user_id'],
      name: profile['name'],
      age: int.parse(profile['age']),
    );
  }
}

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
