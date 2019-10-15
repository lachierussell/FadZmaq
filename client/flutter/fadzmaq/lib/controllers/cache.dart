import 'dart:convert';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// Caches profile photos based on [RecommendationsData]
Future cacheRecommendationPhotos(
    BuildContext context, RecommendationsData rd) async {
  List<Future> futures = List<Future>();

  if (rd == null) return;
  if (rd.recommendations == null) return;

  for (ProfileContainer pc in rd.recommendations) {
    if (pc == null) continue;
    if (pc.profile == null) continue;
    if (pc.profile.photo == null) continue;

    futures.add(cachePhotoURL(context, pc.profile.photo));
  }
  await Future.wait(futures);
}

/// Caches profile photos based on [MatchesData]
Future cacheMatchPhotos(BuildContext context, MatchesData matchData) async {
  List<Future> futures = List<Future>();

  if (matchData == null) return;
  if (matchData.matches == null) return;

  for (ProfileContainer pc in matchData.matches) {
    if (pc == null) continue;
    if (pc.profile == null) continue;
    if (pc.profile.photo == null) continue;

    futures.add(cachePhotoURL(context, pc.profile.photo));
  }
  await Future.wait(futures);
}

/// Caches profile photos based on [ProfileContainer]
Future cacheProfilePhotos(BuildContext context, ProfileData profile) async {
  if (profile == null) return;
  if (profile.photo == null) return;

  await cachePhotoURL(context, profile.photo);
}

/// Caches the three different expected sized images of a particular image
Future<void> cachePhotoURL(BuildContext context, String url) async {
  double screenWidth = MediaQuery.of(context).size.shortestSide;

  String recPhoto = photoThumbURL(context, url, Globals.recThumbDim);
  String matchPhoto = photoThumbURL(context, url, Globals.matchThumbDim);
  String profilePhoto = photoThumbURL(context, url, screenWidth);

  // print("cacheing: " + matchPhoto);
  // print("cacheing: " + profilePhoto);

  DefaultCacheManager cache = DefaultCacheManager();

  List<Future> futures = List<Future>();

  if (await cache.getFileFromCache(recPhoto) == null) {
    print("cacheing: " + recPhoto);
    futures.add(cache.downloadFile(recPhoto));
    futures.add(cache.downloadFile(matchPhoto));
    futures.add(cache.downloadFile(profilePhoto));

    await Future.wait(futures);
  }
}

/// This convers a standard URL to a thumb version the server can understand
/// and return the specific dimensioned image by
/// Currently only working for test images on Wikipedia, but Firebase supports
/// a similar function
String photoThumbURL(BuildContext context, String url, double dimension) {
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;

  String dimString = (dimension * devicePixelRatio).toStringAsFixed(0);

  const wikipediaURL = "https://upload.wikimedia.org/wikipedia/commons";

  if (url.contains(wikipediaURL) && !url.contains("thumb")) {
    return wikipediaURL +
        "/thumb/" +
        url.substring(47) +
        "/" +
        dimString +
        "px-thumbnail.jpg";
  } else {
    return url;
  }
}
