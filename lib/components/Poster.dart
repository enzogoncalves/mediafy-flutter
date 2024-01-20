import 'package:flutter/material.dart';
import 'package:mediafy/components/noMediaPosterPath.dart';

class Poster extends StatelessWidget {
  const Poster({
    super.key,
    required this.posterPath,
    required this.height,
    this.width,
  });

  final double height;
  final double? width;
  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    if (posterPath != null) {
      return Container(
          margin: const EdgeInsets.only(right: 8),
          width: width ?? height / 1.5,
          height: height,
          child: FadeInImage(
            placeholder: const AssetImage("assets/loader.png"),
            image: NetworkImage(
              "https://image.tmdb.org/t/p/w300$posterPath",
            ),
          ));
    } else {
      return NoMediaPosterPath(height: height, isMovie: true);
    }
  }
}
