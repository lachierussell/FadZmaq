import 'package:fadzmaq/controllers/cache.dart';
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

class GlobalData extends InheritedWidget {
  GlobalData({
    this.model,
    Widget child,
  }) : super(child: child);

  final GlobalModel model;

  static GlobalModel of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GlobalData) as GlobalData)
        .model;
  }

  // This widget is created once and does not change, therefore has no
  // concept of notifying widgets below it of a change
  // as widgets are rebuilt they will use whatever changes are present
  // in the model, but live changes must be managed by that widget's
  // own state management
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
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
  Future _future;

  @override
  void didChangeDependencies() {
    if (_future == null) {
      String server =
          AppConfig.of(context).server + _getURL(widget.model);
      _future = httpGet(server);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkModel(context, widget.model)) {
      return widget.builder(context);
    }

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Exception) {
            return Center(child: Text(snapshot.data.toString()));
          }
          if (snapshot.data.statusCode == 200) {
            _loadJSON(context, widget.model, json.decode(snapshot.data.body));
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

Future loadGlobalModels(BuildContext context) async {
  List<Future> futures = List<Future>();

  for (Model model in Model.values) {
    futures.add(httpLoadModel(context, model));
  }

  await Future.wait(futures);
}

/// This is pretty hacky but it lets the future for the request stay
/// umcompleted until the images are also cached.
Future httpLoadModel(BuildContext context, Model model) async {
  String server = AppConfig.of(context).server + _getURL(model);
  http.Response response;
  dynamic responseJson;

  try {
    response = await httpGet(server);
    responseJson = json.decode(response.body);
    _loadJSON(context, model, json.decode(responseJson));
    _cacheModelImages(context, model);
  } catch (e) {
    throw e;
  }
}

String _getURL(Model model) {
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
  GlobalModel mainModel = GlobalData.of(context);
  bool present;
  switch (model) {
    case Model.matches:
      present = mainModel.matches != null;
      break;
    case Model.recommendations:
      present = mainModel.recommendations != null;
      break;
    case Model.userProfile:
      present = mainModel.userProfile != null;
      break;
    case Model.allHobbies:
      present = mainModel.allHobbies != null;
      break;
  }
  return present;
}

void _loadJSON(BuildContext context, Model model, dynamic json) {
  GlobalModel mainModel = GlobalData.of(context);
  switch (model) {
    case Model.matches:
      mainModel.matches = MatchesData.fromJson(json);
      break;
    case Model.recommendations:
      mainModel.recommendations = RecommendationsData.fromJson(json);
      break;
    case Model.userProfile:
      var pc = ProfileContainer.fromJson(json);
      if (pc == null) throw Exception("empty Profile Container");
      mainModel.userProfile = pc.profile;
      break;
    case Model.allHobbies:
      mainModel.allHobbies = AllHobbiesData.fromJson(json);
      break;
  }
}

_cacheModelImages(BuildContext context, Model model) {
  GlobalModel globalModel = GlobalData.of(context);
  switch (model) {
    case Model.matches:
      cacheMatchPhotos(context, globalModel.matches);
      break;
    case Model.recommendations:
      cacheRecommendationPhotos(context, globalModel.recommendations);
      break;
    case Model.userProfile:
      cacheProfilePhotos(context, globalModel.userProfile);
      break;
    case Model.allHobbies:
      break;
  }
}
