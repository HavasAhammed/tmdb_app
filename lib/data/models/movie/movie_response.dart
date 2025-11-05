import 'package:tmdb_app/data/models/movie/movie.dart';

class MovieResponse {
  final int? page;
  final List<Movie>? results;
  final int? totalPages;
  final int? totalResults;

  MovieResponse({this.page, this.results, this.totalPages, this.totalResults});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
    page: json["page"],
    results: json["results"] == null
        ? []
        : List<Movie>.from(json["results"]!.map((x) => Movie.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
