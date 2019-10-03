import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/controllers/profile.dart';
import 'package:flutter/material.dart';

/// Helper (method?) to the ProfileFieldWidget.
/// Builds a list of Text from the Profile data.
/// @param context  The BuildContext from the ProfileFieldWidget
/// @return A list of Text objects.
List<Widget> profileFieldRender(context) {
  ProfileData pd = RequestProvider.of<ProfileData>(context);
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
    ProfileData pd = RequestProvider.of<ProfileData>(context);

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
        Text("Discovering", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
            child: Wrap(
          spacing: 5.0,
          runSpacing: 3.0,
          children: <Widget>[getHobbies(context, pd, "discover")],
        )),
        SizedBox(
          height: 15,
        ),
        Text("Sharing", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
            child: Wrap(
          spacing: 5.0,
          runSpacing: 3.0,
          children: <Widget>[getHobbies(context, pd, "share")],
        )),
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

class ContactBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData pd = RequestProvider.of<ProfileData>(context);
    final String email = getProfileField(pd, "email");
    final String phone = getProfileField(pd, "phone");

    if (email == null && phone == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 8,),
        contactEntry("Email", email),
        contactEntry("Phone", phone),
        BodyDivider(),
      ],
    );
  }
}

Widget contactEntry (String name, String entry){
  if(entry == null) return Container();
  return Column(
    children: <Widget>[
      Row(
                children: <Widget>[Text(name + ": ", style: bodyBold(),), Text(entry)],
              ),
              SizedBox(height: 8,),
    ],
  );
}

TextStyle bodyBold(){
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

Widget getHobbies(BuildContext context, ProfileData profile, String container) {
  List<Widget> list = new List<Widget>();
  // print(profile.hobbyContainers.toString());
  if (profile.hobbyContainers != null) {
    for (HobbyContainer hc in profile.hobbyContainers) {
      print(hc.container.toString());
      if (hc.container == container) {
        for (HobbyData hobby in hc.hobbies) {
          list.add(getHobbyChip(context, hobby));
        }
      }
    }
  }
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: new Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list,
    ),
  );
}

Widget getHobbyChip(BuildContext context, HobbyData hobby) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    child: Container(
      color: Color(0xfff2f2f2),
      child: Padding(
          // padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
          child: new Text(hobby.name)),
    ),
  );
}
