import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:flutter/material.dart';

enum HobbyDirection {
  none,
  match,
  share,
  discover,
}

class HobbyChips extends StatelessWidget {
  final List<HobbyContainer> hobbies;
  final HobbyDirection hobbyCategory;

  HobbyChips({
    @required this.hobbies,
    @required this.hobbyCategory,
  })  : assert(hobbies != null),
        assert(hobbyCategory != null);

  @override
  Widget build(BuildContext context) {
    List<HobbyData> listMyShare;
    List<HobbyData> listMyDiscover;
    List<HobbyInfo> listShare = new List<HobbyInfo>();
    List<HobbyInfo> listDiscover = new List<HobbyInfo>();

    // any request using hobby chips should have a user profile container request
    // to compare the hobbies to.
    UserProfileContainer pc = RequestProvider.of<UserProfileContainer>(context);

    if (pc == null) return Container();

    ProfileData pd = pc.profile;

    if (pd == null) return Container();
    if (pd.hobbyContainers == null) return Container();
    if (hobbies == null) return Container();

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
      }
    }

    if (pd.hobbyContainers != null) {
      for (HobbyContainer hc in pd.hobbyContainers) {
        // print(hc.container.toString());
        if (hc.container == "share") {
          listMyShare = hc.hobbies;
        }
        if (hc.container == "discover") {
          listMyDiscover = hc.hobbies;
        }
      }
    }

    // highlight all hobbies in this share
    // that I am looking to discover
    for (HobbyInfo share in listShare) {
      for (HobbyData mine in listMyDiscover) {
        if (share.hobby == mine) {
          share.direction = HobbyDirection.discover;
        }
      }
    }

    // highlight all hobbies in this discover
    // that I am looking to share
    for (HobbyInfo discover in listDiscover) {
      for (HobbyData mine in listMyShare) {
        if (discover.hobby == mine) {
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
    if (hobbyCategory == HobbyDirection.share) {
      toProccess = listShare;
    } else if (hobbyCategory == HobbyDirection.discover) {
      toProccess = listDiscover;
      // for matching exclude non matching and duplicates
    } else if (hobbyCategory == HobbyDirection.match) {
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
