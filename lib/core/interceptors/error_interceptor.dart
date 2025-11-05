import 'dart:async';
import 'package:chopper/chopper.dart';

class ErrorInterceptor implements ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response<dynamic> response) async {
    switch (response.statusCode) {
      case 200:
        return response;
      default:
        return response;
    }
  }
}
