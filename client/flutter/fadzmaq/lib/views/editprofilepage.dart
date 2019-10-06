import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  const EditProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: GetRequest<ProfileContainer>(
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

String profileFieldFromString(ProfileData pd, String fieldName) {
  if (pd != null && pd.profileFields != null) {
    for (ProfileField pf in pd.profileFields) {
      // Dart lets us compare stings this way, what a revolution!
      if (pf.name == fieldName) {
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
    ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
    String server = AppConfig.of(context).server;

    // check for id 1 (about me) and grab the display value
    String bio = profileFieldFromString(pd, "bio");
    String contactPhone = profileFieldFromString(pd, "phone");
    String contactEmail = profileFieldFromString(pd, "email");

//    final String contact_phone =
//        pd.contactDetails.phone != null ? pd.contactDetails.phone : "";
//    String contact_email =
//        pd.contactDetails.email != null ? pd.contactDetails.email : "";

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
                        initialValue: contactEmail,
                        decoration: InputDecoration(labelText: "email")),
                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: contactPhone,
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

                          Navigator.pop(context);
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
