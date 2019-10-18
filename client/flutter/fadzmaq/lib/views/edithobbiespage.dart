import 'dart:convert';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/controllers/request.dart';

class HobbyTempApp extends StatelessWidget {
  const HobbyTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EditHobbyPage2(),
    );
  }
}

Map<String, int> hobbies;
bool finalIsShare;

class EditHobbyPage2 extends StatelessWidget {
  final bool isShare;
  const EditHobbyPage2({Key key, this.isShare}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerifyModel(
        model: Model.userProfile,
        builder: (context) {
          finalIsShare = isShare;
          return new EditHobbyPage();
        },
      ),
    );
  }
}

class EditHobbyPage extends StatelessWidget {
  const EditHobbyPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hobbies to ' + discoverOrShare()),
      ),
      body: VerifyModel(
        model: Model.allHobbies,
        builder: (context) {
          return new EditHobby();
        },
      ),
    );
  }
}

class EditHobby extends StatefulWidget {
  const EditHobby({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _EditHobbyPageState();
}

List<FormBuilderFieldOption> function(var x) {
  List<FormBuilderFieldOption> list = [];
  hobbies = Map();
  for (var item in x) {
    list.add(FormBuilderFieldOption(value: item.name));
    hobbies[item.name] = item.id;
  }
  return list;
}

List<Map> deriveResult(BuildContext context, var x) {
  List<HobbyData> modelHobbies = List<HobbyData>();

  List<Map> ret = List();
  List<String> y = x["languages"];
  for (var z in y) {
    ret.add({"id": hobbies[z], "name": z});
    modelHobbies.add(HobbyData(id: hobbies[z], name: z));
  }

  var hobbyContainer =
      HobbyContainer(container: discoverOrShare(), hobbies: modelHobbies);

  // Replace the new hobby configuration
  // If a replacement was made load in the recommendations again
  // bool replacementMade = getUserProfile(context).replaceHobbyContainer(hobbyContainer);
  getUserProfile(context).replaceHobbyContainer(hobbyContainer);
  // if(replacementMade){

  // }

  return ret;
}

Map<String, dynamic> compileJson(BuildContext context, var x) {
  Map<String, dynamic> map = {
    'hobbies': [
      {'container': discoverOrShare(), "hobbies": deriveResult(context, x)}
    ]
  };
  print(map);
  return map;
}

String discoverOrShare() {
  if (finalIsShare) {
    return "share";
  } else {
    return "discover";
  }
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
    // List<FormBuilderFieldOption> y = function(x);

    AllHobbiesData hb = getHobbies(context);
    ProfileData pd = getUserProfile(context);

    List<String> hobbies = List();
    print("here");
    if (pd.hobbyContainers != null) {
      for (HobbyContainer hc in pd.hobbyContainers) {
        if (hc.container == discoverOrShare()) if (hc.hobbies != null) {
          for (HobbyData h in hc.hobbies) {
            hobbies.add(h.name);
          }
        }
      }
    }

    print(hobbies);
    List<FormBuilderFieldOption> y = function(hb.hobbies);
    // print(hb);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Choose hobbies to discover"),
    //   ),
    //   body:

    double scrollHeight = MediaQuery.of(context).size.height - 160;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            height: scrollHeight,
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
                          decoration: InputDecoration(labelText: "Hobbies"),
                          attribute: "languages",
                          initialValue: hobbies,
                          leadingInput: true,
                          options: y,
                          onChanged: _onChanged,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          MaterialButton(
            color: Theme.of(context).accentColor,
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_fbKey.currentState.saveAndValidate()) {
                print(_fbKey.currentState.value);

                // compile json and changes user profile model
                Map<String, dynamic> hobJson =
                    compileJson(context, _fbKey.currentState.value);

                httpPost(AppConfig.of(context).server + "profile/hobbies",
                        json: json.encode(hobJson))
                    .then((value) {
                  loadModelAsync(context, Model.recommendations);
                });
                Navigator.pop(context);
              } else {
                print(_fbKey.currentState.value);
                print("validation failed");
              }
            },
          ),
        ],
      ),
      // ),
    );
  }
}
