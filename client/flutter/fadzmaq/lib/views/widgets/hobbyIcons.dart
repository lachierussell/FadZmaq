import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';

/// The circle shown in hobby chips
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
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getChipColor(direction: direction, shade: iconShade),
          ),
        ),
        SizedBox(
          width: 4,
        ),
      ],
    );
  }
}

/// The icon shown on hobby chips
class HobbyDirectionIcon extends StatelessWidget {
  const HobbyDirectionIcon({
    Key key,
    @required this.direction,
  }) : super(key: key);

  final HobbyDirection direction;

  @override
  Widget build(BuildContext context) {
    const double height = 24;
    const double size = 22;
    const shade = 0.1;

    // The following are returned with a swtich below

    // Discover icon
    final Widget discover = Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
        child: Icon(
          Icons.keyboard_arrow_left,
          color: getChipColor(direction: direction, shade: shade),
          size: size,
        ),
      ),
    );

    // Share icon
    final Widget share = Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(1.5, 1, 0, 0),
        child: Icon(
          Icons.keyboard_arrow_right,
          color: getChipColor(direction: direction, shade: shade),
          size: size,
        ),
      ),
    );

    // match icon
    final Widget match = Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 4, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: getChipColor(direction: direction, shade: shade),
              size: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 4.25, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_left,
              color: getChipColor(direction: direction, shade: shade),
              size: 16,
            ),
          ),
        ],
      ),
    );

    // switch to return the above
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
