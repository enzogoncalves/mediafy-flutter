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
  MoviesState({ required this.trendingMovies, required this.topRatedMovies, required this.upcomingMovies, required this.hasData });

  List<Movie> trendingMovies;
  List<Movie> topRatedMovies;
  List<Movie> upcomingMovies;
  bool hasData;

  @override
  List<Object> get props => [];
}

class TvShowsState extends CubitStates {
  TvShowsState({ required this.trendingTvShows, required this.topRatedTvShows, required this.hasData });
  
  List<TvShow> trendingTvShows;
  List<TvShow> topRatedTvShows;
  bool hasData;

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
  SearchPageState({ required this.query, required this.movies, required this.tvShows, required this.mediaType, required this.hasData });

  String query;
  List<Movie> movies;
  List<TvShow> tvShows;
  String mediaType;
  bool hasData;

  @override
  List<Object> get props => [query, movies, tvShows, mediaType, hasData];
}