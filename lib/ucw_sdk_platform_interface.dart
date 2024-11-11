import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ucw_sdk_method_channel.dart';

abstract class UcwSdkPlatform extends PlatformInterface {
  /// Constructs a UcwSdkPlatform.
  UcwSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static UcwSdkPlatform _instance = MethodChannelUcwSdk();

  /// The default instance of [UcwSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelUcwSdk].
  static UcwSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UcwSdkPlatform] when
  /// they register themselves.
  static set instance(UcwSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<T?> call<T>(String method, [dynamic arguments]) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
