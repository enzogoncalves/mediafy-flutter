// ignore_for_file: non_constant_identifier_names

class Movie {
  Movie({ required this.media }){
    id = media["id"];
    adult = media["adult"];
    backdrop_path = media["backdrop_path"];
    genre_ids = media["genre_ids"];
    original_language = media["original_language"];
    original_title= media["original_title"];
    overview = media["overview"];
    poster_path = media["poster_path"];
    release_date = media["release_date"];
    title = media["title"];
  }

  final Map<String, dynamic> media;

  String? poster_path;
  int? id;
  String? original_title;
  bool? adult;
  String? backdrop_path;
  List? genre_ids;
  String? homepage;
  String? original_language;
  String? overview;
  String? release_date;
  String? title; 
}

class MovieDetails extends Movie {
  MovieDetails({ required this.movie }) : super(media: movie){
    revenue = movie["revenue"];
    runtime = movie["runtime"];
    tagline = movie["tagline"];
    budget = movie["budget"];

    List a = movie["genres"];
    
    genres = a.map((e) {
      return Genre(id: e["id"], name: e["name"]);
    }).toList();

    production_companies = movie["production_companies"].map((e) {
      return ProductionCompanie(production_companie: e);
    }).toList();
    status = movie["status"];
  }
  
  final Map<String, dynamic> movie;

  int? revenue;
  int? runtime;
  String? tagline;
  int? budget;
  List<Genre>? genres;
  List<dynamic>? production_companies;
  String? status;
}

class ProductionCompanie {
  ProductionCompanie({ required this.production_companie }) {
    id = production_companie["id"];
    logo_path = production_companie["logo_path"];
    name = production_companie["name"];
    origin_country = production_companie["origin_country"];
  }

  final Map<String, dynamic> production_companie;

  int? id;
  String? logo_path;
  String? name;
  String? origin_country;
}

class Genre {
  Genre({ required this.id, required this.name });

  int id;
  String name;
}