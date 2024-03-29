import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/profile_body.dart';
import 'package:fadzmaq/views/widgets/likePassButtons.dart';
import 'package:fadzmaq/views/widgets/unmatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/models/profile.dart';

enum ProfileType { own, match, recommendation }

class ProfileAppbar extends StatelessWidget {
  final String uid;
  final ProfileType type;

  ProfileAppbar({
    @required this.uid,
    @required this.type,
  })  : assert(uid != null),
        assert(type != null);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: type == ProfileType.match
          ? <Widget>[
              PopupMenuButton(
                onSelected: (result) async {
                  if (result == "Unmatch") {
                    bool unmatched = await unmatchDialog(context, uid);
                    if (unmatched == true) {
                      Navigator.pop(context);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: "Unmatch",
                    child: Text("Unmatch"),
                  ),
                ],
                onCanceled: () {
                  print("You have canceled the menu.");
                },
              )
            ]
          : null,
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String url;
  final ProfileData profile;
  final ProfileType type;

  const ProfilePage({
    Key key,
    @required this.url,
    this.profile,
    @required this.type,
  })  : assert(url != null),
        assert(type != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // As we only pass profile data we convert it into a container
    // final ProfileContainer container =
    //     (profile != null) ? ProfileContainer(profile: profile) : null;

    return Scaffold(
      body: ProfilePageState(
        type: type,
        profile: profile,
      ),
      // GetRequest<ProfileContainer>(
      //   url: url,
      //   model: container,
      //   builder: (context) {
      //     return ProfilePageState(type: type);
      //   },
      // ),
      floatingActionButton:
          profile != null && type == ProfileType.recommendation
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LikeButton(profile: profile, type: LikePass.pass),
                    Expanded(
                      child: Container(
                        height: 10,
                      ),
                    ),
                    LikeButton(profile: profile, type: LikePass.like),
                  ],
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ProfilePageState extends StatelessWidget {
  final ProfileType type;
  final ProfileData profile;

  ProfilePageState({
    @required this.profile,
    @required this.type,
  }) : assert(type != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // Extra container in case screen is turned
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.shortestSide,
                        height: MediaQuery.of(context).size.shortestSide,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: DisplayPhoto(
                            url: profile.photo,
                            dimension: MediaQuery.of(context).size.shortestSide,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: ProfileBody(type: type, profile: profile),
                  ),
                  type == ProfileType.recommendation
                      ? SizedBox(height: 140)
                      : Container(),
                ],
              ),
            ),
            ProfileAppbar(
              uid: profile.userId,
              type: type,
            ),
          ],
        ),
      ),
    );
  }
}
