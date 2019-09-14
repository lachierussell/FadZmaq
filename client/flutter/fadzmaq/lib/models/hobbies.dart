class HobbyData {
  List<HobbyData> hobbies;

  HobbyData({this.hobbies});

  factory HobbyData.fromJson(Map<String, dynamic> json) =>
      _hobbiesFromJson(json);
}

HobbyData _hobbiesFromJson(Map<String, dynamic> json) {
  var hobbiesJson = json['hobby_list'] as List;
  List<HobbyData> hobbies = hobbiesJson != null
      ? hobbiesJson.map((i) => HobbyData.fromJson(i)).toList()
      : null;

  return HobbyData(
    hobbies : hobbies,
  );
}

class HobbyListData {
  final String id;
  final String name;

  HobbyListData({this.id, this.name});

  factory HobbyListData.fromJson(Map<String, dynamic> json) {
    return HobbyListData(
      id: json['id'],
      name: json['name'],
    );
  }
}
