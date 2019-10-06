import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/widgets/matchDialog.dart';
import 'package:flutter/cupertino.dart';

class LikeResult {
  final bool match;
  final BuildContext context;

  // TODO remove this temp
  final ProfileData profile;


  LikeResult({
    this.match,
    this.profile,
    this.context,
  }) {
    if (match == true) matchPopup(context, profile);
  }

  factory LikeResult.fromJson(Map<String, dynamic> json, BuildContext context, ProfileData profile) {
    return LikeResult(
      match: json['match'],
      profile: profile,
      context: context,
    );
  }
}
