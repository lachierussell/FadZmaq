import 'package:fadzmaq/controllers/globalData.dart';
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


MainModel getModel(BuildContext context) {
  MainModel model = GlobalData.of(context);
  if (model == null) {
    throw Exception("Data Controller not found");
  }
  return model;
}

MatchesData getMatchData(BuildContext context) {
  MainModel model = getModel(context);

  // if(model.matches == null){
  //   String server = AppConfig.of(context).server;
  //   http.Response response;
  //   try{
  //     response = await httpGet(server + Globals.matchesURL);
  //   }catch (e){
  //     //TODO navidate away?
  //     throw Exception(e);
  //   }

  //   if(response != null && response.statusCode == 200){

  //     MatchesData md = MatchesData.fromJson(json.decode(response.body));
  //      model.matches = md;
  //   }
  // }

  return model.matches;
}

enum Model {
  matches,
  userProfile,
  recommendations,
}

