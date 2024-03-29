import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'dart:core';
import 'package:fadzmaq/models/settings.dart';

/// Redundant, used with [GetRequest]
//
// Dart does not support instantiating from a generic type aparemeter
// To allow us to get generic types back from our requests
// We need to maintain a map of types to factory functions
// Add any new class created to handle requests below
T fromJson<T>(Map<String, dynamic> json) {
  if (T == ProfileContainer) {
    return ProfileContainer.fromJson(json) as T;
  }
  if (T == UserProfileContainer) {
    return UserProfileContainer.fromJson(json) as T;
  }
  if (T == MatchesData) {
    return MatchesData.fromJson(json) as T;
  }
  if (T == AllHobbiesData) {
    return AllHobbiesData.fromJson(json) as T;
  }
  if (T == RecommendationsData) {
    return RecommendationsData.fromJson(json) as T;
  }
  if (T == AccountSettings) {
    return AccountSettings.fromJson(json) as T;
  }
  throw UnimplementedError("request called on unsuported type, add to 'models.dart'");
}
