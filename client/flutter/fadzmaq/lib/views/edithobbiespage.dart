import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class EditHobbyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EditHobbyPageState();
}

List<FormBuilderFieldOption> function(var x) {
  List<FormBuilderFieldOption> list = [];
  for(var item  in x) {
    list.add(FormBuilderFieldOption(value: item));
  }
  return list;
}

class _EditHobbyPageState extends State<EditHobbyPage> {
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
    var x = ["Surfing", "Swimming"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose hobbies to discover"),
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

                    FormBuilderCheckboxList(
                      decoration: InputDecoration(
                          labelText: "Hobbies"),
                      attribute: "languages",
                      initialValue: ["Surfing"],
                      leadingInput: true,
                      options:
                      function(x)
                      ,
                      onChanged: _onChanged,
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

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

