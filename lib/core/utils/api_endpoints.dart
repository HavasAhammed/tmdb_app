class ApiEndpoints {
  static const String baseUrl = "https://api.themoviedb.org/3"; //pro
  static const apiKey = "135efc8efd71c18ab0bf94eea5d838de";

  // Movies endpoints

  static const String popularMovies = "$baseUrl/movie/popular";
  static const String topRatedMovies = "$baseUrl/movie/top_rated";

  // Movie Credits
  static String movieCredits(int movieId) => '$baseUrl/movie/$movieId/credits';
}
