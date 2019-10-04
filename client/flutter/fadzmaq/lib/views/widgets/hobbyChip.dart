import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:fadzmaq/views/widgets/hobbyIcons.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
        other is HobbyInfo && hobby.id == other.hobby.id ||
        other is HobbyData && hobby.id == other.id;
  }

  @override
  int hashCode() {
    return hobby.id;
  }
}

class HobbyChip extends StatelessWidget {
  final HobbyInfo hobby;

  HobbyChip({
    this.hobby,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          child: Container(
            height: 24,
            color: getColor(hobby.direction, 0.1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 10, 3),
              // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HobbyIconBackground(direction: hobby.direction),
                  Text(hobby.hobby.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: getColor(hobby.direction, -0.4),
                      )),
                ],
              ),
            ),
          ),
        ),
        HobbyDirectionIcon(direction: hobby.direction),
      ],
    );
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
      return adjustShade(noneC, shade);
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

// Color matchC = Color(0xffB980FF);
Color matchC = Color(0xffb193ff);
Color discoverC = Color(0xffeb769f);
Color shareC = Color(0xff80B7FF);
Color noneC = Color(0xffb5b5b5);

// Color purple = Color(0xff947bff);
// Color red = Color(0xffff5785);
// Color blue = Color(0xff73aeff);

// Color purpleD = Color(0xffa861ff);
// Color redD = Color(0xffee2961);
// Color blueD = Color(0xff4fa2ff);

// final TextStyle _hobbyStyle = TextStyle(
//   fontSize: 14,
//   fontWeight: FontWeight.w400,
//   color: Colors.black,
// );
