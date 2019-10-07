import 'package:fadzmaq/views/matches.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/views/recommendations.dart';
import 'package:flutter/material.dart';

final GlobalKey mainScaffold = GlobalKey();

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 1,
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
                    new Tab(icon: new Icon(Icons.people)),
                    new Tab(icon: new Icon(Icons.public)),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserPreferencesPage(),
              MatchesPage(),
              RecommendationsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
