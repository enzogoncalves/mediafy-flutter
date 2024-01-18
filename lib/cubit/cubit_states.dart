import 'package:equatable/equatable.dart';
import 'package:tmdb_api/tmdb_api.dart';

abstract class CubitStates extends Equatable {}

class InitialState extends CubitStates {
  @override
  List<Object> get props => [];
}

class WelcomeState extends CubitStates {
  @override
  List<Object> get props => [];
}

class MoviesState extends CubitStates {
  MoviesState({required this.trendingMovies, required this.topRatedMovies, required this.upcomingMovies, required this.hasData});

  List<Movie> trendingMovies;
  List<Movie> topRatedMovies;
  List<Movie> upcomingMovies;
  bool hasData;

  @override
  List<Object> get props => [trendingMovies, topRatedMovies, upcomingMovies, hasData];
}

class TvShowsState extends CubitStates {
  TvShowsState({required this.trendingTvShows, required this.topRatedTvShows, required this.hasData});

  List<TvShow> trendingTvShows;
  List<TvShow> topRatedTvShows;
  bool hasData;

  @override
  List<Object> get props => [trendingTvShows, topRatedTvShows, hasData];
}

class MovieState extends CubitStates {
  MovieState({required this.movieId, required this.details, required this.cast, required this.crew, required this.keywords, required this.recommendations, required this.primitiveState});

  final int movieId;
  final MovieDetails details;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<Keyword> keywords;
  final List<Movie> recommendations;
  final String primitiveState;

  @override
  List<Object> get props => [movieId, details, cast, crew, keywords, recommendations];
}

class LoadingMovie extends CubitStates {
  @override
  List<Object> get props => [];
}

class TvShowState extends CubitStates {
  TvShowState({required this.tvShowId, required this.details, required this.cast, required this.crew, required this.keywords, required this.recommendations, required this.primitiveState});

  final int tvShowId;
  final TvShowDetails details;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<Keyword> keywords;
  final List<TvShow> recommendations;
  final String primitiveState;

  @override
  List<Object> get props => [tvShowId];
}

class LoadingTvShow extends CubitStates {
  @override
  List<Object> get props => [];
}

class SearchPageState extends CubitStates {
  SearchPageState({required this.query, required this.movies, required this.tvShows, required this.mediaType, required this.hasData});

  String query;
  List<Movie> movies;
  List<TvShow> tvShows;
  String mediaType;
  bool hasData;

  @override
  List<Object> get props => [query, movies, tvShows, mediaType, hasData];
}

class InternetErrorState extends CubitStates {
  InternetErrorState();

  @override
  List<Object> get props => [];
}
