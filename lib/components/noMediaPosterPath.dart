import 'package:flutter/material.dart';

class NoMediaPosterPath extends StatelessWidget {
  const NoMediaPosterPath({super.key, required this.posterHeight, required this.isMovie});

  final double posterHeight;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: posterHeight / 1.5,
      height: posterHeight,
      child: Center(
        child: Icon(isMovie ? Icons.movie_creation_outlined : Icons.tv, color: Colors.grey[700], size: 102,),
      )
    );
  }
}