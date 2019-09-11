import 'package:flutter/material.dart';


class AppConfig extends InheritedWidget {
  AppConfig({
    this.appConfig,
    Widget child,
  }):super(child: child);


  final ConfigResource appConfig;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}


abstract class ConfigResource {
  String testString;
}