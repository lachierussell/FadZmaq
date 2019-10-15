import 'package:cached_network_image/cached_network_image.dart';
import 'package:fadzmaq/controllers/imageCache.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:flutter/material.dart';

/// Displays a users profile photo
/// Uses [CachedNetworkImage]
class DisplayPhoto extends StatelessWidget {
  final String url;
  final double dimension;

  DisplayPhoto({
    this.url,
    @required this.dimension,
  }) : assert(dimension != null);

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return SizedBox(
        height: dimension,
        width: dimension,
      );
    }
    GlobalModel globalModel = getModel(context);
    final String dimensionedURL = photoThumbURL(globalModel.devicePixelRatio, url, dimension);
    // print("displaying: " + url);

    return SizedBox(
      height: dimension,
      width: dimension,
      child: CachedNetworkImage(
        fadeInDuration: const Duration(seconds: 0),
        height: dimension,
        width: dimension,
        imageUrl: dimensionedURL,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        // placeholder: (context, url) => Container(color: Colors.grey),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }
}
