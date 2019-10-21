// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fadzmaq/models/settings.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'dart:convert';

import 'package:fadzmaq/app.dart';

void main() {
  test('Unit Tests for Models', () {
    String accountJsonString1 = "{ \"distance_setting\": 20 }";
    // String accountJsonString1 = "{ 'distance_setting': 50 }";
    // String accountJsonString3 = "{ 'distance_setting': words }";
    // String accountJsonString4 = "{ 'wrongkey': 20 }";

    String matchesString = "{\"matches\": [{\"profile\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"rating\": -1,\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"phone\",\"display_value\": \"0423199199\"},{\"name\": \"email\",\"display_value\": \"john@email.com\"},{\"name\": \"age\",\"display_value\": \"20\"},{\"name\": \"birth-date\",\"display_value\": \"1999-10-04 00:00:00\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}},{\"profile\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"phone\",\"display_value\": \"0423199199\"},{\"name\": \"email\",\"display_value\": \"john@email.com\"},{\"name\": \"age\",\"display_value\": \"20\"},{\"name\": \"birth-date\",\"display_value\": \"1999-10-04 00:00:00\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}}]}";

    var accountJson = json.decode(accountJsonString1);


    AccountSettings accountObject = AccountSettings.fromJson(accountJson);


    expect(accountObject.distanceSetting, 20,
        reason: "20 is what we set it at...");

    var matchesJson = json.decode(matchesString);

    MatchesData matchesObject = MatchesData.fromJson(matchesJson);

    ProfileContainer pc = matchesObject.matches.first;

    expect(matchesObject != null, true, reason: "model should not be null");



    expect(pc.profile.name, "John", reason: "Everyone is John!");
  });

  test('Unit Tests for model: settings', () {
    String accountJsonString1 = "{ \"distance_setting\": 20 }";
    String accountJsonString2 = "{ 'distance_setting': 50 }";
    String accountJsonString3 = "{ 'distance_setting': words }";

    var accountJson1 = json.decode(accountJsonString1);
    AccountSettings accountObject1 = AccountSettings.fromJson(accountJson1);
    var accountJson2 = json.decode(accountJsonString1);
    AccountSettings accountObject2 = AccountSettings.fromJson(accountJson2);
    var accountJson3 = json.decode(accountJsonString1);
    AccountSettings accountObject3 = AccountSettings.fromJson(accountJson3);

    expect(accountObject1.distanceSetting, 20, reason: "20 is what we set it at...");
    expect(accountObject2.distanceSetting, 50, reason: "50 is what we set it at...");
    expect(accountObject3.distanceSetting, 'words', reason: "this should not be correct");

  });

  test('Unit Tests for matches: settings', () {
    String matchesString = "{\"matches\": [{\"profile\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"rating\": -1,\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"phone\",\"display_value\": \"0423199199\"},{\"name\": \"email\",\"display_value\": \"john@email.com\"},{\"name\": \"age\",\"display_value\": \"20\"},{\"name\": \"birth-date\",\"display_value\": \"1999-10-04 00:00:00\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}},{\"profile\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"phone\",\"display_value\": \"0423199199\"},{\"name\": \"email\",\"display_value\": \"john@email.com\"},{\"name\": \"age\",\"display_value\": \"20\"},{\"name\": \"birth-date\",\"display_value\": \"1999-10-04 00:00:00\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}}]}";

    var matchesJson = json.decode(matchesString);
    MatchesData matchesObject = MatchesData.fromJson(matchesJson);

    ProfileContainer pc = matchesObject.matches.first;

    expect(matchesObject != null, true, reason: "model should not be null");
    expect(pc.profile.name, "John", reason: "Everyone is John!");
    expect(pc.profile.rating, "-1", reason: "");
    expect(pc.profile.userId, "29f51c08adac957424e06699b81acdb5", reason: "");

  });

  test('Unit Tests for recommendations: settings', () {
    String recommendationsString = "{ \"recommendations\": [{\"rank\": 1,\"user\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]},{\"container\": \"matched\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}},{\"rank\": 2,\"user\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"Amy\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"location\",\"display_value\": \"6\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]},{\"container\": \"matched\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}}]}";

    var recommendationsJson = json.decode(recommendationsString);
    RecommendationsData recommendationsObject = RecommendationsData.fromJson(recommendationsJson);
    
    ProfileContainer pc = recommendationsObject.recommendations.first;
    

    expect(recommendationsObject != null, true, reason: "model should not be null");
    expect(pc.profile.name, "John", reason: "Everyone is John!");
    expect(pc.profile.userId, "29f51c08adac957424e06699b81acdb5", reason: "invalid id!");
    expect(pc.profile.photo, "URL", reason: "Everyone is John!");


  });

  test('Unit Tests for hobbies: settings', () {
    String hobbyString = "{ \"recommendations\": [{\"rank\": 1,\"user\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"John\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"location\",\"display_value\": \"<5\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]},{\"container\": \"matched\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}},{\"rank\": 2,\"user\": {\"user_id\": \"29f51c08adac957424e06699b81acdb5\",\"name\": \"Amy\",\"photo_location\": \"URL\",\"profile_fields\": [{\"name\": \"about me\",\"display_value\": \"Avid rock climber and hiking enthusiast.\"},{\"name\": \"location\",\"display_value\": \"6\"}],\"hobbies\": [{\"container\": \"share\",\"hobbies\": [{\"id\": 3,\"name\": \"Rock Climbing\"}]},{\"container\": \"discover\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]},{\"container\": \"matched\",\"hobbies\": [{\"id\": 1,\"name\": \"Boxing\"}]}]}}]}";

    var hobbyJson = json.decode(hobbyString);
    HobbyData hobbyObject = HobbyData.fromJson(hobbyJson);

    HobbyContainer hc = hobbyObject;

    expect(hobbyObject != null, true, reason: "model should not be null");
    expect(hc.hobbies, "John", reason: "Everyone is John!");

  });

}
