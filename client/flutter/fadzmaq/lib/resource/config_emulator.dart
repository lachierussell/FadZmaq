import 'package:fadzmaq/models/app_config.dart';

class ConfigResourceEmulator implements ConfigResource {
  @override
  String testString = "Test string devopment";
  String server = "http://10.0.2.2:5000/";
}