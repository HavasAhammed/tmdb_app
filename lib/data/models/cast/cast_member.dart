class CastMember {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;
  final int? order;

  CastMember({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
    this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    profilePath: json['profile_path'],
    character: json['character'],
    order: json['order'],
  );
}
