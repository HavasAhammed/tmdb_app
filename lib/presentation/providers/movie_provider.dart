import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tmdb_app/data/models/movie/movie.dart';
import 'package:tmdb_app/data/models/movie/movie_response.dart';
import 'package:tmdb_app/data/services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  bool isFavoritesLoading = false;
  bool isTopRatedLoading = false;
  bool isWatchListLoading = false;

  List<Movie> favoriteMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> watchListMovies = [];

  Future getAllFavoriteMovies(BuildContext context, {int? page}) async {
    try {
      if (page == 1) {
        favoriteMovies.clear();
        isFavoritesLoading = true;
        notifyListeners();
      }
      var response = await Provider.of<MovieService>(
        context,
        listen: false,
      ).getFavoriteMovies(page: page);
      if (response.isSuccessful) {
        var result = MovieResponse.fromJson(response.body);
        favoriteMovies.addAll(result.results ?? []);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      isFavoritesLoading = false;
      notifyListeners();
    }
  }

  Future getAllTopRatedMovies(BuildContext context, {int? page}) async {
    try {
      if (page == 1) {
        topRatedMovies.clear();
        isTopRatedLoading = true;
        notifyListeners();
      }
      var response = await Provider.of<MovieService>(
        context,
        listen: false,
      ).getTopRatedMovies(page: page);
      if (response.isSuccessful) {
        var result = MovieResponse.fromJson(response.body);
        topRatedMovies.addAll(result.results ?? []);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      isTopRatedLoading = false;
      notifyListeners();
    }
  }

  Future getAllWatchListMovies(BuildContext context, {int? page}) async {
    try {
      if (page == 1) {
        watchListMovies.clear();
        isWatchListLoading = true;
        notifyListeners();
      }
      var response = await Provider.of<MovieService>(
        context,
        listen: false,
      ).getWatchListMovies(page: page);
      if (response.isSuccessful) {
        var result = MovieResponse.fromJson(response.body);
        watchListMovies.addAll(result.results ?? []);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      isWatchListLoading = false;
      notifyListeners();
    }
  }
}


