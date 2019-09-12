import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fadzmaq/models/models.dart';




/// Takes a type, url and builder and creates an inherited widget of that type
class GetRequest<T> extends StatelessWidget {

  /// The relative url to request
  final String url;
  final WidgetBuilder builder;

  const GetRequest({
    @required this.builder,
    @required this.url,
  })  : assert(builder != null),
        assert(url != null);


  

  @override
  Widget build(BuildContext context) {

    String server = AppConfig.of(context).appConfig.server + url;

    return FutureBuilder<http.Response>(
      future: fetchResponse(server),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InheritedRequest<T>(
            data: fromJson<T>(json.decode(snapshot.data.body)),
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



Future<http.Response> fetchResponse(String url) async {
  print(url);
  final response =
      await http.get(url);
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
