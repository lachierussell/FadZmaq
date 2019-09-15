import 'package:fadzmaq/views/matches.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new TabBar(
                  tabs: [
                    new Tab(icon: new Icon(Icons.directions_car)),
                    new Tab(icon: new Icon(Icons.directions_transit)),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserPreferencesPage(),
              MatchesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
