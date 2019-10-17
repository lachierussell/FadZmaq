import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:http/http.dart' as http;
import 'package:fadzmaq/models/app_config.dart';

// Redundant but useful

// /// Helper (method?) to the ProfileFieldWidget.
// /// Builds a list of Text from the Profile data.
// /// @param context  The BuildContext from the ProfileFieldWidget
// /// @return A list of Text objects.
// List<Widget> profileFieldRender(context) {
//   ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
//   List<Widget> rows =
//       pd.profileFields.map((item) => new Text(item.displayValue)).toList();
//   return rows;
// }

// /// Dynamically builds/renders the profile fields section of the Profile page.
// /// It will draw every field that is sent to it. It also ignores anything that
// /// isn't sent. E.g. If it is a match, it will render contact details, but if
// /// it is a recommendation, it will not.
// class ProfileFieldWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Column(children: profileFieldRender(context)));
//   }
// }

class ProfileBody extends StatelessWidget {
  final ProfileType type;
  final ProfileData profile;
  const ProfileBody({
    Key key,
    @required this.profile,
    this.type,
  })  : assert(profile != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // putting these up here in case of nulls
    // right now just putting dash instead of the value
    // final String profileAge = pd.age != null ? pd.age : "-";
    final String profileName = profile.name != null ? profile.name : "-";
    final int rating = profile.rating;
    final String bio = profile.getProfileField("bio");
    print(rating);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 15.0),
        Text(profileName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 42.0, height: 1.5)),
        distanceBox(profile),
        BodyDivider(),
        ContactBody(profile: profile),
        ProfileHobbies(
            hobbies: profile.hobbyContainers,
            direction: HobbyDirection.discover),
        ProfileHobbies(
            hobbies: profile.hobbyContainers, direction: HobbyDirection.share),
        BodyDivider(),
        SizedBox(height: 15),
        Text("Bio", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        bio != null ? Text(bio) : Container(),
        SizedBox(height: 15),
        BodyDivider(),
        type == ProfileType.match
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Rate " + profileName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {
                            onThumbsDown(context, rating, profile);
                          },
                          color: returnColor(rating, 0)),
                      SizedBox(width: 25),
                      IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          onThumbsUp(context, rating, profile);
                        },
                        color: returnColor(rating, 1),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),

        SizedBox(height: 15),
      ],
    );
  }
}

Widget distanceBox(ProfileData profile) {
  String distance = profile.getProfileField("distance");
  if (distance == null || distance == "") {
    return Container();
  }

  return Row(
    children: <Widget>[
      Icon(
        Icons.location_on,
        color: Colors.grey,
        size: 16,
      ),
      Text(
        profile.getProfileField("distance"),
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );
}

/// the display of the hobbies
class ProfileHobbies extends StatelessWidget {
  const ProfileHobbies({
    Key key,
    @required this.direction,
    @required this.hobbies,
  }) : super(key: key);

  final HobbyDirection direction;
  final List<HobbyContainer> hobbies;

  @override
  Widget build(BuildContext context) {
    String title;

    switch (direction) {
      case HobbyDirection.share:
        title = "Sharing";
        break;
      case HobbyDirection.discover:
        title = "Discovering";
        break;
      default:
        title = "";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Center(
            child: HobbyChips(
          hobbies: hobbies,
          hobbyCategory: direction,
          alignment: WrapAlignment.center,
        )),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class ContactBody extends StatelessWidget {
  final ProfileData profile;

  ContactBody({
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    // ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
    final String email = profile.getProfileField("email");
    final String phone = profile.getProfileField("phone");

    if ((email == null || email == "") && (phone == null || phone == "")) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        contactEntry("Email", email),
        contactEntry("Phone", phone),
        BodyDivider(),
      ],
    );
  }
}

Widget contactEntry(String name, String entry) {
  if (entry == null) return Container();
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Text(
            name + ": ",
            style: bodyBold(),
          ),
          Text(entry)
        ],
      ),
      SizedBox(
        height: 8,
      ),
    ],
  );
}

TextStyle bodyBold() {
  return TextStyle(fontWeight: FontWeight.bold);
}

void onThumbsUp(BuildContext context, int existingRating, ProfileData profile) {
  print("thumbsup");
  if (existingRating != 1) {
    profile.rating = 1;
    // http.post(AppConfig.of(context).server + "matches/thumbs/up/" + userId);
    postAsync(context, "matches/thumbs/up/" + profile.userId);
    Navigator.pop(context);
  } else {
    profile.rating = -1;
    // http.delete(AppConfig.of(context).server + "matches/thumbs/" + userId);
    postAsync(context, "matches/thumbs/" + profile.userId, useDelete: true);
    Navigator.pop(context);
  }
}

void onThumbsDown(
    BuildContext context, int existingRating, ProfileData profile) {
  print("thumbsdown");
  if (existingRating != 0) {
    profile.rating = 0;
    // http.post(AppConfig.of(context).server + "matches/thumbs/down/" + userId);
    postAsync(context, "matches/thumbs/down/" + profile.userId);
    Navigator.pop(context);
  } else {
    profile.rating = -1;
    // http.delete(AppConfig.of(context).server + "matches/thumbs/" + userId);
    postAsync(context, "matches/thumbs/" + profile.userId, useDelete: true);
    Navigator.pop(context);
  }
}

Color returnColor(int rating, int thumbs) {
  // rating
  // -1 no rating
  // 0 thumbs down
  // 1 thumbs up

  // thumbs 'enum'
  // 0 thumbs down
  // 1 thumbs up

  // no rating
  if (rating == -1) {
    return Colors.grey;
  }

  // this is a thumbs down and we have rated thumbs down
  if (thumbs == 0 && rating == 0) {
    return Colors.redAccent;
  }

  // this is a thumbs down and we have rated thumbs down
  if (thumbs == 1 && rating == 1) {
    return Colors.blueAccent;
  }

  return Colors.grey;
}

class BodyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
    );
  }
}
