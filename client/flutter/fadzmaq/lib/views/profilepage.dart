import 'package:fadzmaq/views/widgets/profile_body.dart';
import 'package:fadzmaq/views/widgets/recommendationButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  const ProfilePage({
    Key key,
    this.url,
    this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileContainer container =
        (profile != null) ? ProfileContainer(profile: profile) : null;

    return Scaffold(
      body: GetRequest<ProfileContainer>(
        url: url,
        model: container,
        builder: (context) {
          return ProfilePageState();
        },
      ),
      floatingActionButton: profile != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LikeButton(id: profile.userId),
                Expanded(
                  child: Container(
                    height: 10,
                  ),
                ),
                LikeButton(id: profile.userId),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// todo make this a proper reuseable widget
class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData profile = RequestProvider.of<ProfileContainer>(context).profile;

    return CachedNetworkImage(
      imageUrl: profile.photo,
      fit: BoxFit.cover,
      // placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }
}

class ProfilePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ProfilePic(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: ProfileBody(),
                  ),
                  // TODO match this to the size of the like/pass buttons
                  // and only show if they are present
                  SizedBox(height: 100,)
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
