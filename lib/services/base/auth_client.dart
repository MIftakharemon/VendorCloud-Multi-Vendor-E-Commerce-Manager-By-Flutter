import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../constants/network_constants.dart';
import 'app_exceptions.dart';

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String api, {dynamic header}) async {
    var uri = Uri.parse(NetworkConstants.baseURL + api);
    try {
      var response = await client.get(uri, headers: header);
      print('Raw Get Response Body:\n${(response.body)}');

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", uri.toString());
    }
  }

  Future<dynamic> post(String api, dynamic object, {dynamic header}) async {
    var payload = jsonEncode(object);
    var uri = Uri.parse(NetworkConstants.baseURL + api);
    try {
      var response = await client.post(uri, body: payload, headers: header);
      print('Raw Post Response Body:\n${(response.body)}');

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", uri.toString());
    }
  }

  Future<dynamic> put(String api, dynamic object, {dynamic header}) async {
    var payload = jsonEncode(object);
    var uri = Uri.parse(NetworkConstants.baseURL + api);
    try {
      var response = await client.put(uri, body: payload, headers: header);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", uri.toString());
    }
  }

  Future<dynamic> patch(String api, dynamic object, {dynamic header}) async {
    var payload = jsonEncode(object);
    var uri = Uri.parse(NetworkConstants.baseURL + api);
    try {
      var response = await client.patch(uri, body: payload, headers: header);
      print('Raw PATCH Response Body:\n${(response.body)}');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", uri.toString());
    }
  }

  String jsonPretty(String jsonString) {
    var jsonObj = json.decode(jsonString);
    return JsonEncoder.withIndent('  ').convert(jsonObj);
  }

  Future<dynamic> delete(String api, {dynamic header}) async {
    var uri = Uri.parse(NetworkConstants.baseURL + api);
    try {
      var response = await client.delete(uri, headers: header);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection", uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    var bodyBytes = utf8.decode(response.bodyBytes);
    var responseJson = json.decode(bodyBytes);
    switch (response.statusCode) {
      case 200:
        return {'body': responseJson, 'headers': response.headers};
      case 201:
        return {'body': responseJson, 'headers': response.headers};
      case 204:
        return {'body': responseJson, 'headers': response.headers};
      case 400:
        var errors = json.decode(bodyBytes)["errors"];

        throw BadRequestException(
            errors[errors.keys.elementAt(0)][0].toString(),
            response.request!.url.toString());
      case 401:
        throw InternalServerException("something went wrong, code: 401",
            response.request?.url.toString());
      case 403:
        var errors = json.decode(bodyBytes)["errors"];

        throw UnAuthorizedException(
            errors[errors.keys.elementAt(0)][0].toString(),
            response.request?.url.toString());

      case 500:
        throw InternalServerException("something went wrong, code: 500",
            response.request?.url.toString());
      default:
        throw FetchDataException(
            "Error occur with code : ${response.statusCode}",
            response.request!.url.toString());
    }
  }
}
