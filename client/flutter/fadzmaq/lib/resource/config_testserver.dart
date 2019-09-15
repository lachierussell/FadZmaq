import 'package:fadzmaq/models/app_config.dart';

class ConfigResourceTestServer implements ConfigResource {
  @override
  String testString = "Test string test server";
  String server = "https://fadzmaq.russell-systems.cc/";
}