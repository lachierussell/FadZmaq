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

// class RecommendationContainer {
//   final int rank;
//   final ProfileData user;

//   RecommendationContainer({
//     this.rank,
//     this.user,
//   });

//   factory RecommendationContainer.fromJson(Map<String, dynamic> json) {


//     var userJson = json['user'];
//     // print("USERJSON: " + userJson.toString());
//     ProfileData user = userJson != null ? ProfileData.fromJson(userJson) : null;

//     return RecommendationContainer(
//       rank: json['rank'],
//       user: user,
//     );
//   }


//     @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         other is RecommendationContainer && user.userId == other.user.userId;
//   }

//   @override
//   int get hashCode {
//     return user.userId.hashCode;
//   }
// }
