import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PreferencesTempApp extends StatelessWidget {
  const PreferencesTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UserPreferencesPage(),
    );
  }
}

class UserPreferencesPage extends StatelessWidget {
  const UserPreferencesPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: page(),
    );
  }

  Widget page() {
    return Container(
      // color: Colors.grey,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/a/a2/Rowan_Atkinson%2C_2011.jpg',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              Text("Rowan Atkinson"),
              RaisedButton(
                onPressed: () {},
                child: Text("View Profile"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Edit Profile"),
              ),
              Row(
                children: <Widget>[
                  Text("Distance"),
                  Expanded(
                    child: Slider(
                      min: 10,
                      max: 200,
                      value: 50,
                      onChanged: (double d) {},
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Notifications"),
                  Switch(
                    onChanged: (bool b) {},
                    value: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
