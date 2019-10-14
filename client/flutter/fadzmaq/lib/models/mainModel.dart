import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:flutter/material.dart';

class MainModel {
  MatchesData matches;
  RecommendationsData recommendations;
  ProfileData userProfile;

  MainModel({
    this.matches,
    this.recommendations,
    this.userProfile,
  });
}

class DataController extends InheritedWidget {
  DataController({
    this.model,
    Widget child,
  }) : super(child: child);

  final MainModel model;

  static MainModel of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DataController) as DataController).model;
  }

  // TODO this should change I think...
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
