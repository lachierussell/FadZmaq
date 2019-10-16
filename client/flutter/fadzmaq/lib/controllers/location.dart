import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


Future sendLocation(BuildContext context) async {
  //     await fetchResponseCode(config.server + url);
  Location location = new Location();
  // don't request permission here

  bool hasPermission = await location.hasPermission();

  if (hasPermission == false) {
    return false;
  }

  LocationData currentLocation = await location.getLocation();

  String deviceToken = await _firebaseMessaging.getToken();

  // send nothing if token not available
  if (deviceToken == null) {
    deviceToken = "";
  }

  print("deviceToken: " + deviceToken);

  httpPost(AppConfig.of(context).server + "profile/ping",
      json:
          utf8.encode(json.encode(_compileJson(currentLocation, deviceToken))));

  return true;
}

Map _compileJson(LocationData locationData, String deviceToken) {
  String lat = locationData.latitude.toStringAsFixed(2);
  String long = locationData.longitude.toStringAsFixed(2);

  Map map = {
    'location': {
      'lat': lat,
      "long": long,
    },
    "device": deviceToken,
  };
  print(map);
  return map;
}
