import 'package:equatable/equatable.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/movie_model.dart';
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

class MovieState extends CubitStates {
  MovieState({ required this.details, required this.cast, required this.crew, required this.keywords, required this.recommendations });

  MovieDetails details;
  List<Cast> cast;
  List<Crew> crew;
  List<Keyword> keywords;
  List<Movie> recommendations;

  @override
  List<Object> get props => [details, cast, crew, keywords, recommendations];
}

class LoadingState extends CubitStates {
  @override
  List<Object> get props => [];
}