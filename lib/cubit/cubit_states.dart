import 'package:equatable/equatable.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';
import 'package:mediafy/screens/movie_screen.dart';

abstract class CubitStates extends Equatable {}

class InitialState extends CubitStates {
  @override
  List<Object> get props => [];
}

class MoviesState extends CubitStates {
  MoviesState({ required this.trendingMovies, required this.topRatedMovies, required this.upcomingMovies });

  List<Movie> trendingMovies;
  List<Movie> topRatedMovies;
  List<Movie> upcomingMovies;

  @override
  List<Object> get props => [];
}

class TvShowsState extends CubitStates {
  TvShowsState({ required this.trendingTvShows, required this.topRatedTvShows });
  
  List<TvShow> trendingTvShows;
  List<TvShow> topRatedTvShows;

  @override
  List<Object> get props => [];
}

class MovieState extends CubitStates {
  MovieState({ required this.movieId, required this.details, required this.cast, required this.crew, required this.keywords, required this.recommendations });

  int movieId;
  MovieDetails details;
  List<Cast> cast;
  List<Crew> crew;
  List<Keyword> keywords;
  List<Movie> recommendations;

  @override
  List<Object> get props => [movieId];
}

class TvShowState extends CubitStates {
  TvShowState({ required this.tvShowId, required this.details, required this.cast, required this.crew, required this.keywords, required this.recommendations });

  int tvShowId;
  TvShowDetails details;
  List<Cast> cast;
  List<Crew> crew;
  List<Keyword> keywords;
  List<TvShow> recommendations;

  @override
  List<Object> get props => [tvShowId];
}

class LoadingState extends CubitStates {
  @override
  List<Object> get props => [];
}

class SearchPageState extends CubitStates {
  @override
  List<Object> get props => [];
}