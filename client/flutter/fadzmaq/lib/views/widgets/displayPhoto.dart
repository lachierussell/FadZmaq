import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



// TODO unify this
class DisplayPhoto extends StatelessWidget {
  final String url;
  final double dimension;

  DisplayPhoto({
    this.url,
    this.dimension,
  });

  @override
  Widget build(BuildContext context) {
    print(url);

    return SizedBox(
      height: dimension,
      width: dimension,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        // placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }
}