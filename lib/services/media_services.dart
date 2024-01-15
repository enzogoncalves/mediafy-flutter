import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? apiKey = dotenv.env["TMDB_API_KEY"];

class MediaServices {
  Future<List<Movie>> getTopRatedMovies() async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US&page=1&region=US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('results')) {
        List moviesData = data["results"];

        List<Movie> movies = (moviesData).map((item) => Movie(media: item)).toList();

        return movies;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    final url = Uri.parse("https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('results')) {
        List moviesData = data["results"];

        List<Movie> movies = (moviesData).map((item) => Movie(media: item)).toList();

        return movies;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final url = Uri.parse("https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&include_adult=false&include_video=false&language=en-US&page=1&primary_release_date.gte=2023-12-25&sort_by=popularity.desc");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('results')) {
        List moviesData = data["results"];

        List<Movie> movies = (moviesData).map((item) => Movie(media: item)).toList();

        movies.map((e) => e.backdrop_path != null);

        return movies;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=en-US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      MovieDetails movieDetails = MovieDetails(movie: data);

      return movieDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Keyword>> getMovieKeywords(int movieId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId/keywords?api_key=$apiKey");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List keywordsList = data["keywords"];

      List<Keyword> keywords = keywordsList.map((e) => Keyword(keyword: e)).toList();

      return keywords;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$apiKey&language=en-US&page=1");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List movies = data["results"];

      List<Movie> movieRecommendations = movies.map((e) => Movie(media: e)).toList();

      return movieRecommendations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey&language=en-US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      Map<String, List> formatedCredit = {"cast": [], "crew": []};

      if (data.containsKey("cast")) {
        List castData = data["cast"];

        List<Cast> cast = castData.map((item) => Cast(character: item["character"], id: item["id"], name: item["name"], profile_path: item["profile_path"])).toList();
        formatedCredit["cast"] = cast;
      }

      if (data.containsKey("crew")) {
        List crewData = data["crew"];

        for (var i = 0; i < crewData.length; i++) {
          int? crewIndex;

          List elementsIndex = formatedCredit["crew"]!.where((element) => element["name"] == crewData[i]["name"]).toList();

          bool found = !listEquals([], elementsIndex);

          if (!found) {
            // Not Found: create a new entry
            formatedCredit["crew"] = [
              ...formatedCredit["crew"]!,
              {
                "name": crewData[i]["name"],
                "jobs": [crewData[i]["job"]]
              }
            ];
          } else {
            // Found: insert the jobs in the arrays
            crewIndex = formatedCredit["crew"]!.indexOf(elementsIndex[0]);
            formatedCredit["crew"]![crewIndex]["jobs"].add(crewData[i]["job"]);
          }
        }
      }
      formatedCredit["crew"]!.sort((a, b) => b["jobs"].length - a["jobs"].length);

      List<Crew> crew = formatedCredit["crew"]!.map((item) => Crew(jobs: item["jobs"], name: item["name"])).toList();

      formatedCredit["crew"] = crew;

      return formatedCredit;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TvShow>> getTopRatedTvShows() async {
    final url = Uri.parse("https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=en-US&page=1&region=US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('results')) {
        List tvShowsData = data["results"];

        List<TvShow> tvShows = (tvShowsData).map((item) => TvShow(tvShow: item)).toList();

        return tvShows;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TvShow>> getTrendingTvShows() async {
    final url = Uri.parse("https://api.themoviedb.org/3/trending/tv/day?api_key=$apiKey");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('results')) {
        List tvShowsData = data["results"];

        List<TvShow> tvShows = (tvShowsData).map((item) => TvShow(tvShow: item)).toList();

        return tvShows;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<TvShowDetails> getTvShowDetails(int tvShowId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/tv/$tvShowId?api_key=$apiKey&language=en-US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      TvShowDetails tvShowsDetails = TvShowDetails(tvShow: data);

      return tvShowsDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Keyword>> getTvShowKeywords(int tvShowId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/tv/$tvShowId/keywords?api_key=$apiKey");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List keywordsList = data["results"];

      List<Keyword> keywords = keywordsList.map((e) => Keyword(keyword: e)).toList();

      return keywords;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TvShow>> getTvShowRecommendations(int tvShowId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/tv/$tvShowId/recommendations?api_key=$apiKey&language=en-US&page=1");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List movies = data["results"];

      List<TvShow> movieRecommendations = movies.map((e) => TvShow(tvShow: e)).toList();

      return movieRecommendations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getTvShowCredits(int tvShowId) async {
    final url = Uri.parse("https://api.themoviedb.org/3/tv/$tvShowId/credits?api_key=$apiKey&language=en-US");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      Map<String, List> formatedCredit = {"cast": [], "crew": []};

      if (data.containsKey("cast")) {
        List castData = data["cast"];

        List<Cast> cast = castData.map((item) => Cast(character: item["character"], id: item["id"], name: item["name"], profile_path: item["profile_path"])).toList();
        formatedCredit["cast"] = cast;
      }

      if (data.containsKey("crew")) {
        List crewData = data["crew"];

        for (var i = 0; i < crewData.length; i++) {
          int? crewIndex;

          List elementsIndex = formatedCredit["crew"]!.where((element) => element["name"] == crewData[i]["name"]).toList();

          bool found = !listEquals([], elementsIndex);

          if (!found) {
            // Not Found: create a new entry
            formatedCredit["crew"] = [
              ...formatedCredit["crew"]!,
              {
                "name": crewData[i]["name"],
                "jobs": [crewData[i]["job"]]
              }
            ];
          } else {
            // Found: insert the jobs in the arrays
            crewIndex = formatedCredit["crew"]!.indexOf(elementsIndex[0]);
            formatedCredit["crew"]![crewIndex]["jobs"].add(crewData[i]["job"]);
          }
        }
      }
      formatedCredit["crew"]!.sort((a, b) => b["jobs"].length - a["jobs"].length);

      List<Crew> crew = formatedCredit["crew"]!.map((item) => Crew(jobs: item["jobs"], name: item["name"])).toList();

      formatedCredit["crew"] = crew;

      return formatedCredit;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> search(String mediaType, String query) async {
    final url = Uri.parse("https://api.themoviedb.org/3/search/$mediaType?api_key=$apiKey&language=en-US&query=$query&include_adult=false");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List searchResults = data["results"];

      if (mediaType == "movie") {
        List<Movie> movies = searchResults.map((e) => Movie(media: e)).toList();
        return movies;
      } else {
        List<TvShow> tvShows = searchResults.map((e) => TvShow(tvShow: e)).toList();
        return tvShows;
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
