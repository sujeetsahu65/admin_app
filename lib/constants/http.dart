import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HttpClientService {
  static final HttpClientService _instance = HttpClientService._internal();

  factory HttpClientService() {
    return _instance;
  }

  HttpClientService._internal();

  static const int defaultTimeoutDuration = 10; // Timeout duration in seconds
  static const int maxRetries = 1; // Maximum retry attempts

  // Single instance of http.Client
  final http.Client _client = http.Client();

  // Method to construct a custom response with status and message
  http.Response throwErrorResponse() {
    return http.Response(
      jsonEncode({
        "status": false,
        "status_code": 503,
        "message": 'Something went wrong',
      }),
      503,
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<http.Response> getRequest(
    String url, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    http.Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _client.get(Uri.parse(url), headers: headers).timeout(
            Duration(seconds: timeoutDuration ?? defaultTimeoutDuration));

        if (response.statusCode >= 200 && response.statusCode < 500) {
          return response; // Return for client errors (like 400, 402)
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
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
    return throwErrorResponse(); // Return null after max retries
  }

  Future<http.Response> postRequest(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    http.Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _client
            .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(
                Duration(seconds: timeoutDuration ?? defaultTimeoutDuration));

        if (response.statusCode >= 200 && response.statusCode < 500) {
          return response;
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
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

  Future<http.Response> putRequest(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    int? timeoutDuration,
  }) async {
    int retryCount = 0;
    http.Response? response;

    while (retryCount < maxRetries) {
      try {
        response = await _client
            .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
            .timeout(
                Duration(seconds: timeoutDuration ?? defaultTimeoutDuration));

        if (response.statusCode >= 200 && response.statusCode < 500) {
          return response;
        } else {
          print('Non-200 response: ${response.statusCode}, retrying...');
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

  // Method to dispose of the client when no longer needed
  void dispose() {
    _client.close();
  }
}

