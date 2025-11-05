import 'package:tmdb_app/core/network/api_service.dart';
import 'package:tmdb_app/core/utils/api_endpoints.dart';
import 'package:tmdb_app/data/models/result.dart';
import 'package:tmdb_app/data/models/movie/movie_response.dart';
import 'package:tmdb_app/data/models/cast/movie_credits.dart';

class MovieService {
  final ApiService apiService;

  MovieService({required this.apiService});

  Future<Result<MovieResponse>> getPopularMovies({int page = 1}) async {
    const endpoint = ApiEndpoints.popularMovies;
    final params = {'page': page.toString()};
    final res = await apiService.get(endpoint, params: params);

    if (!res.success) {
      return Result<MovieResponse>(
        success: false,
        message: res.message,
        userMessage: res.userMessage,
        status: ResultStatus.failed,
      );
    }

    try {
      final decoded = res.value;
      if (decoded is Map<String, dynamic>) {
        final movieResp = MovieResponse.fromJson(decoded);
        return Result<MovieResponse>(
          success: true,
          value: movieResp,
          total: movieResp.totalResults,
          status: ResultStatus.done,
        );
      } else {
        return Result<MovieResponse>(
          success: false,
          message: ErrorMessage('Unexpected response format', null),
          userMessage: 'Invalid data from server',
          status: ResultStatus.failed,
        );
      }
    } catch (e, stack) {
      return Result<MovieResponse>(
        success: false,
        message: ErrorMessage(e.toString(), stack),
        userMessage: 'Failed to parse movie data',
        status: ResultStatus.failed,
      );
    }
  }

  Future<Result<MovieCredits>> getMovieCredits(int movieId) async {
    final endpoint = ApiEndpoints.movieCredits(movieId);
    final res = await apiService.get(endpoint);

    if (!res.success) {
      return Result<MovieCredits>(
        success: false,
        message: res.message,
        userMessage: res.userMessage,
        status: ResultStatus.failed,
      );
    }

    try {
      final data = res.value;
      if (data is Map<String, dynamic>) {
        final credits = MovieCredits.fromJson(data);
        return Result<MovieCredits>(
          success: true,
          value: credits,
          status: ResultStatus.done,
        );
      } else {
        return Result<MovieCredits>(
          success: false,
          message: ErrorMessage('Unexpected response format', null),
          userMessage: 'Invalid data from server',
          status: ResultStatus.failed,
        );
      }
    } catch (e, stack) {
      return Result<MovieCredits>(
        success: false,
        message: ErrorMessage(e.toString(), stack),
        userMessage: 'Failed to parse credits data',
        status: ResultStatus.failed,
      );
    }
  }
}
