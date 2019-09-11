import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/app.dart';
import 'package:fadzmaq/resource/config_testserver.dart';

import 'package:flutter/material.dart';

// entry point to load default config for test server
void main() {
  var configuredApp = AppConfig(
    appConfig: ConfigResourceDefault(),
    child: App(),
  );

  runApp(configuredApp);
}