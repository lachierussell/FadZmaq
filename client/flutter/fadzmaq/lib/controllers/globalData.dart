import 'package:fadzmaq/controllers/imageCache.dart';
import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/settings.dart';
import 'package:fadzmaq/views/errorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Used to initialise the global model
Future firstLoadGlobalModels(BuildContext context) async {
  //TODO error checking in here if we have no server etc

  print("first load of models");

  List<Future> futures = List<Future>();

  for (Model model in Model.values) {
    futures.add(loadModel(context, model));
  }
  await Future.wait(futures);
  print("first load complete");
  return;
}

/// Creates a [FutureBuilder] over a page if the [model]
/// is not found
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
  Future _future;

  /// [didChangeDependencies] is called after [init], but is then only called once a dependency changes
  /// we initialise the [Future] [fetchResponse()] here to avoid state changes refiring it
  @override
  void didChangeDependencies() {
    if (_checkModel(context, widget.model) == false) {
      String server = AppConfig.of(context).server + _getURL(widget.model);
      _future = httpGet(server);
    }
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    if (_checkModel(context, widget.model)) {
      return widget.builder(context);
    } else {
      print("no model found for " + widget.model.toString() + " loading");
      return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return ErrorPage();
          }
          if (snapshot.hasError) {
            return ErrorPage();
          } else if (snapshot.hasData == false) {
            // Show a loading spinner while waiting for data
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data is Exception) {
              return ErrorPage();
            }
            if (snapshot.data.statusCode == 200) {
              dynamic responseJson = json.decode(snapshot.data.body);
              _loadJSON(getModel(context), widget.model, responseJson);
              return widget.builder(context);
            } else {
              return ErrorPage();
            }
          }
        },
      );
    }
  }
}

/// The [InheritedWidget] that [GlobalModel] lives in
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

/// Loads a model in the background
loadModelAsync(BuildContext context, Model model) async {
  try {
    await loadModel(context, model);
  } catch (e) {
    print("loadModelAsync Error: " + e.toString());
    errorSnackRevised("Server Error!");
  }
}

/// Loads a [model] into [GlobalModel]
Future loadModel(BuildContext context, Model model) async {
  print("Load model " + model.toString());
  String server = AppConfig.of(context).server + _getURL(model);
  GlobalModel mainModel = getModel(context);
  mainModel.updateMediaQuery(context);

  http.Response response;
  dynamic responseJson;
  dynamic newModel;

  try {
    response = await httpGet(server);

    if (response.statusCode == 200) {
      print("200 and loading in");
      responseJson = json.decode(response.body);
      newModel = await _loadJsonAndCache(mainModel, model, responseJson);
    } else {
      return Exception("Status code was " + response.statusCode.toString());
    }
  } catch (e) {
    return e;
  }
  print("loading complete");
  return newModel;
}

/// returns the URL used for a given [model]
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
    case Model.accountSettings:
      url = Globals.settingsURL;
      break;
  }
  return url;
}

/// checks whether a [model] is present in the [GlobalModel]
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
    case Model.accountSettings:
      present = globalModel.accountSettings != null;
      break;
  }
  // print("checkmodel: " + model.toString() + "-" + present.toString());
  return present;
}

/// converts [json] to a [model] and caches any profile images present
Future _loadJsonAndCache(
    GlobalModel globalModel, Model model, dynamic json) async {
  dynamic newModel = _loadJSON(globalModel, model, json);
  await _cacheModelImages(globalModel, model);
  return newModel;
}

/// Converts given [json] into a [model]
dynamic _loadJSON(GlobalModel globalModel, Model model, dynamic json) {
  switch (model) {
    case Model.matches:
      return globalModel.matches = MatchesData.fromJson(json);
      break;
    case Model.recommendations:
      return globalModel.recommendations = RecommendationsData.fromJson(json);
      break;
    case Model.userProfile:
      var pc = ProfileContainer.fromJson(json);
      if (pc == null) throw Exception("empty Profile Container");
      return globalModel.userProfile = pc.profile;
      break;
    case Model.allHobbies:
      return globalModel.allHobbies = AllHobbiesData.fromJson(json);
      break;
    case Model.accountSettings:
      return globalModel.accountSettings = AccountSettings.fromJson(json);
      break;
  }
}

/// caches any profile images of a given [model]
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
    case Model.accountSettings:
      break;
  }
}
