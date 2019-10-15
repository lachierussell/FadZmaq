import 'package:fadzmaq/models/hobbies.dart';
import 'package:collection/collection.dart';

class ProfileContainer {
  ProfileData profile;

  ProfileContainer({
    this.profile,
  });

  factory ProfileContainer.fromJson(Map<String, dynamic> json) {
    var profileJson = json['profile'];
    ProfileData profile =
        profileJson != null ? ProfileData.fromJson(profileJson) : null;

    return ProfileContainer(
      profile: profile,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProfileContainer && profile.userId == other.profile.userId;
  }

  @override
  int get hashCode {
    return profile.userId.hashCode;
  }
}

// This is used to differential the current user from other profiles
// The way the inherited request method works makes it complicated to
// have two similtaneous requests to the same model type
class UserProfileContainer {
  final ProfileData profile;

  UserProfileContainer({
    this.profile,
  });

  factory UserProfileContainer.fromJson(Map<String, dynamic> json) {
    var profileJson = json['profile'];
    ProfileData profile =
        profileJson != null ? ProfileData.fromJson(profileJson) : null;

    return UserProfileContainer(
      profile: profile,
    );
  }
}

class ProfileData {
  final String userId;

  String name;
  String photo;
  int rating;
  final List<ProfileField> profileFields;
  final List<HobbyContainer> hobbyContainers;

  ProfileData({
    this.userId,
    this.rating,
    this.name,
    this.photo = "",
    this.profileFields,
    this.hobbyContainers,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // var profile = json['profile'];
//    var contactJson = profile['contact_details'];
    var profileFieldsJson = json['profile_fields'] as List;
    var hobbyContainersJson = json['hobbies'] as List;

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
      rating: json['rating'],
      photo: json['photo_location'],
      profileFields: profileFields,
      hobbyContainers: hobbyContainers,
    );
  }

  /// Tries to replace a [HobbyContainer] in the profile [hobbyContainers]
  /// if no matching container found it will insert it into [hobbyContainers]
  /// will return [true] on a replacement or insertion is made
  /// will return [false] if a hobby container of the same container type with the same
  /// hobbies already exists
  bool replaceHobbyContainer(HobbyContainer hobbyContainer) {
    for (HobbyContainer hc in hobbyContainers) {
      if (hc.container == hobbyContainer.container) {
        if (!ListEquality().equals(hc.hobbies, hobbyContainer.hobbies)) {
          hc.hobbies = hobbyContainer.hobbies;
          return true;
        } else {
          return false;
        }
      }
    }
    hobbyContainers.add(hobbyContainer);
    return false;
  }

  void replaceProfileField(String field, String value) {
    for (ProfileField pf in profileFields) {
      if (pf.name == field) {
        pf.displayValue = value;
        return;
      }
    }
    profileFields.add(ProfileField(name: field, displayValue: value));
  }

  String getProfileField(String field) {
    if (profileFields == null) return null;
    for (ProfileField pf in profileFields) {
      if (pf.name == field) {
        return pf.displayValue;
      }
    }

    return "";
  }
}

class ProfileField {
  String displayValue;
  final String name;

  ProfileField({
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
