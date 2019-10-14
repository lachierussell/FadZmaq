import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/mainModel.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/edithobbiespage.dart';
import 'package:fadzmaq/views/widgets/deleteUser.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/editprofilepage.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as prefix1;

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
    ProfileData userProfile = DataController.of(context).userProfile;

    return Text(userProfile.name);
  }
}

class UserPreferencesPage extends StatelessWidget {
  /// the [GetRequest<ProfileData>] for this page
  /// note [url] is matches and the [builder] creates the below children
  /// this is a [builder] because [children] are initialised independent to heirachy
  /// only [builder] waits for the parent to initialise
  @override
  Widget build(BuildContext context) {
    return LoadModel(
        model: Model.userProfile,
        builder: (context) {
          return UserPreferences();
        });
  }
}

/// stateful because we have the slider and switches to keep track of
class UserPreferences extends StatefulWidget {
  UserPreferencesState createState() {
    return UserPreferencesState();
  }
}

class UserPreferencesState extends State<UserPreferences> {
  // const UserPreferencesPage([Key key]) : super(key: key);

  double _locationDistance = 50;
  int _roundDist = 50;
  bool _notificationsBool = true;

  @override
  Widget build(BuildContext context) {
    ProfileData userProfile = DataController.of(context).userProfile;

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
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: DisplayPhoto(
                    url: userProfile.photo,
                    dimension: Globals.recThumbDim,
                  ),
                ),
                new PreferenceButtons(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      editProfileFunction(context);
                    },
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      postAsync(context, "profile");
                    },
                    child: Text("Post Request Test"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 20.0,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      deleteDialog(context);
                    },
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  // TODO temp living here, to be moved to auth(?)
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void editProfileFunction(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProfilePage();
    }));
  }
}

class PreferenceButtons extends StatelessWidget {
  const PreferenceButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ProfileData profile = RequestProvider.of<ProfileContainer>(context).profile;
    ProfileData userProfile = DataController.of(context).userProfile;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
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
                    builder: (context) => ProfilePage(
                          url: Globals.profileURL,
                          profile: userProfile,
                          type: ProfileType.own,
                        )),
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
                    builder: (context) => EditHobbyPage2(isShare: false)),
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
                    builder: (context) => EditHobbyPage2(isShare: true)),
              );
            },
            child: Text("Choose hobbies that you want to share"),
          ),
        ),
      ],
    );
  }
}
