import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/app.dart';
import 'package:fadzmaq/resource/config_emulator.dart';

import 'package:flutter/material.dart';

// entry point to load default config for local testing
void main() {
  var configuredApp = AppConfig(
    // this is default for android
    appConfig: ConfigResourceEmulator(),
    child: App(),
  );

  runApp(configuredApp);
}