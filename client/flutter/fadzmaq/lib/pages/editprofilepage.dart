import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
    String list = '{"nickname":"Thiren", "bio":"", "dob":"13/05/1999", "gender":"Male", "email":"22257963@student.uwa.edu.au", "phone":"0449570630"}';
    var jsoncode = json.decode(list);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
          actions: <Widget>[
            IconButton(
            icon: Icon(CupertinoIcons.left_chevron),
              onPressed: () {
                appAuth.logout().then(
                        (_) => Navigator.of(context).pushReplacementNamed('/profilepage')
                );
              }
            ),
          ]
        ),
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
                    FormBuilderDateTimePicker(
                      attribute: "date",
                      initialValue: DateTime.parse("1999-05-13 00:00:00.000") ,
                      inputType: InputType.date,
                      format: DateFormat("dd-MM-yyyy"),
                      decoration:
                      InputDecoration(labelText: "Date of Birth"),
                    ),
                    FormBuilderDropdown(
                      attribute: "gender",
                      decoration: InputDecoration(
                        labelText: "Gender",
                        /*border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),*/
                      ),
                      // readOnly: true,
                      initialValue: jsoncode['gender'],
                      hint: Text('Select Gender'),
                      validators: [FormBuilderValidators.required()],
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text('$gender'),
                      ))
                          .toList(),
                    ),
                    FormBuilderTextField(
                        attribute: "nickname",
                        initialValue: jsoncode['nickname'],
                        decoration: InputDecoration(labelText: "Nickname")
                    ),

                    FormBuilderTextField(
                        attribute: "email",
                        initialValue: jsoncode['email'],
                        decoration: InputDecoration(labelText: "email")
                    ),

                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: jsoncode['phone'],
                        decoration: InputDecoration(labelText: "phone")
                    ),

                    FormBuilderTextField(
                        attribute: "bio",
                        initialValue: jsoncode['bio'],
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
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
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

