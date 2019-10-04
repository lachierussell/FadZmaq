import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/widgets/recommendationEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:flutter/semantics.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRequest<RecommendationsData>(
        url: "user/recs",
        builder: (context) {
          return GetRequest<UserProfileContainer>(
              url: "profile",
              builder: (context) {
                return RecommendationsList();
              });
          ;
        });
  }
}

class RecommendationsList extends StatefulWidget {
  const RecommendationsList({Key key}) : super(key: key);

  @override
  RecommendationsListState createState() => RecommendationsListState();
}

class RecommendationsListState extends State<RecommendationsList> {
  List<RecommendationContainer> recommendationsList;

  @override
  void didChangeDependencies() {
    if (recommendationsList == null) {
      RecommendationsData recommendationsData =
          RequestProvider.of<RecommendationsData>(context);

      recommendationsList = recommendationsData.recommendations;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("build recommendations");
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        );
      },
      itemCount: recommendationsList.length,
      itemBuilder: _listItemBuilder,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return RecommendationEntry(
        profile: recommendationsList[index].user, recommendationList: this);
  }

  void removeItem(String id) {
    recommendationsList.removeWhere((container) => container.user.userId == id);
  }
}
