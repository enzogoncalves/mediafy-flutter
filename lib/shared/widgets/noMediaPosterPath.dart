import 'package:flutter/material.dart';

class NoMediaPosterPath extends StatelessWidget {
  const NoMediaPosterPath({super.key, required this.height, required this.isMovie});

  final double height;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: height / 1.5,
        height: height,
        child: Center(
          child: Icon(
            isMovie ? Icons.movie_creation_outlined : Icons.tv,
            color: Colors.grey[700],
            size: 102,
          ),
        ));
  }
}
