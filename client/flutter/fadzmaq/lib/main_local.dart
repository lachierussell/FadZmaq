import 'package:fadzmaq/app_config.dart';
import 'package:fadzmaq/app.dart';
import 'package:fadzmaq/resource/config_local.dart';

import 'package:flutter/material.dart';


void main() {
  var configuredApp = AppConfig(
    appConfig: ConfigResourceDev(),
    child: App(),
  );

  runApp(configuredApp);
}