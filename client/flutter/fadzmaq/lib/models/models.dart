import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/hobbies.dart';
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
  if (T == AllHobbiesData) {
    return AllHobbiesData.fromJson(json) as T;
  }
  throw UnimplementedError();
}
