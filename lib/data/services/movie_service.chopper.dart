// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$MovieService extends MovieService {
  _$MovieService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = MovieService;

  @override
  Future<Response<dynamic>> getFavoriteMovies({
    String apiKey = ApiEndpoints.apiKey,
    int? page,
  }) {
    final Uri $url = Uri.parse('popular');
    final Map<String, dynamic> $params = <String, dynamic>{
      'api_key': apiKey,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTopRatedMovies({
    String apiKey = ApiEndpoints.apiKey,
    int? page,
  }) {
    final Uri $url = Uri.parse('top_rated');
    final Map<String, dynamic> $params = <String, dynamic>{
      'api_key': apiKey,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getWatchListMovies({
    String apiKey = ApiEndpoints.apiKey,
    int? page,
  }) {
    final Uri $url = Uri.parse('now_playing');
    final Map<String, dynamic> $params = <String, dynamic>{
      'api_key': apiKey,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
