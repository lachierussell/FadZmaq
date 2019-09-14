import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/controllers/request.dart';

class HobbyTempApp extends StatelessWidget {
  const HobbyTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EditHobbyPage(),
    );
  }
}




class EditHobbyPage extends StatelessWidget {
  const EditHobbyPage({Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose hobbies that you want to discover'),
      ),
      body: GetRequest<HobbyData>(
        url: "hobbies",
        builder: (context) {
          return new EditHobby();
        },
      ),
    );
  }
}



class EditHobby extends StatefulWidget {
  const EditHobby({Key key}) : super(key : key);

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

class _EditHobbyPageState extends State<EditHobby> {
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
    var x = ["Surfing", "Summer"];
    List<FormBuilderFieldOption> y = function(x);
    HobbyData hb = RequestProvider.of<HobbyData>(context);
    print(hb);
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
                        y
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

