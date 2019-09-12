import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    this.appConfig,
    Widget child,
  }) : super(child: child);

  final ConfigResource appConfig;

  static ConfigResource of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppConfig)as AppConfig).appConfig;
  }

  // static String of(BuildContext context){
  //   return (context.inheritFromWidgetOfExactType(AppConfig).testString as String);
  // }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

abstract class ConfigResource {
  String testString;
  String server;
}
