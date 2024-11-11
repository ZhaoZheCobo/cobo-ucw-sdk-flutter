
import 'ucw_sdk_platform_interface.dart';
import 'package:ucw_sdk/data.dart';

class UcwSdk {
  Future<String?> getPlatformVersion() {
    return UcwSdkPlatform.instance.getPlatformVersion();
  }
}

Future<String> initializeSecrets(String secretsFile, String passphrase) async {
  try {
    final Map<String, dynamic> arguments = {
      'secretsFile': secretsFile,
      'passphrase': passphrase,
    };
    final result = await UcwSdkPlatform.instance.call('initializeSecrets', arguments);
    if (result == null) {
      throw Exception('Received null result');
    }
    final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
    return nodeResult.tssNodeID;
  } catch (e) {
    throw Exception('Failed to initialize secrets: $e');
  }
}
