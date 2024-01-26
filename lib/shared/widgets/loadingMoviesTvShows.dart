import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMoviesTvShows extends StatelessWidget {
  const LoadingMoviesTvShows({
    super.key,
    required this.itemCount
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: itemCount,
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemBuilder: (context, index) {
            return Container(
              height: 180,
              color: Colors.grey[700],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red,)
              ),
            );
          },
        )
      ),
    );
  }
}