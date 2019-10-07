import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:fadzmaq/views/widgets/hobbyIcons.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// An encapsulation of [HobbyData] used in displaying hobby chips
/// [direction] is used to indicate the shading of a hobby chip
/// [index] is unused at the moment but enables unique shading between hobbies
class HobbyInfo {
  final HobbyData hobby;
  HobbyDirection direction;
  int index;

  HobbyInfo({
    this.hobby,
    this.direction = HobbyDirection.none,
    this.index = 0,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HobbyInfo && hobby.id == other.hobby.id ||
        other is HobbyData && hobby.id == other.id;
  }

  @override
  int get hashCode {
    return hobby.id;
  }
}

/// A chip display of a hobby
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
            color: getChipColor(
                direction: hobby.direction,
                shade: backgroundShade,
                index: hobby.index),
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
                        color: getChipColor(
                          direction: hobby.direction,
                          shade: textShade,
                        ),
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

Color getChipColor({
  HobbyDirection direction = HobbyDirection.none,
  double shade = 0,
  int index = 0,
}) {
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

Color adjustShade(
  Color col,
  double shade,
) {
  HSLColor hsl = HSLColor.fromColor(col);

  double lightness = hsl.lightness + shade;
  double saturation = hsl.saturation;
  double hue = hsl.hue;

  lightness = max(0, lightness);
  lightness = min(1, lightness);

  // hue = max(0, hue);
  // hue = min(360, hue);

  HSLColor result = HSLColor.fromAHSL(1, hue, saturation, lightness);

  return result.toColor();
}

const double backgroundShade = 0.05;
const double iconShade = -0.3;
const double textShade = -0.4;
const Color matchC = Color(0xffcfbbe5);
const Color discoverC = Color(0xffe8b5c5);
const Color shareC = Color(0xffb9cee8);
const Color noneC = Color(0xffcbcbcb);

// const double backgroundShade = 0.1;
// const double iconShade = -0.2;
// const double textShade = -0.4;
// Color matchC = Color(0xffB980FF);
// Color matchC = Color(0xffb193ff);
// Color discoverC = Color(0xffeb769f);
// Color shareC = Color(0xff80B7FF);
// Color noneC = Color(0xffb5b5b5);

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
