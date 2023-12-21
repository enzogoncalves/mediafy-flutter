import 'package:bloc/bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/screens/movie_screen.dart';
import 'package:mediafy/services/media_services.dart';

class AppCubit extends Cubit<CubitStates> {
  AppCubit({ required this.media}) : super(InitialState()) {
    emit(LoadingState());
    Future.wait([media.getTopRatedMovies(), media.getTrendingMovies(), media.getUpcomingMovies()]).then((value) {
      topRatedMovies = value[0];
      trendingMovies = value[1];
      upcomingMovies = value[2];

      emit(MoviesState(topRatedMovies: topRatedMovies, trendingMovies: trendingMovies, upcomingMovies: upcomingMovies));
    });
  }


  MediaServices media;
  late List<Movie> topRatedMovies;
  late List<Movie> trendingMovies;
  late List<Movie> upcomingMovies;

  goToHomePage() {
    emit(MoviesState(topRatedMovies: topRatedMovies, trendingMovies: trendingMovies, upcomingMovies: upcomingMovies));
  }

  showMoviePage(int movieId) async {
    late String currentState;

    if(this.state is MoviesState) {
      currentState = "MoviesState";
    } else if (this.state is MovieState) {
      currentState = "MovieState";
    }

    emit(LoadingState());

    List movieData = await Future.wait([
      media.getMovieDetails(movieId), 
      media.getMovieCredits(movieId), 
      media.getMovieKeywords(movieId), 
      media.getMovieRecommendations(movieId)
    ]);

    MovieDetails details = movieData[0] as MovieDetails;
    Map<String, dynamic> credits = movieData[1] as Map<String, dynamic>;

    List<Cast> cast = credits['cast'];
    List<Crew> crew = credits['crew'];

    List<Keyword> keywords = movieData[2] as List<Keyword>;
    List<Movie> recommendations = movieData[3] as List<Movie>;

    if(currentState == "MoviesState") {
      emit(MovieState(details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations));
    } else if (currentState == "MovieState") {
      MovieState recommendationMovie = MovieState(details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations);
      emit(recommendationMovie);
    }
  }
}