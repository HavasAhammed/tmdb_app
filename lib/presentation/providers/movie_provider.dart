import 'package:flutter/material.dart';
import 'package:tmdb_app/data/models/movie/movie.dart';
import 'package:tmdb_app/data/models/cast/movie_credits.dart';
import 'package:tmdb_app/data/models/result.dart';
import 'package:tmdb_app/data/services/movie_service.dart';
// Optional: if you add connectivity_plus, uncomment the next line and add dependency
// import 'package:connectivity_plus/connectivity_plus.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService movieService;

  MovieProvider({required this.movieService});

  bool isLoading = false;
  String? error;
  List<Movie> movies = [];
  int currentPage = 1;

  // Credits related state
  bool isLoadingCredits = false;
  String? creditsError;
  MovieCredits? movieCredits;

  Future<void> fetchPopularMovies({int page = 1}) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    final Result res = await movieService.getPopularMovies(page: page);
    if (res.success && res.value != null) {
      final movieResp = res.value;
      movies = (movieResp!.results ?? []);
      currentPage = movieResp.page ?? page;
    } else {
      error = res.userMessage ?? 'Failed to load movies';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchPopularMovies(page: 1);
  }

  Future<void> fetchMovieCredits(int movieId) async {
    if (isLoadingCredits) return;

    // guard: invalid id
    if (movieId <= 0) {
      creditsError = 'Invalid movie id';
      movieCredits = MovieCredits(cast: []);
      notifyListeners();
      return;
    }

    isLoadingCredits = true;
    creditsError = null;
    notifyListeners();

    try {
      // Optional connectivity pre-check (requires connectivity_plus)
      // final conn = await Connectivity().checkConnectivity();
      // if (conn == ConnectivityResult.none) {
      //   creditsError = 'No internet connection';
      //   movieCredits = MovieCredits(cast: []);
      //   isLoadingCredits = false;
      //   notifyListeners();
      //   return;
      // }

      final result = await movieService.getMovieCredits(movieId);

      if (result.success && result.value != null) {
        movieCredits = result.value;
        creditsError = null;
      } else {
        // keep empty list as fallback so UI can show "no cast" instead of crashing
        movieCredits = MovieCredits(cast: []);
        creditsError = result.userMessage ?? 'Failed to load movie credits';
      }
    } catch (e) {
      movieCredits = MovieCredits(cast: []);
      creditsError = 'Error: ${e.toString()}';
    } finally {
      isLoadingCredits = false;
      notifyListeners();
    }
  }

  void clearCredits() {
    movieCredits = null;
    creditsError = null;
    notifyListeners();
  }
}
