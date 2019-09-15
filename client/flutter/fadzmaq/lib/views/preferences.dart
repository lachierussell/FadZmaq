import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/models.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/edithobbiespage.dart';
import 'package:fadzmaq/views/matches.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/editprofilepage.dart';

class PreferencesTempApp extends StatelessWidget {
  const PreferencesTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new UserPreferencesPage(),
    );
  }
}

/// Test widget that lives below a [GetRequest<T>] model of type [ProfileData]
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData profile = RequestProvider.of<ProfileData>(context);

    return Text(profile.name);
  }
}

class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData profile = RequestProvider.of<ProfileData>(context);
    // return Image.network(
    //   profile.photo,
    //   height: 200,
    //   width: 200,
    //   fit: BoxFit.contain,
    // );

    if (profile.photo != null) {
      return FadeInImage.assetNetwork(
        image: profile.photo,
        placeholder: 'assets/images/placeholder-person.jpg',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/placeholder-person.jpg',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    }
  }
}

/// stateful because we have the slider and switches to keep track of
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
    return page();

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Preferences'),
    //   ),
    //   body: page(),
    // );
  }

  Widget page() {
    /// the [GetRequest<ProfileData>] for this page
    /// note [url] is matches and the [builder] creates the below children
    /// this is a [builder] because [children] are initialised independent to heirachy
    /// only [builder] waits for the parent to initialise
    return GetRequest<ProfileData>(
      url: "profile",
      builder: (context) {
        return SingleChildScrollView(
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
                        ProfilePic(),
                        // Text("Rowan Atkinson"),

                        /// here we see [TestWidget], it accesses the
                        /// [RequestProvider<T>] created by [GetRequest<T>]
                        /// to access the model data
                        ///
                        /// this is all test at the moment, I'll adjust it shortly,
                        /// but you can hopefully see how its arranged - Jordan
                        TestWidget(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      child: Text("View Profile"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                      },
                      child: Text("Edit Profile"),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: RaisedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => MatchesPage()),
                  //       );
                  //     },
                  //     child: Text("View Matches"),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditHobbyPage()),
                        );
                      },
                      child: Text("Choose hobbies that you want to discover"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditHobbyPage()),
                        );
                      },
                      child: Text("Choose hobbies that you want to share"),
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
      },
    );
  }

  // temp living here, to be moved to auth(?)
  void logOut() async {
    // TODO log out of google account as well
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
