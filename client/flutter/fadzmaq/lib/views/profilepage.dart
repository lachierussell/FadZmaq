import 'package:fadzmaq/main.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTempApp extends StatelessWidget {
  const ProfileTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String url;

  const ProfilePage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: GetRequest<ProfileData>(
        url: url,
        builder: (context) {
          return ProfilePageState();
        },
      ),
    );
  }
}

// todo make this a proper reuseable widget
class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData profile = RequestProvider.of<ProfileData>(context);

    return CachedNetworkImage(
      imageUrl: profile.photo,
      fit: BoxFit.cover,
      // placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      
    );
  }
}

class ProfilePageState extends StatelessWidget {
  // String _status = 'no-action';

  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileData>(context);
    final Color color1 = Color(0xffCCFC6D);
    final Color color2 = Color(0xff2ACDDF);

    // putting these up here in case of nulls
    // right now just putting dash instead of the value
    final String profileAge = pd.age != null ? pd.age : "-";
    final String profileName = pd.age != null ? pd.name : "-";

    String hobbiesRaw = "";

    print(pd.hobbyContainers.toString());

    if (pd.hobbyContainers != null) {
      for (HobbyContainer hc in pd.hobbyContainers) {
        hobbiesRaw += "--" + hc.container + "--\n";
        if (hc.hobbies != null) {
          for (HobbyData h in hc.hobbies) {
            hobbiesRaw += h.name + "\n";
          }
        }
      }
    }

    // final String image = 'assets/images/glenn.jpg';
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 240,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                  gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
            ),
            Container(
              // margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 20.0),
                  // Expanded(
                  // child: Stack(
                  // children: <Widget>[
                  Container(
                    // height: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 5.0, bottom: 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      // child: Image.asset(image,fit: BoxFit.cover,),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ProfilePic(),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.0),
                  Text(
                    profileName + ', ' + profileAge,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34.0,
                        height: 1.5
                    ),
                  ),
                  Align
                    (
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0),
                      child: Text("Discovering"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 5.0),
                    child: Align
                      (
                      alignment: Alignment.centerLeft,
                      child: Container(
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: <Widget>[
                              getHobbies(context, pd, "discover")
                            ],
                          )
                      ),
                    ),
                  ),
                  Align
                    (
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 15.0),
                      child: Text("Sharing"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 5.0),
                    child: Align
                      (
                      alignment: Alignment.centerLeft,
                      child: Container(
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: <Widget>[
                              getHobbies(context, pd, "share")
                            ],
                          )
                      ),
                    ),
                  ),
//                  Text(
//                    hobbiesRaw,
//                    style: TextStyle(
//                      fontSize: 16.0,
//                      height: 2.0,
//                    ),
//                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0),
                      ),
                      Icon(
                        Icons.location_on,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      Text(
                        "Perth, Western Australia, Australia",
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        color: Colors.grey,
                        icon: Icon(CupertinoIcons.photo_camera),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: Colors.grey,
                        icon: Icon(CupertinoIcons.fullscreen),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: Colors.grey.shade600,
                        icon: Icon(CupertinoIcons.game_controller),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 16.0),
                          margin: const EdgeInsets.only(
                              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color1, color2],
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(CupertinoIcons.person_solid),
                                  onPressed: () {}),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.location_on),
                                onPressed: () {},
                              ),
                              Spacer(),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.add),
                                onPressed: () {},
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.message),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            ),
                            backgroundColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  String hobbyContainer;
  FilterChipWidget({Key key, this.chipName}) : super(key : key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();

}

class _FilterChipWidgetState extends State<FilterChipWidget>{

  Widget build(BuildContext context){
    return FilterChip(
      label:Text(widget.chipName),
      labelStyle: TextStyle(color: Color(0xff6200ee),fontSize: 16.0),


    );
  }

}

Widget getHobbies(BuildContext context, ProfileData profile, String container) {
  // return Text("to be done");

  List<Widget> list = new List<Widget>();
  // print(profile.hobbyContainers.toString());
  if (profile.hobbyContainers != null) {
    for (HobbyContainer hc in profile.hobbyContainers) {
      print(hc.container.toString());
      if (hc.container == container) {
        for (HobbyData hobby in hc.hobbies) {
          list.add(getHobbyChip(context, hobby));
        }
      }
    }
  }
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: new Wrap(
      spacing: 4,
      runSpacing: 4,
      children: list,
    ),
  );
}

Widget getHobbyChip(BuildContext context, HobbyData hobby) {
  // return Chip(
  //   label: Text(hobby.name),
  //   backgroundColor: hobby.color,
  // );
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    child: Container(
      color: Color(0xfff2f2f2),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
          child: new Text(hobby.name)),
    ),
  );
}

