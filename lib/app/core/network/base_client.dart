import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'exception_handlers.dart';

class BaseClient {
  int timeOutDurationSec = 60;

  //MULTIPART
  Future<dynamic> multipartPost(
    String url,
    dynamic header,
    String filekey,
    File path,
    String filename, {
    count = 0,
  }) async {
    var uri = Uri.parse(url);

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(header);
      request.files.add(
        http.MultipartFile.fromBytes(
          filekey,
          path.readAsBytesSync(),
          filename: filename,
        ),
      );
      var response = await request.send().timeout(
        Duration(seconds: timeOutDurationSec),
      );

      ///add your timeout time in here

      var responsed = await http.Response.fromStream(response);
      return _processResponse(responsed);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //GET
  Future<dynamic> get(String url, dynamic header, {count = 0}) async {
    var uri = Uri.parse(url);
    try {
      var response = await http
          .get(uri, headers: header)
          .timeout(Duration(seconds: timeOutDurationSec));

      ///add your timeout time in here
      return _processResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //POST
  Future<dynamic> post(
    String url,
    dynamic header,
    dynamic body, {
    count = 0,
  }) async {
    var uri = Uri.parse(url);
    var payload = body;
    try {
      var response = await http
          .post(uri, headers: header, body: payload)
          .timeout(Duration(seconds: timeOutDurationSec));

      ///add your timeout time in here
      return _processResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //PATCH
  Future<dynamic> patch(
    String url,
    dynamic header,
    dynamic body, {
    count = 0,
  }) async {
    var uri = Uri.parse(url);
    var payload = body;
    try {
      var response = await http
          .patch(uri, headers: header, body: payload)
          .timeout(Duration(seconds: timeOutDurationSec));

      ///add your timeout time in here
      return _processResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //DELETE
  Future<dynamic> delete(String url, dynamic header, {count = 0}) async {
    var uri = Uri.parse(url);
    try {
      var response = await http
          .delete(uri, headers: header)
          .timeout(Duration(seconds: timeOutDurationSec));

      ///add your timeout time in here
      return _processResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //PUT
  Future<dynamic> put(
    String url,
    dynamic header,
    dynamic body, {
    count = 0,
  }) async {
    var uri = Uri.parse(url);
    var payload = body;
    try {
      var response = await http
          .put(uri, headers: header, body: payload)
          .timeout(Duration(seconds: timeOutDurationSec));

      ///add your timeout time in here
      return _processResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        if (count < 3) {
          log('Retry count is  ${count.toString()}');
          count++;
          return await Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              return await get(url, header, count: count);
            },
          );
        } else {
          throw ExceptionHandlers().getExceptionString(e);
        }
      } else {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  //----------------------ERROR STATUS CODES----------------------

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return responseJson;
      case 201: //Resource created on post or put request
        var responseJson = response.body;
        return responseJson;
      case 400: //Bad request
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 404: //Resource Not Found
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 429: //Too Many Requests
        throw RateLimitException(jsonDecode(response.body)['message']);
      case 500: //Internal Server Error
      default:
        throw FetchDataException('Something went wrong, Try again!');
    }
  }
}
