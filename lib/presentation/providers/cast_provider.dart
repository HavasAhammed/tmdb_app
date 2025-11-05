import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/data/models/cast/movie_credits.dart';
import 'package:tmdb_app/data/services/cast_service.dart';

class CastProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  MovieCredits? credits;

  Future<void> getAllMovieCredits(
    BuildContext context, {
    required int movieId,
  }) async {
    if (isLoading) return;

    if (movieId <= 0) {
      error = 'Invalid movie id';
      credits = MovieCredits(cast: []);
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await Provider.of<CastService>(
        context,
        listen: false,
      ).getMovieCredits(movieId);

      if (response.isSuccessful && response.body != null) {
        credits = MovieCredits.fromJson(response.body as Map<String, dynamic>);
        error = null;
      } else {
        credits = MovieCredits(cast: []);
        error = 'Failed to load cast';
      }
    } catch (e) {
      credits = MovieCredits(cast: []);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    credits = null;
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
