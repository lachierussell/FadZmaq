import 'package:fadzmaq/controllers/profile_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fadzmaq/controllers/request.dart';

class GetProfileData extends StatelessWidget {
  final WidgetBuilder builder;
  const GetProfileData({this.builder});

  @override
  Widget build(BuildContext context) {
    // return Request<ProfileData>(
    return Request<ProfileData>(
      builder: builder,
      future: fetchProfile(),
    );
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
