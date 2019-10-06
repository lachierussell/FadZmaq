import 'package:fadzmaq/models/hobbies.dart';

class ProfileContainer{
  final ProfileData profile;

  ProfileContainer({
    this.profile,
  });

  factory ProfileContainer.fromJson(Map<String, dynamic> json) {
    var profileJson = json['profile'];
    ProfileData profile = profileJson != null ? ProfileData.fromJson(profileJson) : null;

    return ProfileContainer(
      profile: profile,
    );
  }
}

// This is used to differential the current user from other profiles
// The way the inherited request method works makes it complicated to
// have two similtaneous requests to the same model type
class UserProfileContainer{
  final ProfileData profile;

  UserProfileContainer({
    this.profile,
  });

  factory UserProfileContainer.fromJson(Map<String, dynamic> json) {
    var profileJson = json['profile'];
    ProfileData profile = profileJson != null ? ProfileData.fromJson(profileJson) : null;

    return UserProfileContainer(
      profile: profile,
    );
  }
}

class ProfileData {
  final String userId;
  // final String gender;
  // final String age;

//  final ContactData contactDetails;

  final String name;
  final String photo;

  final List<ProfileField> profileFields;
  final List<HobbyContainer> hobbyContainers;
  // final int age;

  ProfileData({
    this.userId,
    // this.gender,
    // this.age,
    this.name,
    this.photo,
//    this.contactDetails,
    this.profileFields,
    this.hobbyContainers,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // var profile = json['profile'];
//    var contactJson = profile['contact_details'];
    var profileFieldsJson = json['profile_fields'] as List;
    var hobbyContainersJson = json['hobbies'] as List;

//    ContactData contact =
//        contactJson != null ? ContactData.fromJson(contactJson) : null;

    // List<HobbyData> listListMap(Map<String, dynamic> json) {
    //   List<HobbyData> list = new List<HobbyData>();
    //   print(json.toString());

    //   return list;
    // }

    List<ProfileField> profileFields = profileFieldsJson != null
        ? profileFieldsJson.map((i) => ProfileField.fromJson(i)).toList()
        : null;

    List<HobbyContainer> hobbyContainers = hobbyContainersJson != null
        ? hobbyContainersJson.map((i) => HobbyContainer.fromJson(i)).toList()
        // ? hobbyContainersJson.map((i) => listListMap(i)).toList()
        : null;

    return ProfileData(
      userId: json['user_id'],
      name: json['name'],
      photo: json['photo_location'],
      // age: profile['age'],
//      contactDetails: contact,
      profileFields: profileFields,
      hobbyContainers: hobbyContainers,
    );
  }
}

//class ContactData {
//  final String phone;
//  final String email;
//
//  ContactData({
//    this.phone,
//    this.email,
//  });
//
//  factory ContactData.fromJson(Map<String, dynamic> json) {
//    return ContactData(
//      phone: json['phone'] as String,
//      email: json['email'] as String,
//    );
//  }
//}

class ProfileField {
  // final int id;
  final String displayValue;
  final String name;

  ProfileField({
    // this.id,
    this.displayValue,
    this.name,
  });

  factory ProfileField.fromJson(Map<String, dynamic> json) {
    return ProfileField(
      // id: json['id'] as int,
      name: json['name'] as String,
      displayValue: json['display_value'] as String,
    );
  }
}
