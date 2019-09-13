class ProfileData {
  final String userId;
  final String name;
  final int age;

  ProfileData({this.userId, this.name, this.age});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    var profile = json['profile'];

    return ProfileData(
      userId: profile['user_id'],
      name: profile['name'],
      age: int.parse(profile['age']),
    );
  }
}
