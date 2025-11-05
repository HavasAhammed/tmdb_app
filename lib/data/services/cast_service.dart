import 'package:chopper/chopper.dart';
import 'package:tmdb_app/core/interceptors/error_interceptor.dart';
import 'package:tmdb_app/core/interceptors/header_interceptor.dart';
import 'package:tmdb_app/core/utils/api_endpoints.dart';
part 'cast_service.chopper.dart';

@ChopperApi()
abstract class CastService extends ChopperService {
  // Get Cast of a movie: /{movie_id}/credits
  @Get(path: '{movie_id}/credits')
  Future<Response<dynamic>> getMovieCredits(
    @Path('movie_id') int movieId, {
    @Query('api_key') String apiKey = ApiEndpoints.apiKey,
  });

  static CastService create() {
    final client = ChopperClient(
      interceptors: [
        HttpLoggingInterceptor(),
        HeaderInterceptor(),
        ErrorInterceptor(),
      ],
      baseUrl: Uri.parse(ApiEndpoints.movieUrl),
      services: [_$CastService()],
      converter: const JsonConverter(),
    );
    return _$CastService(client);
  }
}
