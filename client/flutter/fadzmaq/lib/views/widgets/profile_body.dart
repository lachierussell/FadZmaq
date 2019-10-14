import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/controllers/profile.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:http/http.dart' as http;
import 'package:fadzmaq/models/app_config.dart';

/// Helper (method?) to the ProfileFieldWidget.
/// Builds a list of Text from the Profile data.
/// @param context  The BuildContext from the ProfileFieldWidget
/// @return A list of Text objects.
List<Widget> profileFieldRender(context) {
  ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
  List<Widget> rows =
      pd.profileFields.map((item) => new Text(item.displayValue)).toList();
  return rows;
}

/// Dynamically builds/renders the profile fields section of the Profile page.
/// It will draw every field that is sent to it. It also ignores anything that
/// isn't sent. E.g. If it is a match, it will render contact details, but if
/// it is a recommendation, it will not.
class ProfileFieldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: profileFieldRender(context)));
  }
}

class ProfileBody extends StatelessWidget {
  final ProfileType type;
  const ProfileBody({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;

    // putting these up here in case of nulls
    // right now just putting dash instead of the value
    // final String profileAge = pd.age != null ? pd.age : "-";
    final String profileName = pd.name != null ? pd.name : "-";
    final int rating = pd.rating;
    final String bio = getProfileField(pd, "bio");
    print(rating);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 15.0),
        Text(profileName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 42.0, height: 1.5)),

        type == ProfileType.match
            ? Row(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: () {
                      onThumbsDown(context, rating, pd.userId);
                    },
                    color: returnColor(rating, 0)),
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    onThumbsUp(context, rating, pd.userId);
                  },
                  color: returnColor(rating, 1),
                ),
              ])
            : Row(),
        BodyDivider(),
        ContactBody(),
        ProfileHobbies(
            hobbies: pd.hobbyContainers, direction: HobbyDirection.discover),
        ProfileHobbies(
            hobbies: pd.hobbyContainers, direction: HobbyDirection.share),
        BodyDivider(),
        Text("5km away"),
        SizedBox(
          height: 15,
        ),
        bio != null ? Text(bio) : Container(),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

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
        SizedBox(
          height: 8,
        ),
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
  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
    final String email = getProfileField(pd, "email");
    final String phone = getProfileField(pd, "phone");

    if (email == null && phone == null) {
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

void onThumbsUp(BuildContext context, int rating, String userId) {
  print("thumbsup");
  if (rating != 1) {
    http.post(AppConfig.of(context).server + "matches/thumbs/up/" + userId);
    Navigator.pop(context);
  } else {
    http.delete(AppConfig.of(context).server + "matches/thumbs/" + userId);
    Navigator.pop(context);
  }
}

void onThumbsDown(BuildContext context, int rating, String userId) {
  print("thumbsdown");
  if (rating != 0) {
    http.post(AppConfig.of(context).server + "matches/thumbs/down/" + userId);
    Navigator.pop(context);
  } else {
    http.delete(AppConfig.of(context).server + "matches/thumbs/" + userId);
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
    return Colors.blueAccent;
  }

  // this is a thumbs down and we have rated thumbs down
  if (thumbs == 1 && rating == 1) {
    return Colors.redAccent;
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
