import 'package:fadzmaq/controllers/profile_request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/controllers/request.dart';

class PreferencesTempApp extends StatelessWidget {
  const PreferencesTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new UserPreferencesPage(),
    );
  }
}

class UserPreferencesPage extends StatefulWidget {
  UserPreferencesState createState() {
    return UserPreferencesState();
  }
}

class UserPreferencesState extends State {
  // const UserPreferencesPage([Key key]) : super(key: key);

  double _locationDistance = 50;
  int _roundDist = 50;
  bool _notificationsBool = true;

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/a/a2/Rowan_Atkinson%2C_2011.jpg',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    Text("Rowan Atkinson"),
                    // GetProfileData(builder: (context) {
                    //   return Row(
                    //     children: <Widget>[
                    //       Text("test"),
                    //       Text(InheritedProfile.of(context).test),
                    //     ],
                    //   );
                    // }),
                    RequestProfile(builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: <Widget>[
                            Text("test"),
                            Text(InheritedProfile.of(context).test),
                          ],
                        );
                      } else {
                        return Text("null");
                      }
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text("View Profile"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text("Edit Profile"),
                ),
              ),
              Column(
                children: <Widget>[
                  Text("Distance: $_roundDist"),
                  Row(
                    children: <Widget>[
                      Text("Distance"),
                      Expanded(
                        child: Slider(
                          min: 10,
                          max: 200,
                          // value: 50,
                          onChanged: (newDist) {
                            setState(() {
                              int rounded = (newDist / 5).round() * 5;
                              _locationDistance = newDist;
                              _roundDist = rounded;
                            });
                          },
                          // onChangeEnd: (newDist){
                          //   setState(() {
                          //     int rounded = (newDist / 5).round() * 5;
                          //     _locationDistance = rounded as double;
                          //     _roundDist = rounded;
                          //   });
                          // },
                          value: _locationDistance,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Notifications"),
                  Switch(
                    onChanged: (b) {
                      setState(() => _notificationsBool = b);
                    },
                    value: _notificationsBool,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: logOut,
                  child: Text("Log out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
