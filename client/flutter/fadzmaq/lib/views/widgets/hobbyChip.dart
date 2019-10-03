import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HobbyChips extends StatelessWidget {
  final List<HobbyContainer> hobbies;
  final HobbyDirection container;

  HobbyChips({
    @required this.hobbies,
    @required this.container,
  })  : assert(hobbies != null),
        assert(container != null);

  @override
  Widget build(BuildContext context) {
    List<HobbyInfo> listMyShare = new List<HobbyInfo>();
    List<HobbyInfo> listMyDiscover = new List<HobbyInfo>();
    List<HobbyInfo> listShare = new List<HobbyInfo>();
    List<HobbyInfo> listDiscover = new List<HobbyInfo>();

    // Get all the hobby data from the model
    if (hobbies != null) {
      for (HobbyContainer hc in hobbies) {
        // print(hc.container.toString());
        if (hc.container == "share") {
          for (HobbyData hobby in hc.hobbies) {
            listShare.add(HobbyInfo(hobby: hobby));
          }
        }
        if (hc.container == "discover") {
          for (HobbyData hobby in hc.hobbies) {
            listDiscover.add(HobbyInfo(hobby: hobby));
          }
        }
        if (hc.container == "my_share") {
          for (HobbyData hobby in hc.hobbies) {
            listMyShare.add(HobbyInfo(hobby: hobby));
          }
        }
        if (hc.container == "my_discover") {
          for (HobbyData hobby in hc.hobbies) {
            listMyDiscover.add(HobbyInfo(hobby: hobby));
          }
        }
      }
    }

    // highlight all hobbies in this share
    // that I am looking to discover
    for (HobbyInfo share in listShare) {
      for (HobbyInfo mine in listMyDiscover) {
        if (share.hobby == mine.hobby) {
          share.direction = HobbyDirection.discover;
        }
      }
    }

    // highlight all hobbies in this discover
    // that I am looking to share
    for (HobbyInfo discover in listDiscover) {
      for (HobbyInfo mine in listMyShare) {
        if (discover.hobby == mine.hobby) {
          discover.direction = HobbyDirection.share;
        }
      }
    }

    // special highlights
    for (HobbyInfo discover in listDiscover) {
      for (HobbyInfo share in listShare) {
        if (discover.hobby == share.hobby) {
          // Hobbies are highlighted if there is a two way match
          if (discover.direction != HobbyDirection.none &&
              share.direction != HobbyDirection.none) {
            discover.direction = HobbyDirection.match;
            share.direction = HobbyDirection.match;
          }
          // Hobbies are highlighted if there is one way match to a two way share/discover
          else if (discover.direction != HobbyDirection.none) {
            share.direction = HobbyDirection.share;
            // Hobbies are highlighted if there is one way match to a two way share/discover
          } else if (share.direction != HobbyDirection.none) {
            discover.direction = HobbyDirection.discover;
          }
        }
      }
    }

    List<Widget> list = new List<Widget>();
    List<HobbyInfo> toProccess;

    // prepare to convert the hobby info into a list of chips
    // different results depending on the container
    if (container == HobbyDirection.share) {
      toProccess = listShare;
    } else if (container == HobbyDirection.discover) {
      toProccess = listDiscover;
      // for matching exclude non matching and duplicates
    } else if (container == HobbyDirection.match) {
      toProccess = new List<HobbyInfo>();
      for (HobbyInfo info in listDiscover) {
        if (info.direction != HobbyDirection.none) {
          toProccess.add(info);
        }
      }
      for (HobbyInfo info in listShare) {
        if (info.direction != HobbyDirection.none &&
            !toProccess.contains(info)) {
          toProccess.add(info);
        }
      }
    }

    // make chips
    if (toProccess != null) {
      for (HobbyInfo info in toProccess) {
        list.add(HobbyChip(hobby: info));
      }
    }

    // return in wrap
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: list,
    );
  }
}

enum HobbyDirection {
  none,
  match,
  share,
  discover,
}

