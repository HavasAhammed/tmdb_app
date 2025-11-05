import 'package:tmdb_app/data/models/cast/cast_member.dart';

class MovieCredits {
  final List<CastMember> cast;

  MovieCredits({required this.cast});

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((x) => CastMember.fromJson(x))
              .toList() ??
          [],
    );
  }
}
