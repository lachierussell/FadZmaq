class ProfileData {
  final String userId;
  final String name;
  final String photo;
  // final int age;

  ProfileData({this.userId, this.name, this.photo});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    var profile = json['profile'];

    return ProfileData(
      userId: profile['user_id'],
      name: profile['name'],
      photo: profile['photo_location'],
      // age: int.parse(profile['age']),
    );
  }
}
