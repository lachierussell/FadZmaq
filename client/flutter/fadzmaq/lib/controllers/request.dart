import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fadzmaq/models/models.dart';

/// This should be used for most requests from the server
/// The premise is a model class is passed in with an address, this model is then populated with the
/// server response and encpasulated by an inherited widget. The inherited
/// widget can then be accessed by any children widgets, which will have access the fields of the model
/// 
/// TODO error checking and timeouts
/// 
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

  // did change dependencies is called after init, but is then only called once a dependency changes
  // we init the future here to avoid state changes refiring it
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
            // the fromJson method takes T but checks it against specified types
            // (dart cannot initialise generic types so we can't use an extended class)
            // this converts json data into our model class
            data: fromJson<T>(json.decode(snapshot.data.body)),
            child: widget.builder(context),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        // We can pipe something else in here later if we wish,
        // or make our own default
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

// temp for testing
Future sleep1() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}

/// the inherited widget that encapsulates a model T
class InheritedRequest<T> extends InheritedWidget {
  final T data;

  InheritedRequest({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  // a static call which gives us easy access to our model
  static T of<T>(BuildContext context) {
    final type = _typeOf<InheritedRequest<T>>();
    return (context.inheritFromWidgetOfExactType(type) as InheritedRequest)
        .data;
  }

  static _typeOf<T>() => T;
}
