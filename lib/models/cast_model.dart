class Cast {
  Cast({
    required this.id,
    required this.profile_path,
    required this.name,
    required this.character,
  });

  final int? id;
  final String? profile_path;
  final String? name;
  final String? character;

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as int?,
      profile_path: json['profile_path'] as String?,
      name: json['name'] as String?,
      character: json['character'] as String?,
    );
  }
}