import 'package:flutter/services.dart';
import 'package:ucw_sdk/data.dart';

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
          print('LogListener Level: $level, Message: $message');
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

ConnListener? connListener;

class ConnListener {
  static const EventChannel _connEventChannel = EventChannel('ucw_sdk/connection');

  Function(ConnCode connCode, String connMessage)? _connCallback;

  ConnListener() {
    print('Start ConnListener...');
    _connEventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map) {
          final int codeValue = event['code'] ?? 0;
          final ConnCode connCode = ConnCode.fromValue(codeValue);
          final String connMessage = event['message'] ?? 'No message';

          print('ConnListener Status: $connCode, Message: $connMessage');

          if (_connCallback != null) {
            _connCallback!(connCode, connMessage);
          }
        }
      },
      onError: (error) {
        print('Error receiving connection status: $error');
      },
    );
  }

  void registerConnCallback(Function(ConnCode connCode, String connMessage) callback) {
    _connCallback = callback;
  }

  void unregisterConnCallback() {
    _connCallback = null;
  }
}
