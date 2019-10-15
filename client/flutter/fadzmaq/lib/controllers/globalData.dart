import 'package:fadzmaq/controllers/imageCache.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future firstLoadGlobalModels(BuildContext context) async {
  //TODO error checking in here if we have no server etc

  print("first load of models");

  List<Future> futures = List<Future>();

  for (Model model in Model.values) {
    futures.add(loadModel(context, model));
  }
  await Future.wait(futures);
}

class VerifyModel extends StatefulWidget {
  /// The relative url to request
  final WidgetBuilder builder;
  final Model model;

  const VerifyModel({
    @required this.model,
    @required this.builder,
  })  : assert(builder != null),
        assert(model != null);

  @override
  _VerifyModelState createState() => _VerifyModelState();
}

class _VerifyModelState extends State<VerifyModel> {
  @override
  Widget build(BuildContext context) {
    if (_checkModel(context, widget.model)) {
      return widget.builder(context);
    } else {
      print("no model found for " + widget.model.toString() + " loading");
      return FutureBuilder(
        future: loadModel(context, widget.model),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is Exception) {
              return Center(child: Text(snapshot.data.toString()));
            }
            if (snapshot.data == 200) {
              return widget.builder(context);
            } else if (snapshot.data == 401) {
              // not sure if this is the best way to do this but it works for now - Jordan
              // TODO return an error here and manage it further up
              return LoginScreen();
            } else {
              // TODO make this handle better
              return Text("Error with HTTP request: " +
                  '${snapshot.data.statusCode.toString()} ' +
                  ' ${snapshot.data.body.toString()}');
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          // We can pipe something else in here later if we wish,
          // or make our own default
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}

class GlobalData extends InheritedWidget {
  GlobalData({
    this.container,
    Widget child,
  }) : super(child: child);

  final GlobalModelContainer container;

  static GlobalData of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GlobalData) as GlobalData);
  }

  // This widget is created once and does not change, therefore has no
  // concept of notifying widgets below it of a change
  // as widgets are rebuilt they will use whatever changes are present
  // in the model, but live changes must be managed by that widget's
  // own state management
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// This is pretty hacky but it lets the future for the request stay
/// umcompleted until the images are also cached.
Future<int> loadModel(BuildContext context, Model model) async {
  print("Load model " + model.toString());
  String server = AppConfig.of(context).server + _getURL(model);
  GlobalModel mainModel = getModel(context);
  mainModel.updateMediaQuery(context);

  http.Response response;
  dynamic responseJson;

  try {
    response = await httpGet(server);
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      await _loadJsonAndCache(mainModel, model, responseJson);
    } else {
      throw Exception("Status code was " + response.statusCode.toString());
    }
  } catch (e) {
    throw e;
  }

  return response.statusCode;
}

String _getURL(Model model) {
  // print("get url for " + model.toString());
  String url;
  switch (model) {
    case Model.matches:
      url = Globals.matchesURL;
      break;
    case Model.recommendations:
      url = Globals.recsURL;
      break;
    case Model.userProfile:
      url = Globals.profileURL;
      break;
    case Model.allHobbies:
      url = Globals.allHobbiesURL;
      break;
  }
  return url;
}

bool _checkModel(BuildContext context, Model model) {
  GlobalModel globalModel = getModel(context);
  bool present;
  switch (model) {
    case Model.matches:
      present = globalModel.matches != null;
      break;
    case Model.recommendations:
      present = globalModel.recommendations != null;
      break;
    case Model.userProfile:
      present = globalModel.userProfile != null;
      break;
    case Model.allHobbies:
      present = globalModel.allHobbies != null;
      break;
  }
  return present;
}

void _loadJSON(GlobalModel globalModel, Model model, dynamic json) {
  switch (model) {
    case Model.matches:
      globalModel.matches = MatchesData.fromJson(json);
      break;
    case Model.recommendations:
      globalModel.recommendations = RecommendationsData.fromJson(json);
      break;
    case Model.userProfile:
      var pc = ProfileContainer.fromJson(json);
      if (pc == null) throw Exception("empty Profile Container");
      globalModel.userProfile = pc.profile;
      break;
    case Model.allHobbies:
      globalModel.allHobbies = AllHobbiesData.fromJson(json);
      break;
  }
}

Future _loadJsonAndCache(
    GlobalModel globalModel, Model model, dynamic json) async {
  _loadJSON(globalModel, model, json);
  await _cacheModelImages(globalModel, model);
}

Future _cacheModelImages(GlobalModel globalModel, Model model) async {
  switch (model) {
    case Model.matches:
      await cacheMatchPhotos(globalModel, globalModel.matches);
      break;
    case Model.recommendations:
      await cacheRecommendationPhotos(globalModel, globalModel.recommendations);
      break;
    case Model.userProfile:
      await cacheProfilePhotos(globalModel, globalModel.userProfile);
      break;
    case Model.allHobbies:
      break;
  }
}
