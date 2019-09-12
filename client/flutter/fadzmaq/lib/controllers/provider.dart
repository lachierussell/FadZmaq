

import 'package:flutter/material.dart';

class Provider extends InheritedWidget{
  final String data = "test";

  Provider({Key key, Widget child}) : super (key:key, child: child);

  static Provider of (BuildContext context){
    return (context.inheritFromWidgetOfExactType(Provider) as Provider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget){
    return false;
  }
}

// class TestData{



//   String title = "Test";
// }