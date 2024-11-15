import 'package:flutter/services.dart';

LogListener? logListener;

class LogListener {
  static const EventChannel _logEventChannel = EventChannel('ucw_sdk/logs');

  Function(String level, String message)? _logCallback;

  LogListener() {
    print('Start LogListener...');
    _logEventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map) {
          final level = event['level'] ?? 'Unknown';
          final message = event['message'] ?? 'No message';
          print('Log: [Level] $level, [Message] $message');
          if (_logCallback != null) {
            _logCallback!(level.toString(), message.toString());
          }
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

