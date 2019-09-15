import 'dart:convert';
import 'package:fadzmaq/views/preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/models/profile.dart';
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

Map<String, int> hobbies;

class EditHobbyPage2 extends StatelessWidget {
  const EditHobbyPage2({Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GetRequest<ProfileData>(
        url: "profile",
        builder: (context) {
          return new EditHobbyPage();
        },
      ),
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
      body: GetRequest<AllHobbiesData>(
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
  hobbies = new Map();
  List<FormBuilderFieldOption> list = [];
  for(var item  in x) {
    list.add(FormBuilderFieldOption(value: item.name));
    hobbies[item.name] = item.id;
  }
  return list;
}

List<Map> deriveResult(var x) {
  List<Map> ret = List();
  List<String> y = x["languages"];
  for(var z in y) {
    ret.add({"id" : hobbies[z], "name" : z});
  }
  return ret;
}


Map compileJson(var x) {
  Map map = {
    'hobbies': [{'container': 'share', "hobbies": deriveResult(x) }
  ]};
  return map;
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
    AllHobbiesData hb = RequestProvider.of<AllHobbiesData>(context);
    List<FormBuilderFieldOption> y = function(hb.hobbies);

     return Padding(
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

                      // TODO make this use the hobbies we're looking for
                      // probably use another getRequest for now, but it should be smoother
                      // maybe some storage of the hobby list on the app so we're only requesting the user hobbies
                      initialValue: ["Surfing"],
                      leadingInput: true,
                      options: y,
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
                          post("http://10.0.2.2:5000/profile/hobbies", utf8.encode(json.encode(compileJson(_fbKey.currentState.value))));
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
      // ),
    );
  }
}

