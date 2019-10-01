
import 'package:fadzmaq/models/profile.dart';

class RecommendationsData {
  List<ProfileData> recommendations;

  RecommendationsData({this.recommendations});

  factory RecommendationsData.fromJson(Map<String, dynamic> json) =>
      _recommendationsFromJson(json);
}

RecommendationsData _recommendationsFromJson(Map<String, dynamic> json) {
  var recommendationsJson = json['matches'] as List;
  List<ProfileData> recommendations = recommendationsJson != null
      ? recommendationsJson.map((i) => ProfileData.fromJson(i)).toList()
      : null;

  return RecommendationsData(
    recommendations: recommendations,
  );
}


