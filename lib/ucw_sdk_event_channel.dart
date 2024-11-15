import 'package:flutter/services.dart';

class LogListener {
  static const EventChannel _logEventChannel = EventChannel('ucw_sdk/logs');

  Function(String level, String message)? _logCallback;

  LogListener() {
    _logEventChannel.receiveBroadcastStream().listen(
      (event) {
        if (_logCallback != null && event is Map) {
          final level = event['level'] ?? 'Unknown';
          final message = event['message'] ?? 'No message';
          _logCallback!(level.toString(), message.toString());

          print('Log received: Level: $level, Message: $message');
        }
      },
      onError: (error) {
        print('Error receiving log: $error');
      },
    );
  }

  void registerLogCallback(Function(String level, String message) callback) {
    _logCallback = callback;
  }

  void unregisterLogCallback() {
    _logCallback = null;
  }
}

