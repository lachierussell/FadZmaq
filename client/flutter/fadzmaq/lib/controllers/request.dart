import 'dart:async';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Request<T extends Model> extends StatelessWidget {
  // final String url;
  final WidgetBuilder builder;
  final Future<T> future;

  const Request({this.builder, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: fetchResponse(),
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

// class BaseResponse<T>{
//     T data;

//     BaseResponse._fromJson(Map<String, dynamic> pasrsedJson);

//     factory BaseResponse.fromJson(Map<String,dynamic> json){
//       if(T == int){
//         return IntResponse.fromJson(json) as BaseResponse<T>;
//       }
//       throw UnimplementedError();
//     }
// }

// class IntResponse extends BaseResponse<int> {
//   IntResponse.fromJson(Map<String, dynamic> json) : super._fromJson(json) {
//     this.data = int.parse(json["Hello"]);
//   }
// }

class Model{

  Model();
  factory Model.fromJson(Map<String,dynamic> json){
    return Model();
  }
}

final factoryProfileData = <Type, Function>{ProfileData: (Map<String,dynamic> json) => ProfileData.fromJson(json)};

T fromJson<T extends Model>(Map<String,dynamic> json){
  if(T == ProfileData){
    return factoryProfileData[T](json);
  }
  throw UnimplementedError();
}

Future<http.Response> fetchResponse() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    await sleep1();
    // return fromJson<
    // return Model.fromJson(json.decode(response.body));

    return response;
    // return ProfileData.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
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
