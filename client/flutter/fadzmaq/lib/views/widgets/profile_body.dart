import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/controllers/profile.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';

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
  const ProfileBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;

    // putting these up here in case of nulls
    // right now just putting dash instead of the value
    // final String profileAge = pd.age != null ? pd.age : "-";
    final String profileName = pd.name != null ? pd.name : "-";

    final String bio = getProfileField(pd, "bio");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 15.0),
        Text(profileName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 42.0, height: 1.5)),
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
        Center(child: HobbyChips(hobbies: hobbies, hobbyCategory: direction, alignment: WrapAlignment.center,)),
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

class BodyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
    );
  }
}
