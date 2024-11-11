import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ucw_sdk_platform_interface.dart';

/// An implementation of [UcwSdkPlatform] that uses method channels.
class MethodChannelUcwSdk extends UcwSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ucw_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<T?> call<T>(String method, [dynamic arguments]) async {
    final response = await methodChannel.invokeMethod(method, arguments);
    return response;
  }
}
