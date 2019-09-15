import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: GetRequest<ProfileData>(
        url: "profile",
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
    // return Image.network(
    //   profile.photo,
    //   height: 200,
    //   width: 200,
    //   fit: BoxFit.contain,
    // );

    if (profile.photo != null) {
      return FadeInImage.assetNetwork(
        image: profile.photo,
        placeholder: 'assets/images/placeholder-person.jpg',
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/placeholder-person.jpg',
        fit: BoxFit.cover,
      );
    }
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
    final String profile_age = pd.age != null ? pd.age : "-";
    final String profile_name = pd.age != null ? pd.name : "-";

    // final String image = 'assets/images/glenn.jpg';
    return Scaffold(
      body: Stack(
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
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 40.0, right: 40.0, top: 5.0, bottom: 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          // child: Image.asset(image,fit: BoxFit.cover,),
                          child: ProfilePic(),
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 15.0),
                Text(
                  profile_name + " - " + profile_age,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      height: 10.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
    );
  }
}
