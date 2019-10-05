import 'package:fadzmaq/main.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:http/http.dart' as http;
import 'package:fadzmaq/models/app_config.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
var globUrl = "";
bool isFavourite = true;
/// Helper (method?) to the ProfileFieldWidget.
/// Builds a list of Text from the Profile data.
/// @param context  The BuildContext from the ProfileFieldWidget
/// @return A list of Text objects.
List<Widget> profileFieldRender(context){
    ProfileData pd = RequestProvider.of<ProfileData>(context);
    List<Widget>rows = pd.profileFields.map((item) => new Text(item.displayValue)).toList();
    return rows;
}

String printOut() {
  print(globUrl);
  return globUrl.substring(8,globUrl.length);
}

/// Dynamically builds/renders the profile fields section of the Profile page.
/// It will draw every field that is sent to it. It also ignores anything that
/// isn't sent. E.g. If it is a match, it will render contact details, but if
/// it is a recommendation, it will not.
class ProfileFieldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child:
      Column(
        children: profileFieldRender(context)
      )
    );
  }
}



class ProfileTempApp extends StatelessWidget {
  const ProfileTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String url;

  const ProfilePage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globUrl = url;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: GetRequest<ProfileData>(
        url: url,
        builder: (context) {
          return ProfilePageState();
        },
      ),
    );
  }
}

// todo make this a proper reuseable widget
class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileData profile = RequestProvider.of<ProfileData>(context);

    return CachedNetworkImage(
      imageUrl: profile.photo,
      fit: BoxFit.cover,
      // placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      
    );
  }
}

class ProfilePageState extends StatelessWidget {
  // String _status = 'no-action';

  @override
  Widget build(BuildContext context) {
    isFavourite = false;
    ProfileData pd = RequestProvider.of<ProfileData>(context);
    String server = AppConfig.of(context).server;
    final Color color1 = Color(0xffCCFC6D);
    final Color color2 = Color(0xff2ACDDF);

    // putting these up here in case of nulls
    // right now just putting dash instead of the value
    // final String profileAge = pd.age != null ? pd.age : "-";
    final String profileName = pd.age != null ? pd.name : "-";

    String hobbiesRaw = "";

    print(pd.hobbyContainers.toString());

    if (pd.hobbyContainers != null) {
      for (HobbyContainer hc in pd.hobbyContainers) {
        hobbiesRaw += "--" + hc.container + "--\n";
        if (hc.hobbies != null) {
          for (HobbyData h in hc.hobbies) {
            hobbiesRaw += h.name + "\n";
          }
        }
      }
    }

    // final String image = 'assets/images/glenn.jpg';
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 240,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                  gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
            ),
            Container(
              // margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 20.0),
                  // Expanded(
                  // child: Stack(
                  // children: <Widget>[
                  Container(
                    // height: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 5.0, bottom: 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      // child: Image.asset(image,fit: BoxFit.cover,),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ProfilePic(),
                      ),
                    ),
                  ),
                  // ],
                  // ),
                  // ),
                  //SizedBox(height: 15.0),
                  Text(
                    profileName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        height: 10.0),
                  ),
                  Text(
                    hobbiesRaw,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  ProfileFieldWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      Text(
                        "Perth, Western Australia, Australia",
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        color: Colors.grey,
                        icon: Icon(CupertinoIcons.photo_camera),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: Colors.grey,
                        icon: Icon(CupertinoIcons.fullscreen),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: Colors.grey.shade600,
                        icon: Icon(CupertinoIcons.game_controller),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 16.0),
                          margin: const EdgeInsets.only(
                              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color1, color2],
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(CupertinoIcons.person_solid),
                                  onPressed: () {}),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.location_on),
                                onPressed: () {},
                              ),
                              Spacer(),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.add),
                                onPressed: () {},
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.message),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: FloatingActionButton(
                            child: isFavourite ? Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            ) : Icon(
                              Icons.favorite,
                              color: Colors.black,
                            ) ,
                            backgroundColor: Colors.white,
                            onPressed: () {Navigator.pop(context); post(server +'matches/thumbs/up/' + printOut(), ""); },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
