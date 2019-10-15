import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:flutter/material.dart';

enum Model {
  matches,
  userProfile,
  recommendations,
  allHobbies,
}

class GlobalModel {
  MatchesData matches;
  RecommendationsData recommendations;
  ProfileData userProfile;
  AllHobbiesData allHobbies;

  double devicePixelRatio;
  double screenWidth;

  GlobalModel({
    this.matches,
    this.recommendations,
    this.userProfile,
    this.allHobbies,
    this.devicePixelRatio,
    this.screenWidth,
  });

  void updateMediaQuery(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.shortestSide;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  }
}

GlobalModel getModel(BuildContext context) {
  GlobalModel model = GlobalData.of(context);
  if (model == null) throw Exception("Data Controller not found");

  return model;
}

MatchesData getMatches(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.matches == null) throw Exception("Matches model not found");
  return model.matches;
}

RecommendationsData getRecommendations(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.recommendations == null)
    throw Exception("Recommendations model not found");
  return model.recommendations;
}

AllHobbiesData getHobbies(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.allHobbies == null) throw Exception("All hobbies model not found");
  return model.allHobbies;
}

ProfileData getUserProfile(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.userProfile == null)
    throw Exception("User profile model not found");
  return model.userProfile;
}