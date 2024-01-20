import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/screens/welcome_screen.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<CubitStates> {
  AppCubit({required this.tmdbApi}) : super(InitialState()) {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final Connectivity _connectivity = Connectivity();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      emit(InternetErrorState());
    } else {
      if (lastCubitState != null) {
        emit(lastCubitState!);
      } else {
        final SharedPreferences prefs = await _prefs;
        bool? prefsFirstInitialization = prefs.getBool(prefsFirstInitializationKey);

        if (prefsFirstInitialization != null) {
          if (prefsFirstInitialization) {
            emit(WelcomeState());
          } else {
            await goToMoviesPage();
          }
        } else {
          emit(WelcomeState());
        }
      }
    }
  }

  Future<void> changeFirstInitialization() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(prefsFirstInitializationKey, false);

    await goToMoviesPage();
  }

  String prefsFirstInitializationKey = "firstInitialization";
  TmdbApi tmdbApi;
  MoviesState finalMoviesState = MoviesState(topRatedMovies: const [], trendingMovies: const [], upcomingMovies: const [], hasData: false);

  CubitStates? lastCubitState;

  Future<void> goToMoviesPage() async {
    if (state is MoviesState) {
      await getAllMoviesData();

      return;
    }
    if (finalMoviesState.hasData) {
      lastCubitState = finalMoviesState;
      emit(finalMoviesState);
      return;
    }

    emit(finalMoviesState);

    await getAllMoviesData();
  }

  Future<void> getAllMoviesData() async {
    Future.wait([tmdbApi.getTopRatedMovies(), tmdbApi.getTrendingMovies(), tmdbApi.getUpcomingMovies()]).then((value) {
      MoviesState moviesState = MoviesState(topRatedMovies: value[0], trendingMovies: value[1], upcomingMovies: value[2], hasData: true);

      emit(moviesState);

      finalMoviesState.topRatedMovies = value[0];
      finalMoviesState.trendingMovies = value[1];
      finalMoviesState.upcomingMovies = value[2];
      finalMoviesState.hasData = true;

      lastCubitState = finalMoviesState;
    }).catchError((e) {
      TmdbError tmdbError = TmdbError(response: e.toString());
      verifyErrorCode(tmdbError);
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

    Future.wait([tmdbApi.getTrendingTvShows(), tmdbApi.getTopRatedTvShows()]).then((value) {
      TvShowsState tvShowsState = TvShowsState(trendingTvShows: value[0], topRatedTvShows: value[1], hasData: true);

      emit(tvShowsState);

      finalTvShowsState.trendingTvShows = value[0];
      finalTvShowsState.topRatedTvShows = value[1];
      finalTvShowsState.hasData = true;

      lastCubitState = finalTvShowsState;
    }).catchError((e) {
      TmdbError tmdbError = TmdbError(response: e.toString());
      verifyErrorCode(tmdbError);
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
      List movieData = await Future.wait([tmdbApi.getMovieDetails(movieId), tmdbApi.getMovieCredits(movieId), tmdbApi.getMovieKeywords(movieId), tmdbApi.getMovieRecommendations(movieId)]);

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
      TmdbError tmdbError = TmdbError(response: e.toString());
      verifyErrorCode(tmdbError);
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
      List tvShowData = await Future.wait([tmdbApi.getTvShowDetails(tvShowId), tmdbApi.getTvShowCredits(tvShowId), tmdbApi.getTvShowKeywords(tvShowId), tmdbApi.getTvShowRecommendations(tvShowId)]);

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
      TmdbError tmdbError = TmdbError(response: e.toString());
      verifyErrorCode(tmdbError);
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
    // verify if the user has already searched the same query with the same tmdbApi type (movie or tv show) and return the same result (does nothing)
    if (query == finalSearchPageState.query) {
      if (mediaType == "movie" && finalSearchPageState.movies.isNotEmpty) {
        return;
      } else if (mediaType == "tv" && finalSearchPageState.tvShows.isNotEmpty) {
        return;
      }
    }

    try {
      List result = await tmdbApi.search(mediaType, query);

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
      TmdbError tmdbError = TmdbError(response: e.toString());
      verifyErrorCode(tmdbError);
    }
  }

  void verifyErrorCode(TmdbError tmdbError) {
    emit(ServerErrorState(tmdbError: tmdbError));
  }
}
