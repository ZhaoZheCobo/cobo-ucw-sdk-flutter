
import 'ucw_sdk_platform_interface.dart';

class UcwSdk {
  Future<String?> getPlatformVersion() {
    return UcwSdkPlatform.instance.getPlatformVersion();
  }
}
