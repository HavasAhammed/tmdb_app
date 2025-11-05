import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tmdb_app/core/utils/api_endpoints.dart';
import 'package:tmdb_app/data/models/result.dart';

/// A simple API service for TMDB-style REST APIs
class ApiService {
  /// v3 API key (used in query params)
  final String _apiKey = ApiEndpoints.apiKey;

  /// v4 Access Token (used in headers)
  static const String _accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMzVlZmM4ZWZkNzFjMThhYjBiZjk0ZWVhNWQ4MzhkZSIsIm5iZiI6MTY2NzIwMjAxMS4zMjE5OTk4LCJzdWIiOiI2MzVmN2JkYjFiNzI5NDAwN2JmMDY2NzMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Mv8bWnFrD65JiOImC8bsTJFMsZ9puvKub5ViHXIFtFo";

  /// Common headers used in all requests
  Map<String, String> get _headers => {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $_accessToken",
  };

  /// Handle responses and return a Result object
  Result _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Result(success: true, value: decoded);
      } else {
        return Result(
          success: false,
          message: ErrorMessage(
            decoded is Map && decoded['status_message'] != null
                ? decoded['status_message']
                : 'Error: ${response.statusCode} ${response.reasonPhrase}',
            null,
          ),
          userMessage: decoded is Map && decoded['status_message'] != null
              ? decoded['status_message']
              : 'Request failed',
        );
      }
    } catch (e, stack) {
      return Result(
        success: false,
        message: ErrorMessage('Invalid JSON response: $e', stack),
        userMessage: 'Invalid response from server',
      );
    }
  }

  /// GET request with timeout and a simple retry for transient failures
  Future<Result> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int attempts = 0;
    const maxAttempts = 2;
    while (true) {
      attempts++;
      try {
        // Merge provided params with api_key
        final queryParams = <String, String>{};
        if (params != null) {
          params.forEach((k, v) => queryParams[k] = v.toString());
        }
        queryParams['api_key'] = _apiKey;

        final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);

        final response = await http
            .get(uri, headers: _headers)
            .timeout(timeout);
        return _handleResponse(response);
      } on SocketException {
        if (attempts >= maxAttempts) {
          return Result(
            success: false,
            message: ErrorMessage('No Internet connection', null),
            userMessage: 'No internet connection',
            status: ResultStatus.failed,
          );
        }
        // small delay and retry
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      } on TimeoutException catch (_) {
        if (attempts >= maxAttempts) {
          return Result(
            success: false,
            message: ErrorMessage('Request timed out', null),
            userMessage: 'Request timed out',
            status: ResultStatus.failed,
          );
        }
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      } catch (e, stack) {
        return Result(
          success: false,
          message: ErrorMessage(e.toString(), stack),
          userMessage: 'Something went wrong',
          status: ResultStatus.failed,
        );
      }
    }
  }

  /// POST request
  Future<Result> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(
        "$endpoint${endpoint.contains('?') ? '&' : '?'}api_key=$_apiKey",
      );
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      return Result(message: ErrorMessage(e.toString(), stack));
    }
  }

  /// PUT request
  Future<Result> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(
        "$endpoint${endpoint.contains('?') ? '&' : '?'}api_key=$_apiKey",
      );
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      return Result(message: ErrorMessage(e.toString(), stack));
    }
  }

  /// DELETE request
  Future<Result> delete(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final uri = Uri.parse(
        "$endpoint${endpoint.contains('?') ? '&' : '?'}api_key=$_apiKey",
      );
      final response = await http.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e, stack) {
      return Result(message: ErrorMessage(e.toString(), stack));
    }
  }
}
