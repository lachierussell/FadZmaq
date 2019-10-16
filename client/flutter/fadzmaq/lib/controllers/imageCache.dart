import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Caches profile photos based on [RecommendationsData]
/// globalModel required to calculate image sizes
Future cacheRecommendationPhotos(
    GlobalModel globalModel, RecommendationsData rd) async {
  List<Future> futures = List<Future>();

  if (rd == null) return;
  if (rd.recommendations == null) return;

  for (ProfileContainer pc in rd.recommendations) {
    if (pc == null) continue;
    if (pc.profile == null) continue;
    if (pc.profile.photo == null) continue;

    futures.add(cachePhotoURL(globalModel, pc.profile.photo));
  }
  await Future.wait(futures);
}

/// Caches profile photos based on [MatchesData]
/// globalModel required to calculate image sizes
Future cacheMatchPhotos(GlobalModel globalModel, MatchesData matchData) async {
  List<Future> futures = List<Future>();

  if (matchData == null) return;
  if (matchData.matches == null) return;

  for (ProfileContainer pc in matchData.matches) {
    if (pc == null) continue;
    if (pc.profile == null) continue;
    if (pc.profile.photo == null) continue;

    futures.add(cachePhotoURL(globalModel, pc.profile.photo));
  }
  await Future.wait(futures);
}

/// Caches profile photos based on [ProfileContainer]
/// globalModel required to calculate image sizes
Future cacheProfilePhotos(GlobalModel globalModel, ProfileData profile) async {
  if (profile == null) return;
  if (profile.photo == null) return;

  await cachePhotoURL(globalModel, profile.photo);
}

/// Caches the three different expected sized images of a particular image
/// [globalModel] required to calculate image sizes
Future<void> cachePhotoURL(GlobalModel globalModel, String url) async {
  double pr = globalModel.devicePixelRatio;

  String recPhoto = photoThumbURL(pr, url, Globals.recThumbDim);
  String matchPhoto = photoThumbURL(pr, url, Globals.matchThumbDim);
  String profilePhoto = photoThumbURL(pr, url, globalModel.screenWidth);

  CustomCacheManager cache = CustomCacheManager();

  List<Future> futures = List<Future>();

  // Add each to a list of futures so they may be concurently processed
  if (await cache.getFileFromCache(recPhoto) == null) {
    print("Caching: " + url);
    futures.add(cache.downloadFile(recPhoto));
    futures.add(cache.downloadFile(matchPhoto));
    futures.add(cache.downloadFile(profilePhoto));

    await Future.wait(futures);
    print("Cache complete for: " + url);
  }
}

/// This converts a standard URL to a thumb version the server can understand
/// and return the specific dimensioned image by
/// Currently only working for test images on Wikipedia, but Firebase supports
/// a similar function
String photoThumbURL(double devicePixelRatio, String url, double dimension) {

  if(dimension == null) return url;
  if(devicePixelRatio == null) return url;


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


class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._() : super(key,
      maxAgeCacheObject: Duration(days: 30),
      maxNrOfCacheObjects: 1000,);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

}