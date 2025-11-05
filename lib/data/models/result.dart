import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Result<T> {
  final T? value;
  final bool success;
  final ErrorMessage? message;
  final String? userMessage;
  final int? total;
  ResultStatus status;

  Result({
    this.value,
    this.success = true,
    this.message,
    this.userMessage,
    this.total,
    this.status = ResultStatus.idle,
  });

  factory Result.fromResponse(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return Result(
          value: data,
          success: true,
          userMessage: "Success",
          status: ResultStatus.done,
        );
      } else {
        return Result(
          success: false,
          message: ErrorMessage(
            "API Error: ${data['status_message'] ?? 'Unknown error'}",
            null,
          ),
          userMessage: data['status_message'] ?? 'Failed to fetch data.',
          status: ResultStatus.failed,
        );
      }
    } catch (ex, stack) {
      log('Parsing Error: $ex');
      return Result(
        success: false,
        message: ErrorMessage(ex.toString(), stack),
        userMessage: 'Something went wrong. Please try again.',
        status: ResultStatus.failed,
      );
    }
  }

  void setStatus(ResultStatus stat) => status = stat;
  void resetStatus() => status = ResultStatus.idle;
}

enum ResultStatus { idle, loading, done, failed, silentlyLoading }

class ErrorMessage {
  String exception;
  StackTrace? stack;
  ErrorMessage(this.exception, this.stack);
}
