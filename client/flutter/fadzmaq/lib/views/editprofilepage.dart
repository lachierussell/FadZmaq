import 'dart:convert';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/models/app_config.dart';

class ProfileTempApp extends StatelessWidget {
  const ProfileTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: GetRequest<ProfileData>(
        url: "profile",
        builder: (context) {
          return new EditProfile();
        },
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new EditProfileState();
}

String bioFromPD(ProfileData pd) {
  if (pd != null && pd.profileFields != null) {
    for (ProfileField pf in pd.profileFields) {
      if (pf.id == 1) {
        if (pf.displayValue != null) {
          return pf.displayValue;
        } else {
          return "";
        }
      }
    }
  }
  return "";
}

class EditProfileState extends State<EditProfile> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileData>(context);
    String server = AppConfig.of(context).server;

    // check for id 1 (about me) and grab the display value
    String bio = bioFromPD(pd);

    final String contact_phone =
        pd.contactDetails.phone != null ? pd.contactDetails.phone : "";
    String contact_email =
        pd.contactDetails.email != null ? pd.contactDetails.email : "";

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                autovalidate: true,
                initialValue: {
                  'movie_rating': 5,
                },
                // readOnly: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                        attribute: "nickname",
                        initialValue: pd.name,
                        decoration: InputDecoration(labelText: "Nickname")),
                    FormBuilderTextField(
                        attribute: "email",
                        initialValue: contact_email,
                        decoration: InputDecoration(labelText: "email")),
                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: contact_phone,
                        decoration: InputDecoration(labelText: "phone")),
                    FormBuilderTextField(
                        attribute: "bio",
                        initialValue: bio,
                        decoration: InputDecoration(labelText: "bio")),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                          post(server + "profile", _fbKey.currentState.value);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => UserPreferencesPage()),
                                //TODO this should probably just return to last page through nav?
                                builder: (context) => LandingPage()),
                          );
                        } else {
                          print(_fbKey.currentState.value);
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
