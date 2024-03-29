import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/settings.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:flutter/material.dart';

enum Model {
  matches,
  userProfile,
  recommendations,
  allHobbies,
  accountSettings,
}

/// The [GlobalModel] contains instances of all the
/// models the app needs to run
class GlobalModel {
  MatchesData matches;
  RecommendationsData recommendations;
  ProfileData userProfile;
  AllHobbiesData allHobbies;
  AccountSettings accountSettings;

  // these are needed to cache images at
  // the correct resolution
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

/// A continaer is needed to wipe the model
/// from memory on a logout
class GlobalModelContainer {
  GlobalModel model;

  GlobalModelContainer() {
    model = GlobalModel();
  }
}

GlobalModel getModel(BuildContext context) {
  GlobalData data = GlobalData.of(context);

  if (data == null) throw Exception("Data Controller not found");
  if (data.container == null) throw Exception("Model container not found");
  if (data.container.model == null) throw Exception("Model not found");

  return data.container.model;
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

AccountSettings getAccountSettings(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.accountSettings == null)
    throw Exception("Settings model not found");
  return model.accountSettings;
}

ProfileData getUserProfile(BuildContext context) {
  GlobalModel model = getModel(context);
  if (model.userProfile == null)
    throw Exception("User profile model not found");
  return model.userProfile;
}

/// Remove the current [GlobalModel] from [GlobalData]
void cleanModel(BuildContext context) {
  GlobalData data = GlobalData.of(context);
  if (data != null && data.container != null) {
    data.container.model = GlobalModel();
  }
}
