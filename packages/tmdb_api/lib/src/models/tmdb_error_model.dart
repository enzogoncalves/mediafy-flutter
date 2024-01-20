// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class TmdbError {
  TmdbError({required this.response}) {
    const JsonDecoder decoder = JsonDecoder();

    // response.substring(11) removes the "Exception" prefix
    Map<String, dynamic> bodyResponse = decoder.convert(response.substring(11));

    status_code = bodyResponse["status_code"];
    status_message = bodyResponse["status_message"];
    success = bodyResponse["success"];
  }

  String response;

  late int status_code;
  late String status_message;
  late bool success;
}
