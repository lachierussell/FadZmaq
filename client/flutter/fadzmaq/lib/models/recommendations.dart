import 'package:fadzmaq/models/profile.dart';

class RecommendationsData {
  List<RecommendationContainer> recommendations;

  RecommendationsData({this.recommendations});

  factory RecommendationsData.fromJson(Map<String, dynamic> json) =>
      _recommendationsFromJson(json);
}

RecommendationsData _recommendationsFromJson(Map<String, dynamic> json) {
  var recommendationsJson = json['recommendations'] as List;
  List<RecommendationContainer> recommendations = recommendationsJson != null
      ? recommendationsJson.map((i) => RecommendationContainer.fromJson(i)).toList()
      : null;

  return RecommendationsData(
    recommendations: recommendations,
  );
}

class RecommendationContainer {
  final int rank;
  final ProfileData user;

  RecommendationContainer({
    this.rank,
    this.user,
  });

  factory RecommendationContainer.fromJson(Map<String, dynamic> json) {


    var userJson = json['user'];
    print("USERJSON: " + userJson.toString());
    ProfileData user = userJson != null ? ProfileData.fromJson(userJson) : null;

    return RecommendationContainer(
      rank: json['rank'],
      user: user,
    );
  }
}
