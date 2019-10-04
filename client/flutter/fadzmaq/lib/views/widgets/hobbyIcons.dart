import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';

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
            color: getColor(direction, -0.2),
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
    const double height = 24;
    const double size = 22;
    const shade = 0.1;

    final Widget discover = Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
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
        padding: EdgeInsets.fromLTRB(2, 1, 0, 0),
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
            padding: const EdgeInsets.fromLTRB(7, 4, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: getColor(direction, shade),
              size: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 4.25, 0, 0),
            child: Icon(
              Icons.keyboard_arrow_left,
              color: getColor(direction, shade),
              size: 16,
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
