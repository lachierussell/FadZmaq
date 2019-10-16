import 'package:fadzmaq/controllers/account.dart';
import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/settings.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/widgets/deleteUser.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/editprofilepage.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';

class UserPreferencesPage extends StatelessWidget {
  /// the [VerifyModel] for this page
  /// this is a [builder] because [children] are initialised independent to heirachy
  /// only [builder] waits for the parent to initialise
  @override
  Widget build(BuildContext context) {
    return VerifyModel(
        model: Model.userProfile,
        builder: (context) {
          return VerifyModel(
              model: Model.accountSettings,
              builder: (context) {
                return UserPreferences();
              });
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

  double _locationDistance = 20;
  int _roundDist = 20;
  // bool _notificationsBool = true;

  @override
  void didChangeDependencies() {
    AccountSettings settings = getAccountSettings(context);

    _locationDistance = settings.distanceSetting.toDouble();
    _roundDist = settings.distanceSetting;

    if (settings != null) {
      print(settings.distanceSetting.toString());
    } else {
      print("settings null");
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ProfileData userProfile = getUserProfile(context);

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
                SizedBox(height: 20),
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
                SizedBox(height: 50,),
                Column(
                  children: <Widget>[
                    Text("Search Radius: " + _roundDist.toString() + "km"),
                    Row(
                      children: <Widget>[
                        // Text("Distance"),
                        Expanded(
                          child: Slider(
                            min: 1,
                            max: 50,
                            // value: 50,
                            onChanged: (newDist) {
                              setState(() {
                                _locationDistance = newDist;
                                int rounded = (newDist).round();
                                _roundDist = rounded;
                              });
                            },
                            onChangeEnd: (endDist) {
                              int rounded = (endDist).round();
                              _locationDistance = endDist;
                              _roundDist = rounded;

                              var accountSettings = getAccountSettings(context);
                              accountSettings.distanceSetting = _roundDist;

                              postAsync(context, Globals.settingsURL,
                                      json:
                                          json.encode(accountSettings.toJson()))
                                  .then((value) {
                                loadModel(mainScaffold.currentContext, Model.recommendations);
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
                // Row(
                //   children: <Widget>[
                //     Text("Notifications"),
                //     Switch(
                //       onChanged: (b) {
                //         setState(() => _notificationsBool = b);
                //       },
                //       value: _notificationsBool,
                //     ),
                //   ],
                // ),
                SizedBox(height: 120,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      logOut(context);
                    },
                    child: Text("Log out"),
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
    ProfileData userProfile = getUserProfile(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(userProfile.name),
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
      ],
    );
  }
}
