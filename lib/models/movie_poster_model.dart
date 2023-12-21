import 'package:mediafy/models/movie_model.dart';

class MoviePoster {
  MoviePoster({ required this.movie });

  Movie movie;

  String? poster_path;
  int? id;
  String? original_title;

  Map<String, dynamic> toMap() {
    return {
      "id": movie.id,
      "poster_path": movie.poster_path,
      "original_title": movie.original_title
    };
  }
}