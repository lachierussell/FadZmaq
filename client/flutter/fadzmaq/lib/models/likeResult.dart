import 'package:fadzmaq/models/profile.dart';

/// returned by the server once you like someone
/// if there is a match the [ProfileContainer] is included
class LikeResult {
  final bool match;
  final List<ProfileContainer> matched;

  LikeResult({
    this.matched,
    this.match,
  });

  factory LikeResult.fromJson(
    Map<String, dynamic> json,
  ) =>
      _matchesFromJson(json);
}

LikeResult _matchesFromJson(
  Map<String, dynamic> json,
) {
  var matchedJson = json['matched'] as List;
  List<ProfileContainer> matched = matchedJson != null
      ? matchedJson.map((i) => ProfileContainer.fromJson(i)).toList()
      : null;

  return LikeResult(
    matched: matched,
    match: json['match'],
  );
}
