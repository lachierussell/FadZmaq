import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';

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
    // get list to show
    // get list to compare

    // for each in show
    // for each in compare
    // if equal record

    // do twice

    // for each in one
    // for each in two
    // if the same record for both

    // one
    // return one

    // two
    // return two

    // matches
    // for each in one add
    // for each in two check if already in one
    // if in change one
    // else add two

    List<HobbyInfo> listMyShare = new List<HobbyInfo>();
    List<HobbyInfo> listMyDiscover = new List<HobbyInfo>();
    List<HobbyInfo> listShare = new List<HobbyInfo>();
    List<HobbyInfo> listDiscover = new List<HobbyInfo>();

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

    for (HobbyInfo share in listShare) {
      for (HobbyInfo mine in listMyDiscover) {
        if (share.hobby == mine.hobby) {
          share.direction = HobbyDirection.discover;
        }
      }
    }

    for (HobbyInfo discover in listDiscover) {
      for (HobbyInfo mine in listMyShare) {
        if (discover.hobby == mine.hobby) {
          discover.direction = HobbyDirection.share;
        }
      }
    }

    for (HobbyInfo discover in listDiscover) {
      for (HobbyInfo share in listShare) {
        if (discover.hobby == share.hobby &&
            discover.direction != HobbyDirection.none &&
            share.direction != HobbyDirection.none) {
          discover.direction = HobbyDirection.match;
          share.direction = HobbyDirection.match;
        } else {}
      }
    }

    List<Widget> list = new List<Widget>();

    List<HobbyInfo> toProccess;
    if (container == HobbyDirection.share) {
      print("share");
      toProccess = listShare;
    } else if (container == HobbyDirection.discover) {
      print("discover");
      toProccess = listDiscover;
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

    if (toProccess != null) {
      for (HobbyInfo info in toProccess) {
        list.add(HobbyChip(hobby: info));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: new Wrap(
        spacing: 4,
        runSpacing: 4,
        children: list,
      ),
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: Container(
        color: getColor(hobby.direction),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
            child: new Text(hobby.hobby.name, style: _hobbyStyle)),
      ),
    );
  }
}

Color getColor(HobbyDirection direction) {
  switch (direction) {
    case HobbyDirection.discover:
      return Colors.red;
    case HobbyDirection.share:
      return Colors.blue;
    case HobbyDirection.match:
      return Colors.purple;
    default:
      return Color(0xffd9d9d9);
  }
}

final TextStyle _hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
