import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/app.dart';
import 'package:fadzmaq/resource/config_local.dart';

import 'package:flutter/material.dart';

// entry point to load default config for local testing
void main() {
  var configuredApp = AppConfig(
    appConfig: ConfigResourceDev(),
    child: App(),
  );

  runApp(configuredApp);
}