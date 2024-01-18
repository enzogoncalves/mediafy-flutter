class Keyword {
  Keyword({ required this.keyword }) {
    id = keyword["id"];
    name = keyword["name"];
  }

  Map<String, dynamic> keyword;

  late int id;
  late String name;
}