import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

class DioClientService {
  static final DioClientService _instance = DioClientService._internal();

  factory DioClientService() {
    return _instance;
  }

  DioClientService._internal();

  static const int defaultTimeoutDuration = 10; // Timeout duration in seconds
  static const int maxRetries = 1; // Maximum retry attempts

  // Single instance of Dio
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: defaultTimeoutDuration),
      receiveTimeout: Duration(seconds: defaultTimeoutDuration),
      sendTimeout: Duration(seconds: defaultTimeoutDuration),
      headers: {"Content-Type": "application/json"},
    ),
  );

  // Method to construct a custom response with status and message
  Response throwErrorResponse() {
    return Response(
      statusCode: 503,
      requestOptions: RequestOptions(path: ''),
      data: jsonEncode({
        "status": false,
        "status_code": 503,
        "message": "Something went wrong",
      }),
    );
  }

  // GET Request with Dio Exception Handling
  Future<Response> getRequest(
    String url, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _dio.get(
          url,
          options: Options(
            headers: headers,
            receiveTimeout:
                Duration(seconds: timeoutDuration ?? defaultTimeoutDuration),
          ),
        );

        // Handle successful status codes (2xx and 4xx for client-side errors)
        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 500) {
          return response;
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
        }
      } on DioException catch (dioError) {
        if (dioError.response != null) {
          return dioError.response!;
        } else {
          print('DioError without response: $dioError');
        }
      } catch (error) {
        print('Request failed (attempt ${retryCount + 1}): $error');
      }

      retryCount++;
      if (retryCount < maxRetries) {
        print('Retrying request... (${retryCount + 1}/$maxRetries)');
      }
    }

    print('Failed after multiple retries.');
    return throwErrorResponse();
  }

  // POST Request with Dio Exception Handling
  Future<Response> postRequest(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _dio.post(
          url,
          data: jsonEncode(body),
          options: Options(
            headers: headers,
            receiveTimeout:
                Duration(seconds: timeoutDuration ?? defaultTimeoutDuration),
          ),
        );

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 500) {
          return response;
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
        }
      } on DioException catch (dioError) {
        if (dioError.response != null) {
          if (dioError.response!.statusCode == 404) {
            print('404 Not Found: ${dioError.response!.data}');
            return Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
              data: jsonEncode({
                "status": false,
                "status_code": 404,
                "message": "Resource not found",
              }),
            );
          } else {
            print('Dio error with response: ${dioError.response!.statusCode}');
          }
        } else {
          print('DioError without response: $dioError');
        }
      } catch (error) {
        print('Request failed (attempt ${retryCount + 1}): $error');
      }

      retryCount++;
      if (retryCount < maxRetries) {
        print('Retrying request... (${retryCount + 1}/$maxRetries)');
      }
    }

    print('Failed after multiple retries.');
    return throwErrorResponse();
  }

  // PUT Request with Dio Exception Handling
  Future<Response> putRequest(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _dio.put(
          url,
          data: jsonEncode(body),
          options: Options(
            headers: headers,
            receiveTimeout:
                Duration(seconds: timeoutDuration ?? defaultTimeoutDuration),
          ),
        );

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 500) {
          return response;
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
        }
      } on DioException catch (dioError) {
        if (dioError.response != null) {
          if (dioError.response!.statusCode == 404) {
            print('404 Not Found: ${dioError.response!.data}');
            return Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
              data: jsonEncode({
                "status": false,
                "status_code": 404,
                "message": "Resource not found",
              }),
            );
          } else {
            print('Dio error with response: ${dioError.response!.statusCode}');
          }
        } else {
          print('DioError without response: $dioError');
        }
      } catch (error) {
        print('Request failed (attempt ${retryCount + 1}): $error');
      }

      retryCount++;
      if (retryCount < maxRetries) {
        print('Retrying request... (${retryCount + 1}/$maxRetries)');
      }
    }

    print('Failed after multiple retries.');
    return throwErrorResponse();
  }

  // Method to dispose of the Dio instance
  void dispose() {
    _dio.close();
  }
}
