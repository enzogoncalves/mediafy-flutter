import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';
import 'package:mediafy/pages/search_page.dart';
import 'package:mediafy/services/media_services.dart';

class AppCubit extends Cubit<CubitStates> {
  AppCubit({required this.media}) : super(InitialState()) {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final Connectivity _connectivity = Connectivity();

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      print("Here!");
      emit(InternetErrorState());
    } else {
      print("Here 2");
      if (lastCubitState != null) {
        emit(lastCubitState!);
      } else {
        emit(WelcomeState());
      }
    }
  }

  MediaServices media;
  MoviesState finalMoviesState = MoviesState(topRatedMovies: const [], trendingMovies: const [], upcomingMovies: const [], hasData: false);

  CubitStates? lastCubitState;

  void goToMoviesPage() {
    if (finalMoviesState.hasData) {
      lastCubitState = finalMoviesState;
      emit(finalMoviesState);
      return;
    }

    emit(finalMoviesState);

    Future.wait([media.getTopRatedMovies(), media.getTrendingMovies(), media.getUpcomingMovies()]).then((value) {
      MoviesState movieState = MoviesState(topRatedMovies: value[0], trendingMovies: value[1], upcomingMovies: value[2], hasData: true);

      emit(movieState);

      finalMoviesState.topRatedMovies = value[0];
      finalMoviesState.trendingMovies = value[1];
      finalMoviesState.upcomingMovies = value[2];
      finalMoviesState.hasData = true;

      lastCubitState = finalMoviesState;
    }).catchError((e) {
      print(e);

      emit(InternetErrorState());
    });
  }

  TvShowsState finalTvShowsState = TvShowsState(trendingTvShows: const [], topRatedTvShows: const [], hasData: false);

  void goToTvSeriesPage() {
    if (finalTvShowsState.hasData) {
      lastCubitState = finalTvShowsState;
      emit(finalTvShowsState);
      return;
    }

    emit(finalTvShowsState);

    Future.wait([media.getTrendingTvShows(), media.getTopRatedTvShows()]).then((value) {
      TvShowsState tvShowsState = TvShowsState(trendingTvShows: value[0], topRatedTvShows: value[1], hasData: true);

      emit(tvShowsState);

      finalTvShowsState.trendingTvShows = value[0];
      finalTvShowsState.topRatedTvShows = value[1];
      finalTvShowsState.hasData = true;

      lastCubitState = finalTvShowsState;
    }).catchError((e) {
      emit(InternetErrorState());
    });
  }

  List<MovieState> moviesInCache = [];

  Future<void> showMoviePage(int movieId) async {
    String primitiveState = "";

    if (state is MoviesState) {
      primitiveState = "MoviesState";
    } else if (state is SearchPageState) {
      primitiveState = "SearchPageState";
    }

    emit(LoadingMovie());

    try {
      List movieData = await Future.wait([media.getMovieDetails(movieId), media.getMovieCredits(movieId), media.getMovieKeywords(movieId), media.getMovieRecommendations(movieId)]);

      MovieDetails details = movieData[0] as MovieDetails;
      Map<String, dynamic> credits = movieData[1] as Map<String, dynamic>;

      List<Cast> cast = credits['cast'];
      List<Crew> crew = credits['crew'];

      List<Keyword> keywords = movieData[2] as List<Keyword>;
      List<Movie> recommendations = movieData[3] as List<Movie>;

      MovieState movieState = MovieState(movieId: movieId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations, primitiveState: primitiveState);

      moviesInCache.add(movieState);

      lastCubitState = movieState;
      emit(movieState);
    } catch (e) {
      print(e);

      emit(InternetErrorState());
    }
  }

  void backToPreviousMovie() {
    String moviePrimitiveState = moviesInCache[moviesInCache.length - 1].primitiveState;

    moviesInCache.removeLast();

    if (moviesInCache.isEmpty) {
      if (moviePrimitiveState == "MoviesState") {
        goToMoviesPage();
      } else if (moviePrimitiveState == "SearchPageState") {
        goToSearchPage();
      }
      return;
    } else {
      lastCubitState = moviesInCache.last;
      emit(moviesInCache.last);
    }
  }

  List<TvShowState> tvShowsInCache = [];

  Future<void> showTvShowPage(int tvShowId) async {
    String primitiveState = "";

    if (state is TvShowsState) {
      primitiveState = "TvShowsState";
    } else if (state is SearchPageState) {
      primitiveState = "SearchPageState";
    }

    emit(LoadingTvShow());

    try {
      List tvShowData = await Future.wait([media.getTvShowDetails(tvShowId), media.getTvShowCredits(tvShowId), media.getTvShowKeywords(tvShowId), media.getTvShowRecommendations(tvShowId)]);

      TvShowDetails details = tvShowData[0] as TvShowDetails;
      Map<String, dynamic> credits = tvShowData[1] as Map<String, dynamic>;

      List<Cast> cast = credits['cast'];
      List<Crew> crew = credits['crew'];

      List<Keyword> keywords = tvShowData[2] as List<Keyword>;
      List<TvShow> recommendations = tvShowData[3] as List<TvShow>;

      TvShowState tvShowState = TvShowState(tvShowId: tvShowId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations, primitiveState: primitiveState);

      tvShowsInCache.add(tvShowState);

      lastCubitState = tvShowState;
      emit(tvShowState);
    } catch (e) {
      print(e);

      emit(InternetErrorState());
    }
  }

  void backToPreviousTvShow() {
    String tvShowPrimitiveState = tvShowsInCache[tvShowsInCache.length - 1].primitiveState;

    tvShowsInCache.removeLast();

    if (tvShowsInCache.isEmpty) {
      if (tvShowPrimitiveState == "TvShowsState") {
        goToTvSeriesPage();
      } else if (tvShowPrimitiveState == "SearchPageState") {
        goToSearchPage();
      }
      return;
    } else {
      lastCubitState = tvShowsInCache.last;
      emit(tvShowsInCache.last);
    }
  }

  SearchPageState finalSearchPageState = SearchPageState(query: "", movies: const [], tvShows: const [], mediaType: "movie", hasData: false);

  void goToSearchPage() {
    SearchPageState searchPageState = SearchPageState(query: finalSearchPageState.query, movies: finalSearchPageState.movies, tvShows: finalSearchPageState.tvShows, mediaType: finalSearchPageState.mediaType, hasData: finalSearchPageState.hasData);
    lastCubitState = searchPageState;
    emit(searchPageState);
  }

  searchQuery(String mediaType, String query) async {
    // verify if the user has already searched the same query with the same media type (movie or tv show) and return the same result (does nothing)
    if (query == finalSearchPageState.query) {
      if (mediaType == "movie" && finalSearchPageState.movies.isNotEmpty) {
        return;
      } else if (mediaType == "tv" && finalSearchPageState.tvShows.isNotEmpty) {
        return;
      }
    }

    try {
      List result = await media.search(mediaType, query);

      finalSearchPageState.query = query;
      finalSearchPageState.hasData = true;

      if (mediaType == "movie") {
        List<Movie> movies = result as List<Movie>;
        finalSearchPageState.movies = movies;
        finalSearchPageState.tvShows = [];
      } else if (mediaType == "tv") {
        List<TvShow> tvShows = result as List<TvShow>;
        finalSearchPageState.tvShows = tvShows;
        finalSearchPageState.movies = [];
      }

      SearchPageState searchPageState = SearchPageState(query: finalSearchPageState.query, movies: finalSearchPageState.movies, tvShows: finalSearchPageState.tvShows, mediaType: finalSearchPageState.mediaType, hasData: finalSearchPageState.hasData);
      emit(searchPageState);
    } catch (e) {
      print(e);
      emit(InternetErrorState());
    }
  }
}
