
import 'ucw_sdk_platform_interface.dart';
import 'package:ucw_sdk/data.dart';


Future<String?> getPlatformVersion() {
  return UcwSdkPlatform.instance.getPlatformVersion();
}

Future<T?> _call<T>(String method, [dynamic arguments]) async {
  final response = await UcwSdkPlatform.instance.call(method, arguments);
  return response;
}

Future<String> initializeSecrets(String secretsFile, String passphrase) async {
  try {
    final arguments = {'secretsFile': secretsFile, 'passphrase': passphrase};
    final result = await _call('initializeSecrets', arguments);
    if (result == null) {
      throw Exception('Received null result');
    }
    final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
    return nodeResult.tssNodeID;
  } catch (e) {
    throw Exception('Failed to initialize secrets: $e');
  }
}

class UCWPublic {
  String? handler;
  final String secretsFile;

  UCWPublic({required this.secretsFile});

  Future<void> init() async {
    await _openPublic();
  }

  void dispose() async {
    print("UCWPublic deinitialization");
    await _close();
  }

  Future<void> _openPublic() async {
    try {
      final arguments = {'secretsFile': secretsFile};
      final result = await _call('openPublic', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final handlerResult = HandlerResult.fromJson(Map<String, dynamic>.from(result));
      handler = handlerResult.handler;
    } catch (e) {
      throw Exception('Failed to openPublic: $e');
    }
  }

  Future<void> _close() async {
    try {
      final arguments = {'handler': handler};
      await _call('close', arguments);
      handler = null;
    } catch (e) {
      throw Exception('Failed to close: $e');
    }
  }

  Future<String> getTSSNodeID() async {
    try {
      final arguments = {'handler': handler};
      final result = await _call('getTSSNodeID', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
      return nodeResult.tssNodeID;
    } catch (e) {
      throw Exception('Failed to getTSSNodeID: $e');
    }
  }

  Future<List<TSSKeyShareGroup>> getTSSKeyShareGroups(List<String> tssKeyShareGroupIDs) async {
    try {
      final arguments = {'handler': handler, 'tssKeyShareGroupIDs': tssKeyShareGroupIDs};
      final result = await _call('getTSSKeyShareGroups', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final groupResult = GroupResult.fromJson(Map<String, dynamic>.from(result));
      return groupResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to getTSSKeyShareGroups: $e');
    }
  }

  Future<List<TSSKeyShareGroup>> listTSSKeyShareGroups() async {
    try {
      final arguments = {'handler': handler};
      final result = await _call('listTSSKeyShareGroups', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final groupResult = GroupResult.fromJson(Map<String, dynamic>.from(result));
      return groupResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to listTSSKeyShareGroups: $e');
    }
  }
}

class UCW extends UCWPublic {
}
