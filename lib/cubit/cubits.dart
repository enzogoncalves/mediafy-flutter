import 'package:bloc/bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';
import 'package:mediafy/services/media_services.dart';

class AppCubit extends Cubit<CubitStates> {
  AppCubit({ required this.media}) : super(InitialState()) {
    emit(WelcomeState());
  }

  MediaServices media;

  MoviesState finalMoviesState = MoviesState(topRatedMovies: [], trendingMovies: [], upcomingMovies: [], hasData: false);

  goToMoviesPage() {
    if(finalMoviesState.hasData) {
      emit(finalMoviesState); 
      return;
    }

    emit(finalMoviesState);
    
    Future.wait([
      media.getTopRatedMovies(),
      media.getTrendingMovies(),
      media.getUpcomingMovies()
    ]).then((value) {
      MoviesState movieState = MoviesState(topRatedMovies: value[0], trendingMovies: value[1], upcomingMovies: value[2], hasData: true);
      
      emit(movieState);

      finalMoviesState.topRatedMovies = value[0];
      finalMoviesState.trendingMovies = value[1];
      finalMoviesState.upcomingMovies = value[2];
      finalMoviesState.hasData = true;
    });
  }

  TvShowsState finalTvShowsState = TvShowsState(trendingTvShows: [], topRatedTvShows: [], hasData: false);

  goToTvSeriesPage() {
    if(finalTvShowsState.hasData) {
      emit(finalTvShowsState);
      return;
    }

    emit(finalTvShowsState);

    Future.wait([
      media.getTrendingTvShows(),
      media.getTopRatedTvShows()
    ]).then((value) {
      TvShowsState tvShowsState = TvShowsState(trendingTvShows: value[0], topRatedTvShows: value[1], hasData: true);

      emit(tvShowsState);

      finalTvShowsState.trendingTvShows = value[0];
      finalTvShowsState.topRatedTvShows = value[1];
      finalTvShowsState.hasData = true;
    });
  }

  List<MovieState> moviesInCache = [];

  showMoviePage(int movieId) async {
    String primitiveState = "";

    if(state is MoviesState) {
      primitiveState = "MoviesState";
    } else if(state is SearchPageState) {
      primitiveState = "SearchPageState";
    }

    emit(LoadingMovie());
    
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

    MovieState movieState = MovieState(movieId: movieId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations, primitiveState: primitiveState);

    moviesInCache.add(movieState);

    emit(movieState);
  }

  backToPreviousMovie() {
    String moviePrimitiveState = moviesInCache[moviesInCache.length - 1].primitiveState;

    moviesInCache.removeLast();

    if(moviesInCache.isEmpty) {
      if(moviePrimitiveState == "MoviesState") {
        goToMoviesPage();
      } else if(moviePrimitiveState == "SearchPageState") {
        goToSearchPage();
      }
      return;
    } else {
      emit(moviesInCache.last);
    }
  }

  List<TvShowState> tvShowsInCache = [];

  showTvShowPage(int tvShowId) async {
    String primitiveState = "";

    if(state is TvShowsState) {
      primitiveState = "TvShowsState";
    } else if(state is SearchPageState) {
      primitiveState = "SearchPageState";
    }

    emit(LoadingTvShow());

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

    TvShowState tvShowState = TvShowState(tvShowId: tvShowId, details: details, cast: cast, crew: crew, keywords: keywords, recommendations: recommendations, primitiveState: primitiveState);

    tvShowsInCache.add(tvShowState);

    emit(tvShowState);
  }

  backToPreviousTvShow() {
    String tvShowPrimitiveState = tvShowsInCache[tvShowsInCache.length - 1].primitiveState;

    tvShowsInCache.removeLast();

    if(tvShowsInCache.isEmpty) {
      if(tvShowPrimitiveState == "TvShowsState") {
        goToTvSeriesPage();
      } else if(tvShowPrimitiveState == "SearchPageState") {
        goToSearchPage();
      }
      return;
    } else {
      emit(tvShowsInCache.last);
    }
  }

  SearchPageState finalSearchPageState = SearchPageState(query: "", movies: [], tvShows: [], mediaType: "movie", hasData: false);

  goToSearchPage() {
    emit(SearchPageState(query: finalSearchPageState.query, movies: finalSearchPageState.movies, tvShows: finalSearchPageState.tvShows, mediaType: finalSearchPageState.mediaType, hasData: finalSearchPageState.hasData));
  }


  searchQuery(String mediaType, String query) async {
    // verify if the user has already searched the same query with the same media type (movie or tv show) and return the same result (does nothing)
    if(query == finalSearchPageState.query) {
      if(mediaType == "movie" && finalSearchPageState.movies.isNotEmpty) {
        return;
      } else if(mediaType == "tv" && finalSearchPageState.tvShows.isNotEmpty) {
        return;
      }
    }
    
    List result = await media.search(mediaType, query);

    finalSearchPageState.query = query;
    finalSearchPageState.hasData = true;

    if(mediaType == "movie") {
      List<Movie> movies = result as List<Movie>;
      finalSearchPageState.movies = movies;
      finalSearchPageState.tvShows = [];
    } else if(mediaType == "tv") {
      List<TvShow> tvShows = result as List<TvShow>;
      finalSearchPageState.tvShows = tvShows;
      finalSearchPageState.movies = [];
    }

    emit(SearchPageState(query: finalSearchPageState.query, movies: finalSearchPageState.movies, tvShows: finalSearchPageState.tvShows, mediaType: finalSearchPageState.mediaType, hasData: finalSearchPageState.hasData));
  } 
}