// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$CastService extends CastService {
  _$CastService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CastService;

  @override
  Future<Response<dynamic>> getMovieCredits(
    int movieId, {
    String apiKey = ApiEndpoints.apiKey,
  }) {
    final Uri $url = Uri.parse('${movieId}/credits');
    final Map<String, dynamic> $params = <String, dynamic>{'api_key': apiKey};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
