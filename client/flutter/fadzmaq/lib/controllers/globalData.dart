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

/// Used to initialise the global model
Future firstLoadGlobalModels(BuildContext context) async {
  //TODO error checking in here if we have no server etc

  print("first load of models");

  List<Future> futures = List<Future>();

  for (Model model in Model.values) {
    futures.add(loadModel(context, model));
  }
  await Future.wait(futures);
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
    if (_checkModel(context, widget.model) == false || _future == null) {
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
          if (snapshot.hasData) {
            if (snapshot.data is Exception) {
              return Center(child: Text(snapshot.data.toString()));
            }
            if (snapshot.data.statusCode == 200) {
              print("Ready to go: " + snapshot.data.toString());
              dynamic responseJson = json.decode(snapshot.data.body);
              _loadJSON(getModel(context), widget.model, responseJson);
              return widget.builder(context);
            } else if (snapshot.data.statusCode == 401) {
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
    // do nothing on error
    // TODO maybe show a popup bar?
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

  return response;
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
  }
  print("checkmodel: " + model.toString() + "-" + present.toString());
  return present;
}

/// converts [json] to a [model] and caches any profile images present
Future _loadJsonAndCache(
    GlobalModel globalModel, Model model, dynamic json) async {
  _loadJSON(globalModel, model, json);
  await _cacheModelImages(globalModel, model);
}

/// Converts given [json] into a [model]
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
  }
}
