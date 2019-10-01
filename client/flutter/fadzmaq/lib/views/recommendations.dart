import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/widgets/recommendationEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRequest<RecommendationsData>(
        url: "user/recs",
        builder: (context) {
          return RecommendationsList();
        });
  }
}

class RecommendationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecommendationsData recommendationsData =
        RequestProvider.of<RecommendationsData>(context);

    return ListView.separated(
      separatorBuilder: (context, index){ return Divider(color: Colors.black,);},
      itemCount: recommendationsData.recommendations.length,
      itemBuilder: _listItemBuilder,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    RecommendationsData recommendationsData =
        RequestProvider.of<RecommendationsData>(context);
    return RecommendationEntry(
        profile: recommendationsData.recommendations[index].user);
  }
}
