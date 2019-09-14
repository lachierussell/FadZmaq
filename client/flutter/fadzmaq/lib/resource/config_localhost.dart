import 'package:fadzmaq/models/app_config.dart';

class ConfigResourceLocalHost implements ConfigResource {
  @override
  String testString = "Test string devopment";
  String server = "http://localhost:5000/";
}