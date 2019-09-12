import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fadzmaq/models/models.dart';

/// Takes a type, url and builder and creates an inherited widget of that type
class GetRequest<T> extends StatefulWidget {
  /// The relative url to request
  final String url;
  final WidgetBuilder builder;

  const GetRequest({
    @required this.builder,
    @required this.url,
  })  : assert(builder != null),
        assert(url != null);

  @override
  _GetRequestState<T> createState() => _GetRequestState<T>();
}

class _GetRequestState<T> extends State<GetRequest<T>> {
  Future _future;

  // initState() {
  //   super.initState();
  //   String server = AppConfig.of(context).appConfig.server + widget.url;
  //   _future = fetchResponse(server);
  // }

  @override
  void didChangeDependencies() {
    String server = AppConfig.of(context).server + widget.url;
    _future = fetchResponse(server);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InheritedRequest<T>(
            data: fromJson<T>(json.decode(snapshot.data.body)),
            child: widget.builder(context),
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

Future<int> fetchResponseCode(String url) async {
  http.Response response = await fetchResponse(url); 
  return response.statusCode;
}

Future<http.Response> fetchResponse(String url) async {
  // print(url);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();

  final response = await http.get(
    url,
    headers: {"Authorization": result.token},
  );
  // await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    await sleep1();

    return response;
  } else {
    // If that call was not successful, throw an error.
    // TODO we need to treat this internally
    throw Exception('Failed to load post');
  }
}

Future sleep1() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
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
