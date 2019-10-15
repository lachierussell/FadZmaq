import 'package:fadzmaq/models/profile.dart';

class RecommendationsData {
  List<ProfileContainer> recommendations;

  RecommendationsData({this.recommendations});

  factory RecommendationsData.fromJson(Map<String, dynamic> json) =>
      _recommendationsFromJson(json);
}

RecommendationsData _recommendationsFromJson(Map<String, dynamic> json) {
  var recommendationsJson = json['recommendations'] as List;
  List<ProfileContainer> recommendations = recommendationsJson != null
      ? recommendationsJson.map((i) => ProfileContainer.fromJson(i)).toList()
      : null;

  return RecommendationsData(
    recommendations: recommendations,
  );
}
