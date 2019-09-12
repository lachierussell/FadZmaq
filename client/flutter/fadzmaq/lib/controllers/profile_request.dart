import 'dart:async';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestProfile extends StatelessWidget {

  final WidgetBuilder builder;
  final Future future;


  const RequestProfile({this.builder, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InheritedProfile(
            data: snapshot.data,
            child: builder(context),
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


