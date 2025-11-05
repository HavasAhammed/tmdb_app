import 'dart:async';
import 'package:chopper/chopper.dart';

class HeaderInterceptor implements RequestInterceptor {
  static const String authHeader = "Authorization";
  static const String _accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMzVlZmM4ZWZkNzFjMThhYjBiZjk0ZWVhNWQ4MzhkZSIsIm5iZiI6MTY2NzIwMjAxMS4zMjE5OTk4LCJzdWIiOiI2MzVmN2JkYjFiNzI5NDAwN2JmMDY2NzMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Mv8bWnFrD65JiOImC8bsTJFMsZ9puvKub5ViHXIFtFo";
  static const String token = "Bearer $_accessToken";

  @override
  FutureOr<Request> onRequest(Request request) {
    Request newRequest = request.copyWith(
      headers: {
        // "Accept": "application/json",
        "Content-Type": "application/json",
        authHeader: token,
      },
    );
    return newRequest;
  }
}
