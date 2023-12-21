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

  Map<String, dynamic> formatDate(String releaseDate) {
    Map<String, dynamic> dateData;
    if (releaseDate.length == 10) {
      dateData = {
        "year": releaseDate.split('-')[0],
        "date": '${releaseDate.split('-')[1]}/${releaseDate.split('-')[2]}/${releaseDate.split('-')[0]}'
      };
    } else {
      List date = releaseDate.substring(0, releaseDate.indexOf('T')).split('-');
      int day = date[2];
      int year = date[0];
      List<String> months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      String month = months[date[1] - 1];

      dateData = {
        "date": '$month $day, $year'
      };
    }

    return dateData;
  }

  String formatGenres(List<Genre>? genres) {
    String genreString = '';
    genres!.forEach((genre) => {
      if (genres.indexOf(genre) == genres.length - 1) {
        genreString += '${genre.name}'
      } else {
        genreString += '${genre.name}, '
      }
    });

    return genreString;
  }

  String formatMediaDuration(int? runtime) {
    int hours = (runtime! / 60).floor();
    int minutes = runtime - (hours * 60);

    if (minutes == 0) {
      return '${hours}h';
    } else if (hours == 0) {
      return '${minutes}m';
    } else {
      return '${hours}h ${minutes}m';
    }
  }

  String transformReleaseDate(releaseDate) {
    List<String> date =releaseDate.split('-'); 
    int day = int.parse(date[2]);
    dynamic month = int.parse(date[1]);
    int year = int.parse(date[0]);
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    month = months[month - 1];

    int currentYear = DateTime.now().year;

    if (currentYear != year) {
      return '$day $month, $year';
    } else {
      return '$day $month';
    }
  }

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