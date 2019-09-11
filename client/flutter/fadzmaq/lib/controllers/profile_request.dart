import 'dart:async';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestProfile extends StatelessWidget {

  final AsyncWidgetBuilder<ProfileData> builder;


  const RequestProfile({this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InheritedProfile(
            data: snapshot.data,
            child: builder(context, snapshot),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}

class InheritedProfile extends InheritedWidget {
  final ProfileData data;

  final String test = "test";

  InheritedProfile({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;


  static InheritedProfile of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedProfile) as InheritedProfile;
  }
}


Future<ProfileData> fetchProfile() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    await sleep1();
    return ProfileData.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


Future sleep1() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}

class ProfileData {
  final int userId;
  final int id;
  final String title;
  final String body;

  ProfileData({this.userId, this.id, this.title, this.body});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
