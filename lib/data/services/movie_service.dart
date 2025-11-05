import 'package:chopper/chopper.dart';
import 'package:tmdb_app/core/interceptors/error_interceptor.dart';
import 'package:tmdb_app/core/interceptors/header_interceptor.dart';
import 'package:tmdb_app/core/utils/api_endpoints.dart';
part 'movie_service.chopper.dart';

@ChopperApi()
abstract class MovieService extends ChopperService {
  // Get Favorite Movies
  @Get(path: 'popular')
  Future<Response<dynamic>> getFavoriteMovies({
    @Query('api_key') String apiKey = ApiEndpoints.apiKey,
    @Query('page') int? page,
  });

  // Get Trending Movies
  @Get(path: 'top_rated')
  Future<Response<dynamic>> getTopRatedMovies({
    @Query('api_key') String apiKey = ApiEndpoints.apiKey,
    @Query('page') int? page,
  });

  // Get WatchList Movies
  @Get(path: 'now_playing')
  Future<Response<dynamic>> getWatchListMovies({
    @Query('api_key') String apiKey = ApiEndpoints.apiKey,
    @Query('page') int? page,
  });

  static MovieService create() {
    final client = ChopperClient(
      interceptors: [
        HttpLoggingInterceptor(),
        HeaderInterceptor(),
        ErrorInterceptor(),
      ],
      baseUrl: Uri.parse(ApiEndpoints.movieUrl),
      services: [_$MovieService()],
      converter: const JsonConverter(),
    );
    return _$MovieService(client);
  }
}
