// ignore_for_file: non_constant_identifier_names
import 'package:mediafy/models/movie_model.dart';

class TvShow {
  TvShow({required this.tvShow}) {
    id = tvShow["id"];
    backdrop_path = tvShow["backdrop_path"];
    genre_ids = tvShow["genre_ids"];
    name = tvShow["name"];
    original_language = tvShow["original_language"];
    original_name = tvShow["original_name"];
    overview = tvShow["overview"];
    poster_path = tvShow["poster_path"];
    first_air_date = tvShow["first_air_date"];
  }

  final Map<String, dynamic> tvShow;

  int? id;
  String? backdrop_path;
  List? genre_ids;
  String? name;
  String? original_language;
  String? original_name;
  String? overview;
  String? poster_path;
  String? first_air_date;
}

class TvShowDetails extends TvShow {
  TvShowDetails({required Map<String, dynamic> tvShow}) : super(tvShow: tvShow) {
    episode_run_time = tvShow["episode_run_time"];
    tagline = tvShow["tagline"];
    List a = tvShow["genres"];
    first_air_date = tvShow["first_air_date"];
    number_of_episodes = tvShow["number_of_episodes"];
    number_of_seasons = tvShow["number_of_seasons"];

    genres = a.map((e) {
      return Genre(id: e["id"], name: e["name"]);
    }).toList();

    production_companies = tvShow["production_companies"].map((e) {
      return ProductionCompanie(production_companie: e);
    }).toList();

    status = tvShow["status"];
  }

  List<dynamic>? episode_run_time;
  String? tagline;
  List<Genre>? genres;
  List<dynamic>? production_companies;
  String? status;
  String? first_air_date;
  int? number_of_episodes;
  int? number_of_seasons;
}
