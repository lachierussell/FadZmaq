import 'package:fadzmaq/views/widgets/hobbyChip.dart';

class AllHobbiesData {
  List<HobbyData> hobbies;

  AllHobbiesData({this.hobbies});

  factory AllHobbiesData.fromJson(Map<String, dynamic> json) =>
      _hobbiesFromJson(json);
}

AllHobbiesData _hobbiesFromJson(Map<String, dynamic> json) {
  var hobbiesJson = json['hobby_list'] as List;
  List<HobbyData> hobbies = hobbiesJson != null
      ? hobbiesJson.map((i) => HobbyData.fromJson(i)).toList()
      : null;

  return AllHobbiesData(
    hobbies: hobbies,
  );
}

class HobbyData {
  final int id;
  final String name;

  const HobbyData({this.id, this.name});

  factory HobbyData.fromJson(Map<String, dynamic> json) {
    return HobbyData(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HobbyData && id == other.id ||
        other is HobbyInfo && id == other.hobby.id;
  }

  @override
  int get hashCode {
    return id;
  }
}

class HobbyContainer {
  String container;
  List<HobbyData> hobbies;

  HobbyContainer({
    this.hobbies,
    this.container,
  });

  factory HobbyContainer.fromJson(Map<String, dynamic> json) =>
      _hobbyContainerFromJson(json);
}

HobbyContainer _hobbyContainerFromJson(Map<String, dynamic> json) {
  var hobbiesJson = json['hobbies'] as List;
  List<HobbyData> hobbies = hobbiesJson != null
      ? hobbiesJson.map((i) => HobbyData.fromJson(i)).toList()
      : null;

  return HobbyContainer(
    container: json['container'],
    hobbies: hobbies,
  );
}