class HobbyInfo {
  final HobbyData hobby;
  HobbyDirection direction;

  HobbyInfo({
    this.hobby,
    this.direction = HobbyDirection.none,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HobbyInfo &&
            runtimeType == other.runtimeType &&
            hobby.id == other.hobby.id;
  }
}

class HobbyChip extends StatelessWidget {
  final HobbyInfo hobby;

  HobbyChip({
    this.hobby,
  });

  @override
  Widget build(BuildContext context) {
    // return Chip(
    //   label: Text(hobby.hobby.name, style: _hobbyStyle),
    //   backgroundColor: getColor(hobby.direction),
    //   // padding: EdgeInsets.all(0),
    //   labelPadding: EdgeInsets.all(0),
    //   avatar: CircleAvatar(
    //     child: Icon( Icons.ac_unit),
    //   ),

    // );

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: Stack(
        children: <Widget>[
          Container(
            color: getColor(hobby.direction, -0.17),
            height: 30,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 4, 10, 4),
              // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HobbyIconBackground(direction: hobby.direction),
                  Text(hobby.hobby.name, style: _hobbyStyle),
                ],
              ),
            ),
          ),
          HobbyDirectionIcon(direction: hobby.direction),
        ],
      ),
    );
  }
}

class HobbyIconBackground extends StatelessWidget {
  const HobbyIconBackground({
    this.direction,
  });

  final HobbyDirection direction;

  @override
  Widget build(BuildContext context) {
    if (direction == null || direction == HobbyDirection.none) {
      return SizedBox(
        width: 7,
      );
    }

    return Row(
      children: <Widget>[
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(direction, 0.1),
          ),
        ),
        SizedBox(
          width: 4,
        ),
      ],
    );
  }
}

class HobbyDirectionIcon extends StatelessWidget {
  const HobbyDirectionIcon({
    Key key,
    @required this.direction,
  }) : super(key: key);

  final HobbyDirection direction;

  @override
  Widget build(BuildContext context) {
    const double height = 30;
    const double size = 26;
    const shade = -0.2;

    final Widget discover = Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.5, 1, 0, 0),
        child: Icon(
          Icons.keyboard_arrow_left,
          color: getColor(direction, shade),
          size: size,
        ),
      ),
    );

    final Widget share = Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.5, 1, 0, 0),
        child: Icon(
          Icons.keyboard_arrow_right,
          color: getColor(direction, shade),
          size: size,
        ),
      ),
    );

    final Widget match = Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.8, 5.4, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: getColor(direction, shade),
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 5.8, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_left,
              color: getColor(direction, shade),
              size: 20,
            ),
          ),
        ],
      ),
    );

    switch (direction) {
      case HobbyDirection.discover:
        return discover;
      case HobbyDirection.match:
        return match;
      case HobbyDirection.share:
        return share;
      default:
        return Container(
          height: height,
          width: 0,
        );
    }
  }
}

Color getColor(HobbyDirection direction, double shade) {
  switch (direction) {
    case HobbyDirection.discover:
      return adjustShade(discoverC, shade);
    case HobbyDirection.share:
      return adjustShade(shareC, shade);
    case HobbyDirection.match:
      return adjustShade(matchC, shade);
    default:
      return Color(0xffb5b5b5);
  }
}

Color adjustShade(Color col, double shade) {
  HSLColor hsl = HSLColor.fromColor(col);

  double lightness = hsl.lightness + shade;
  lightness = max(0, lightness);
  lightness = min(1, lightness);

  HSLColor result = HSLColor.fromAHSL(1, hsl.hue, hsl.saturation, lightness);

  return result.toColor();
}

Color matchC = Color(0xffB980FF);
Color discoverC = Color(0xffeb769f);
Color shareC = Color(0xff80B7FF);

// Color purple = Color(0xff947bff);
// Color red = Color(0xffff5785);
// Color blue = Color(0xff73aeff);

// Color purpleD = Color(0xffa861ff);
// Color redD = Color(0xffee2961);
// Color blueD = Color(0xff4fa2ff);

final TextStyle _hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
