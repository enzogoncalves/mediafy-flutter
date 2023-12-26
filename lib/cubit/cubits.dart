import 'package:bloc/bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';
import 'package:mediafy/screens/movie_screen.dart';
import 'package:mediafy/services/media_services.dart';

class AppCubit extends Cubit<CubitStates> {
  AppCubit({ required this.media}) : super(InitialState()) {
    goToMoviesPage();
  }


  MediaServices media;
  List<Movie>? topRatedMovies;
  List<Movie>? trendingMovies;
  List<Movie>? upcomingMovies;


  List<TvShow>? trendingTvShows;
  List<TvShow>? topRatedTvShows;

  goToMoviesPage() {
    if(topRatedMovies != null) {
      emit(MoviesState(topRatedMovies: topRatedMovies!, trendingMovies: trendingMovies!, upcomingMovies: upcomingMovies!)); 
      return;
    }
  
    emit(LoadingState());
    
    Future.wait([
      media.getTopRatedMovies(),
      media.getTrendingMovies(),
      media.getUpcomingMovies()
    ]).then((value) {
      topRatedMovies = value[0];
      trendingMovies = value[1];
      upcomingMovies = value[2];
      
      emit(MoviesState(topRatedMovies: topRatedMovies!, trendingMovies: trendingMovies!, upcomingMovies: upcomingMovies!)); 
    });
  }

  goToTvSeriesPage() {
    emit(LoadingState());

    if(trendingTvShows != null && topRatedTvShows != null) {
      emit(TvShowsState(trendingTvShows: trendingTvShows!, topRatedTvShows: topRatedTvShows!));
      return;
    }

    Future.wait([
      media.getTrendingTvShows(),
      media.getTopRatedTvShows()
    ]).then((value) {
      trendingTvShows = value[0];
      topRatedTvShows = value[1];

      emit(TvShowsState(trendingTvShows: trendingTvShows!, topRatedTvShows: topRatedTvShows!));
    });
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
      emit(MovieState(movieId: movieId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations));
    } else if (currentState == "MovieState") {
      MovieState recommendationMovie = MovieState(movieId: movieId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations);
      emit(recommendationMovie);
    }
  }

  showTvShowPage(int tvShowId) async {
    late String currentState;

    if(this.state is TvShowsState) {
      currentState = "TvShowsState";
    } else if (this.state is TvShowState) {
      currentState = "TvShowState";
    }

    emit(LoadingState());

    List tvShowData = await Future.wait([
      media.getTvShowDetails(tvShowId), 
      media.getTvShowCredits(tvShowId), 
      media.getTvShowKeywords(tvShowId), 
      media.getTvShowRecommendations(tvShowId)
    ]);

    TvShowDetails details = tvShowData[0] as TvShowDetails;
    Map<String, dynamic> credits = tvShowData[1] as Map<String, dynamic>;

    List<Cast> cast = credits['cast'];
    List<Crew> crew = credits['crew'];

    List<Keyword> keywords = tvShowData[2] as List<Keyword>;
    List<TvShow> recommendations = tvShowData[3] as List<TvShow>;

    if(currentState == "TvShowsState") {
      emit(TvShowState(tvShowId: tvShowId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations));
    } else if (currentState == "TvShowState") {
      TvShowState recommendationTvShow = TvShowState(tvShowId: tvShowId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations);
      emit(recommendationTvShow);
    }
  }

  goToSearchPage() {
    emit(SearchPageState());
  }
}