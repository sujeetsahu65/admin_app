import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalMessageState {
  final String? message;
  final bool isError;

  GlobalMessageState({this.message, this.isError = false});
}

class GlobalMessageNotifier extends StateNotifier<GlobalMessageState?> {
  GlobalMessageNotifier() : super(null);

  void showError(String? message) {
    if(message != null){

    state = GlobalMessageState(message: message, isError: true);
    }
  }

  void showSuccess(String? message) {
    if(message != null){
    state = GlobalMessageState(message: message, isError: false);
    }
  }

  void clearMessage() {
    state = null; // Clear the message after it's shown.
  }
}

final globalMessageProvider =
    StateNotifierProvider<GlobalMessageNotifier, GlobalMessageState?>((ref) {
  return GlobalMessageNotifier();
});



class ApiResponse<T> {
  final T? data;
  final String? message;
  final int statusCode;

  ApiResponse({this.data, this.message, required this.statusCode});

  bool get isSuccess => statusCode == 200;
  bool get badRequest => statusCode == 400;
  bool get isNotFound => statusCode == 404;
}
