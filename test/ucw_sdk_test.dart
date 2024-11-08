import 'package:flutter_test/flutter_test.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/ucw_sdk_platform_interface.dart';
import 'package:ucw_sdk/ucw_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUcwSdkPlatform
    with MockPlatformInterfaceMixin
    implements UcwSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UcwSdkPlatform initialPlatform = UcwSdkPlatform.instance;

  test('$MethodChannelUcwSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUcwSdk>());
  });

  test('getPlatformVersion', () async {
    UcwSdk ucwSdkPlugin = UcwSdk();
    MockUcwSdkPlatform fakePlatform = MockUcwSdkPlatform();
    UcwSdkPlatform.instance = fakePlatform;

    expect(await ucwSdkPlugin.getPlatformVersion(), '42');
  });
}
