import 'package:fadzmaq/views/matches.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/views/recommendations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

final GlobalKey mainScaffold = GlobalKey();

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

/// The main navigation tabbed page of the app
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var notification = message['notification'];
        String title = notification['title'];
        _matchSnack(title);
        // _showItemDialog(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }


  void _matchSnack(String s) {
    Flushbar flush;
    flush = Flushbar(
      message: s,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      leftBarIndicatorColor: Colors.blue[300],
      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          "Okay",
          style: TextStyle(color: Colors.blue[300]),
        ),
      ), // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 2,
        length: 3,
        child: Scaffold(
          key: mainScaffold,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new TabBar(
                  tabs: [
                    new Tab(icon: new Icon(Icons.settings)),
                    new Tab(icon: new Icon(Icons.public)),
                    new Tab(icon: new Icon(Icons.people)),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserPreferencesPage(),
              RecommendationsPage(),
              MatchesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
