import 'movie_model.dart';

class MediaFunctions {
  Map<String, dynamic> formatDate(String releaseDate) {
    Map<String, dynamic> dateData;
    if (releaseDate.length == 10) {
      dateData = {"year": releaseDate.split('-')[0], "date": '${releaseDate.split('-')[1]}/${releaseDate.split('-')[2]}/${releaseDate.split('-')[0]}'};
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

      dateData = {"date": '$month $day, $year'};
    }

    return dateData;
  }

  String formatGenres(List<Genre>? genres) {
    String genreString = '';
    genres!.forEach((genre) {
      if (genres.indexOf(genre) == genres.length - 1) {
        genreString += genre.name;
      } else {
        genreString += '${genre.name}, ';
      }
    });

    return genreString;
  }

  String transformReleaseDate(releaseDate) {
    List<String> date = releaseDate.split('-');
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
}
