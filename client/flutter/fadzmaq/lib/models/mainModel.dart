import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    return (context.inheritFromWidgetOfExactType(DataController)
            as DataController)
        .model;
  }

  // TODO this should change I think...
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

MainModel getModel(BuildContext context) {
  MainModel model = DataController.of(context);
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

class LoadModel extends StatefulWidget {
  /// The relative url to request
  final WidgetBuilder builder;
  final Model model;

  const LoadModel({
    @required this.model,
    @required this.builder,
  })  : assert(builder != null),
        assert(model != null);

  @override
  _LoadModelState createState() => _LoadModelState();
}

class _LoadModelState extends State<LoadModel> {
  Future _future;

  @override
  void didChangeDependencies() {
    if (_future == null) {
      String server = AppConfig.of(context).server + _getURL(widget.model);
      _future = httpGet(server);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkModel(widget.model)) {
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
            _loadJSON(widget.model, json.decode(snapshot.data.body));
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

  String _getURL(Model model) {
    String url;
    switch (widget.model) {
      case Model.matches:
        url = Globals.matchesURL;
        break;
      case Model.recommendations:
        url = Globals.recsURL;
        break;
      case Model.userProfile:
        url = Globals.profileURL;
        break;
    }

    return url;
  }

  bool _checkModel(Model model) {
    MainModel mainModel = DataController.of(context);
    bool present;
    switch (widget.model) {
      case Model.matches:
        present = mainModel.matches != null;
        break;
      case Model.recommendations:
        present = mainModel.recommendations != null;
        break;
      case Model.userProfile:
        present = mainModel.userProfile != null;
        break;
    }
    return present;
  }

  void _loadJSON(Model model, dynamic json) {
    MainModel mainModel = DataController.of(context);
    switch (widget.model) {
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
    }
  }
}
