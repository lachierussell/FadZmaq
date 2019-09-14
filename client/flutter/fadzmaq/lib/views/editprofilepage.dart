import 'dart:convert';
import 'package:fadzmaq/controllers/request.dart';
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
  const EditProfilePage({Key key}) : super(key : key);

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
  const EditProfile({Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState() => new EditProfileState();
}

class EditProfileState extends State<EditProfile>{
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
                        decoration: InputDecoration(labelText: "Nickname")
                    ),

                    FormBuilderTextField(
                        attribute: "email",
                        initialValue: pd.email,
                        decoration: InputDecoration(labelText: "email")
                    ),

                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: pd.phone,
                        decoration: InputDecoration(labelText: "phone")
                    ),

                    FormBuilderTextField(
                        attribute: "bio",
                        initialValue: pd.bio,
                        decoration: InputDecoration(labelText: "bio")
                    ),

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
                          post("http://10.0.2.2:5000/profile",_fbKey.currentState.value );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPreferencesPage()),
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

