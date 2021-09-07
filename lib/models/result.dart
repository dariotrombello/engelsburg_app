import 'dart:convert';

import 'package:http/http.dart';

class Result {

  Result._of(this.result);
  Result._error(this.error);
  Result._empty();

  Map<String, dynamic>? result;
  ApiError? error;

  bool errorPresent() {
    return error != null;
  }

  bool resultPresent() {
    return result != null;
  }

  factory Result.of(Map<String, dynamic> result) => Result._of(result);
  factory Result.error(ApiError apiError) => Result._error(apiError);
  factory Result.empty() => Result._empty();

  void onResult(Function(Map<String, dynamic>) f) {
    if (resultPresent()) f(result!);
  }

  T parse<T>(T Function(Map<String, dynamic>) f) {
    result ??= {};

    return f(result!);
  }

  Result onError(Function(ApiError) f) {
    if (errorPresent()) f(error!);

    return this;
  }

  Result handleUnexpectedError() {
    if (errorPresent()) {//Handle errors
      if (error!.status == 0) { //Custom status to handle fetching errors
        //TODO: no network connection, error fetching
      } else if (error!.status == 400) {
        if (error!.messageKey == 'INVALID_PARAM') {
          //TODO: something went wrong
        }
        if (error!.extra == 'token') {
          if (error!.messageKey == 'EXPIRED')  {
            //TODO: get new JWT
          } else if (error!.messageKey == 'INVALID' || error!.messageKey == 'FAILED') {
            //TODO: try to login again
          }
        }
      } else if (error!.status == 401) {
        //TODO: need to be logged in
      } else if (error!.status == 403) {
        //TODO: don't permitted
      } else if (error!.status == 500) {
        //TODO: something wen't wrong (internal server error)
      }

      //TODO: handle unexpected error
    }

    return this;
  }

}

class ApiError {

  int? status;
  String? messageKey;
  String? extra;

  ApiError({this.status, this.messageKey, this.extra});

  factory ApiError.tryDecode(Response response) {
    try {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey("status")) {
          return ApiError.fromJson(json);
        }
      }
    } catch (_) {}

    return ApiError.fromStatus(response.statusCode);
  }

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
      status: json['status'],
      messageKey: json['messageKey'],
      extra: json['extra']
  );

  factory ApiError.fromStatus(int status) => ApiError(status: status);

}
