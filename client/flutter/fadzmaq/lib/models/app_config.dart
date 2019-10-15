import 'package:flutter/material.dart';

/// Allows config options to be passed through the app
/// Is selected by pointing to different main files which hold the
/// specificed build configurations
class AppConfig extends InheritedWidget {
  AppConfig({
    this.appConfig,
    Widget child,
  }) : super(child: child);

  final ConfigResource appConfig;

  static ConfigResource of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppConfig) as AppConfig)
        .appConfig;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

abstract class ConfigResource {
  String testString;
  String server;
}
