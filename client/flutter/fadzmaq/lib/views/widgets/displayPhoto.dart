import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fadzmaq/controllers/cache.dart';
import 'package:flutter/material.dart';

/// Displays a users profile photo
class DisplayPhoto extends StatelessWidget {
  String url;
  final double dimension;

  DisplayPhoto({
    this.url,
    @required this.dimension,
  }) : assert(dimension != null);

  @override
  Widget build(BuildContext context) {
    // print(url);

    // https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Sam_Neill_2010.jpg/1080px-Sam_Neill_2010.jpg
    // https://upload.wikimedia.org/wikipedia/commons/6/61/Sam_Neill_2010.jpg

    if (url == null) {
      return SizedBox(
        height: dimension,
        width: dimension,
      );
    }

    url = photoThumbURL(context, url, dimension);
    print("displaying: " + url);

    return SizedBox(
      height: dimension,
      width: dimension,
      child: CachedNetworkImage(
        fadeInDuration: const Duration(seconds: 0),
        height: dimension,
        width: dimension,
        imageUrl: url,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        // placeholder: (context, url) => Container(color: Colors.grey),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }
}
