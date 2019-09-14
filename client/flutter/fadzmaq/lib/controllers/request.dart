import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:fadzmaq/models/models.dart';

/// Takes a type [T], [url] and [builder] and creates an [RequestProvider<T>] of that type
///
/// This should be used for most requests from the server
/// The premise is a model class is passed in with a URL address, this model is then populated with the
/// server response and encpasulated by an extension of [InheritedWidget], [RequestProvider<T>]. The inherited
/// widget can then be accessed by any children widgets, which will have access the fields of the model
///
/// TODO error checking and timeouts
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

/// State for [GetRequest<T>]
class _GetRequestState<T> extends State<GetRequest<T>> {
  Future _future;

  /// [didChangeDependencies] is called after [init], but is then only called once a dependency changes
  /// we initialise the [Future] [fetchResponse()] here to avoid state changes refiring it
  @override
  void didChangeDependencies() {
    String server = AppConfig.of(context).server + widget.url;
    _future = fetchResponse(server);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data is Exception){
            return Center(child: Text(snapshot.data.toString()));
          }
          if (snapshot.data.statusCode == 200) {
            return RequestProvider<T>(
              // the fromJson method takes T but checks it against specified types
              // (dart cannot initialise generic types so we can't use an extended class)
              // this converts json data into our model class
              data: fromJson<T>(json.decode(snapshot.data.body)),
              child: widget.builder(context),
            );
          } else if (snapshot.data.statusCode == 401) {
            // not sure if this is the best way to do this but it works for now - Jordan
            return LoginScreen();
          } else {
            // TODO make this handle better
            return Text("Error with HTTP request: " +
                snapshot.data.statusCode.toString());
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        // We can pipe something else in here later if we wish,
        // or make our own default
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// Only cares about the reponse code
/// This is used for checking whether a user has logged in
Future<int> fetchResponseCode(String url) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();

  final response = await http.get(
    url,
    headers: {"Authorization": result.token},
  );
  return response.statusCode;
}

Future post(String url, var Json) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();



    http.post(
      url,
      headers: {"Authorization": result.token},
      body: Json
    );



}
/// returns a [http.Response] for a given [url]
/// async operation which includes authorisation headers for
/// the current user
Future fetchResponse(String url) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();

  try {
    return await http.get(
      url,
      headers: {"Authorization": result.token},
    );
  } catch (e) {
    return e;
  }
}

// /// temp for testing
// Future sleep1() {
//   return new Future.delayed(const Duration(seconds: 2), () => "2");
// }

/// the inherited widget that encapsulates a model [T]
/// a model will represent the JSON sent by the server API
class RequestProvider<T> extends InheritedWidget {
  final T data;

  RequestProvider({this.data, Widget child}) : super(child: child);

  // We can configure this to update the state of children on a change here
  // At this moment I didn't see it being used so it will always return false - Jordan
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  // a static call which gives us a shorter call to access to our model
  // a bit more complex than normal because of the way dart handles generics
  static T of<T>(BuildContext context) {
    final type = _typeOf<RequestProvider<T>>();
    return (context.inheritFromWidgetOfExactType(type) as RequestProvider).data;
  }

  static _typeOf<T>() => T;
}
