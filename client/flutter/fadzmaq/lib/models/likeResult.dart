import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/widgets/matchDialog.dart';
import 'package:flutter/cupertino.dart';

class LikeResult {
  final bool match;
  final List<ProfileContainer> matched;

  final BuildContext context;
  final ProfileData userProfile;

  LikeResult({
    this.matched,
    this.match,
    this.context,
    this.userProfile,
  }) {
    if (match == true && matched != null && matched.length > 0) {
      matchPopup(context, matched.first.profile, userProfile);
    }
  }

  factory LikeResult.fromJson(
    Map<String, dynamic> json,
    BuildContext context,
    ProfileData profile,
    ProfileData userProfile,
  ) =>
      _matchesFromJson(json, context, userProfile);
}

LikeResult _matchesFromJson(
  Map<String, dynamic> json,
  BuildContext context,
  ProfileData userProfile,
) {
  var matchedJson = json['matched'] as List;
  List<ProfileContainer> matched = matchedJson != null
      ? matchedJson.map((i) => ProfileContainer.fromJson(i)).toList()
      : null;

  return LikeResult(
    matched: matched,
    match: json['match'],
    context: context,
    userProfile: userProfile,
  );
}
