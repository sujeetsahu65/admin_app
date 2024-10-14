// import 'package:admin_app/pages/auth/services/basic.dart';
import 'package:admin_app/constants/http.dart';
// import 'package:admin_app/pages/auth/services/basic.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:admin_app/constants/error_handling.dart';
import 'package:admin_app/constants/global_variables.dart';
// import 'package:admin_app/constants/utils.dart';
// import 'package:admin_app/pages/auth/services/auth_service.dart';

// final BasicService basicService = BasicService();
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final HttpClientService httpClient = HttpClientService();
  AuthNotifier(this.ref) : super(AuthState.initial()) {
    _loadToken();
  }
  final Ref ref;
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token');
    if (token != null) {
      try {
        final url = '$uri/auth/verify-token';
        final Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        };

        final response = await httpClient.getRequest(url, headers: headers,timeoutDuration: 5);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // final appData = await basicService.fetchAppData(token);

          state = AuthState(token: token, role: data['role']);
          // await prefs.setString('app-data', jsonEncode(appData));
          ref
              .read(globalMessageProvider.notifier)
              .showSuccess("Logged in successfully");
        } else {
          ref
              .read(globalMessageProvider.notifier)
              .showError(json.decode(response.body)['message']);
        }
      } catch (error) {
        ref
            .read(globalMessageProvider.notifier)
            .showError('Something went wrong');
      }
    }
  }

  Future<void> login(String username, String password) async {
      ref.read(loadingProvider.notifier).showLoader();
    try {
      final url = '$uri/auth/login';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final body = {
        "username": username,
        "password": password,
      };

      final response =
          await httpClient.postRequest(url, body, headers: headers, timeoutDuration: 5);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final role = data['role'];
        // final appData = await basicService.fetchAppData(token);
        // state = AuthState(token: token, role: role, appData: appData);
        state = AuthState(token: token, role: role);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', token);
        // await prefs.setString('app-data', jsonEncode(appData));

        ref
            .read(globalMessageProvider.notifier)
            .showSuccess("Logged in successfully");
      } else {
        ref
            .read(globalMessageProvider.notifier)
            .showError(json.decode(response.body)['message']);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError('Something went wrong');
    }

      ref.read(loadingProvider.notifier).hideLoader();
  }

  Future<void> logout() async {
      ref.read(loadingProvider.notifier).showLoader();
    HttpClientService().dispose();

    // CLEAR NECESSARY VALUES FROM LOCAL STORAGE
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');
    AudioService().stopAlarmSound();
    // DISPOSE/REST ALL THE STATES THAT ARE NOT HAVING AUTO-DISPOSE
    ref
        .read(orderProvider.notifier)
        .dispose(); //Having to user disposeNotifier as we are infinitely fetching orders so have to manually stop that loop
    ref.invalidate(orderProvider);
    ref.invalidate(generalDataProvider);
    state = AuthState.initial();
      ref.read(loadingProvider.notifier).hideLoader();
  }
}

// class AuthState {
//   final String? token;
//   final String? role;
//   final Map<String, String> appData;

//   AuthState({
//     this.token = null,
//     this.role,
//     this.appData = const {},
//   });

//     factory AuthState.initial() => AuthState(token: null, role: null);

//   bool get isLoggedIn => token != null;
//   bool get getRole => role != null;
// }

class AuthState {
  final String? _token;
  final String? _role;
  // final Map<String, dynamic> _appData;

  // AuthState(
  //     {String? token, String? role, Map<String, dynamic> appData = const {}})
  //     : _token = token,
  //       _role = role,
  //       _appData = appData;
  AuthState({String? token, String? role})
      : _token = token,
        _role = role;

  factory AuthState.initial() => AuthState(token: null, role: null);

  bool get isLoggedIn => _token != null;
  bool get hasRole => _role != null;

  String? get token => _token;
  String? get role => _role;
  // Map<String, dynamic> get appData => _appData;
}
