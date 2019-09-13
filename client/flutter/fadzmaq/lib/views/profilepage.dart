import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<User> test;



class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key : key);
  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

Future<User> fetchPost() async {
  final response =
  await http.get('http://localhost:5000/profile');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    print(User.fromJson(json.decode(response.body)));
    return User.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final String nickname;
  final String dob;
  final String email;
  final String phone;
  final String bio;
  User({this.nickname, this.dob, this.email, this.phone, this.bio});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nickname : json['name'],
        dob : json ['dob'],
        email :json['email'],
        phone : json['phone'],
        bio : json['bio']
    );
  }
}



class _ProfilePageState extends State<ProfilePage> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context){
    final Color color1 = Color(0xffCCFC6D);
    final Color color2 = Color(0xff2ACDDF);
    final String image = 'assets/images/glenn.jpg';
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 240,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [color1,color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Text("Username's Hobby Profile", style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontStyle: FontStyle.italic
                ),),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0, bottom: 0.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.asset(image,fit: BoxFit.cover,
                            )),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 15.0),
                Text("Glenn - 22", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    height: 10.0
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, size: 16.0, color: Colors.grey,),
                    Text("Carnarvon, Western Australia, Australia", style: TextStyle(color: Colors.grey.shade600),)
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
                      onPressed: (){},
                    ),
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(CupertinoIcons.fullscreen),
                      onPressed: (){},
                    ),
                    IconButton(
                      color: Colors.grey.shade600,
                      icon: Icon(CupertinoIcons.game_controller),
                      onPressed: (){},
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(top: 30 ,left: 20.0, right: 20.0,bottom: 20.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color1,color2],
                            ),
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(CupertinoIcons.person_solid),
                                onPressed: () {
                                }
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.location_on),
                              onPressed: (){},
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.add),
                              onPressed: (){},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.message),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          child: Icon(Icons.favorite, color: Colors.pink,),
                          backgroundColor: Colors.white,
                          onPressed: (){},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(CupertinoIcons.pencil),
                onPressed: () {
                }
              ),
              IconButton(
                  icon: Icon(CupertinoIcons.left_chevron),
                  onPressed: () {
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<User> fetchPost() async {
    final response =
    await http.get('http://localhost:5000/profile');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState(){
    super.initState();
    test = fetchPost();
  }
//  class User {
//  final String nickname;
//  final String dob;
//  final String email;
//  final String phone;
//  final String bio;
//  User({this.userId, this.id, this.title, this.body});
//  factory User.fromJson(Map<String, dynamic> json) {
//  return User(
//  nickname : json['name']
//  dob : json ['dob']
//  email :json['email']
//  phone : json['phone']
//  bio : json['bio']
//  );
//  }
//  }
}