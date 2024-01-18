class Crew {
  Crew({ required this.name, required this.jobs });

  final String? name;
  final List<dynamic>? jobs;

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      jobs: json["jobs"] as List<dynamic>?,
      name: json["name"] as String?
    );
  }
}