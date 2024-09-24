import 'package:admin_app/pages/auth/services/basic.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  AuthNotifier(this.ref) : super(AuthState.initial()) {
    _loadToken();
  }
  final Ref ref;
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$uri/auth/verify-token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

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
    try {
      final response = await http.post(
        Uri.parse('$uri/auth/login'),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
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
  }

  Future<void> logout() async {
    // CLEAR NECESSARY VALUES FROM LOCAL STORAGE
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');

    // DISPOSE/REST ALL THE STATES THAT ARE NOT HAVING AUTO-DISPOSE
    ref
        .read(orderProvider.notifier)
        .disposeNotifier(); //Having to user disposeNotifier as we are infinitely fetching orders so have to manually stop that loop
    ref.invalidate(orderProvider);
    ref.invalidate(generalDataProvider);
    state = AuthState.initial();
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
