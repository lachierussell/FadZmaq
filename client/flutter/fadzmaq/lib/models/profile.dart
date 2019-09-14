class ProfileData {
  final String userId;
  final String gender;
  final String age;
  final String phone;
  final String email;
  final String name;
  final String bio;
  final String photo;
  // final int age;

  ProfileData({this.userId, this.gender, this.age, this.phone, this.email, this.name, this.photo, this.bio});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    var profile = json['profile'];

    return ProfileData(
      userId: profile['user_id'],
      name: profile['name'],
      photo: profile['photo_location'],
      age: profile['age'],
      phone: profile['phone'],
      email: profile['email'],
      bio: profile['bio'],
    );
  }
}
