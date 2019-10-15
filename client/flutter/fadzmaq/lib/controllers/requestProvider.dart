import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fadzmaq/models/models.dart';

/// This is redundant and should not be used in Fadzmaq, use [GlobalModel] instead
///
/// Takes a type [T], [url] and [builder] and creates an [RequestProvider<T>] of that type
///
/// This should be used for most requests from the server
/// The premise is a model class is passed in with a URL address, this model is then populated with the
/// server response and encpasulated by an extension of [InheritedWidget], [RequestProvider<T>]. The inherited
/// widget can then be accessed by any children widgets, which will have access the fields of the model
///
class GetRequest<T> extends StatefulWidget {
  /// The relative url to request
  final String url;
  final WidgetBuilder builder;
  final T model;

  const GetRequest({
    @required this.builder,
    @required this.url,
    this.model,
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
    if (widget.model == null && _future == null) {
      String server = AppConfig.of(context).server + widget.url;
      _future = httpGet(server);
      // _future = httpGetCachePhoto(context,server);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // If we have a model passed in no need to do a request
    if (widget.model != null) {
      return RequestProvider<T>(
        data: widget.model,
        child: widget.builder(context),
      );
      // No model, request one
    } else {
      return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is Exception) {
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
              // TODO return an error here and manage it further up
              return LoginScreen();
            } else {
              return Text("Error with HTTP request: " +
                  '${snapshot.data.statusCode.toString()} ' +
                  ' ${snapshot.data.body.toString()}');
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
}

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
    RequestProvider rp =
        context.inheritFromWidgetOfExactType(type) as RequestProvider;
    if (rp != null) {
      return rp.data;
    } else {
      print("Request Provider is null for: " + T.toString());
      return null;
    }
  }

  static _typeOf<T>() => T;
}
