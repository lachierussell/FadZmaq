import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';

class HobbyChips extends StatelessWidget {
  final List<HobbyContainer> hobbies;
  final String container;

  HobbyChips({
    @required this.hobbies,
    @required this.container,
  })  : assert(hobbies != null),
        assert(container != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();
    // print(profile.hobbyContainers.toString());
    if (hobbies != null) {
      for (HobbyContainer hc in hobbies) {
        // print(hc.container.toString());
        if (hc.container == container) {
          for (HobbyData hobby in hc.hobbies) {
            list.add(HobbyChip(hobby: hobby));
          }
        }
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

class HobbyChip extends StatelessWidget {
  final HobbyData hobby;

  HobbyChip({
    this.hobby,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: Container(
        color: Color(0xfff2f2f2),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
            child: new Text(hobby.name, style: _hobbyStyle)),
      ),
    );
  }
}

final TextStyle _hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
