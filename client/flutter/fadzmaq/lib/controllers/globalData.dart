import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/mainModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class GlobalData extends InheritedWidget {
  GlobalData({
    this.model,
    Widget child,
  }) : super(child: child);

  final MainModel model;

  static MainModel of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GlobalData) as GlobalData)
        .model;
  }

  // TODO this should change I think...
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
    MainModel mainModel = GlobalData.of(context);
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
    MainModel mainModel = GlobalData.of(context);
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
