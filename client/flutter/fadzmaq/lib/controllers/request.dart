import 'dart:async';
import 'package:flutter/material.dart';

class Request<T> extends StatelessWidget {
  // final String url;
  final WidgetBuilder builder;
  final Future<T> future;

  const Request({this.builder, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InheritedRequest<T>(
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

class InheritedRequest<T> extends InheritedWidget {
  final T data;

  InheritedRequest({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static T of<T>(BuildContext context) {
    final type = _typeOf<InheritedRequest<T>>();
    return (context.inheritFromWidgetOfExactType(type) as InheritedRequest)
        .data;
  }

  static _typeOf<T>() => T;
}
