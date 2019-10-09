import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/profile_body.dart';
import 'package:fadzmaq/views/widgets/recommendationButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ProfileType { own, match, recommendation }

class ProfileAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String url;
  final ProfileData profile;
  final UserProfileContainer userData;
  final ProfileType type;

  const ProfilePage({
    Key key,
    @required this.url,
    this.profile,
    this.userData,
    @required this.type,
  })  : assert(url != null),
        assert(type != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // As we only pass profile data we convert it into a container
    final ProfileContainer container =
        (profile != null) ? ProfileContainer(profile: profile) : null;

    return Scaffold(
      body: GetRequest<ProfileContainer>(
        url: url,
        model: container,
        builder: (context) {
          return GetRequest<UserProfileContainer>(
            url: "profile",
            model: userData,
            builder: (context) {
              return ProfilePageState(type: type);
            },
          );
        },
      ),
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

  ProfilePageState({
    @required this.type,
  })  : assert(type != null);

  @override
  Widget build(BuildContext context) {


  ProfileContainer pc = RequestProvider.of<ProfileContainer>(context);
  ProfileData profile = pc.profile;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              // margin: const EdgeInsets.only(top: 80),
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
                          child: DisplayPhoto(url: profile.photo),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: ProfileBody(type: this.type,),
                  ),
                  type == ProfileType.recommendation
                      ? SizedBox(height: 140)
                      : Container(),
                ],
              ),
            ),
            ProfileAppbar(),
          ],
        ),
      ),
    );
  }
}
