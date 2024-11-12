
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
    final Map<String, dynamic> arguments = {
      'secretsFile': secretsFile,
      'passphrase': passphrase,
    };
    final result = await _call('initializeSecrets', arguments);
    if (result == null) {
      throw Exception('Received null result');
    }
    final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
    if (nodeResult.tssNodeID == null) {
      throw Exception('tssNodeID is null');
    }

    return nodeResult.tssNodeID;
  } catch (e) {
    throw Exception('Failed to initialize secrets: $e');
  }
}

class UCWPublic {
  String? handler;
  final String secretsFile;

  UCWPublic({required this.secretsFile}) {
    handler = null;
    _openPublic();
  }

  void dispose() {
    print("UCWPublic deinitialization");
    _close();
  }

  Future<void> _openPublic() async {
    try {
      final Map<String, dynamic> arguments = {
        'secretsFile': secretsFile,
      };
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
      final Map<String, dynamic> arguments = {
        'handler': handler,
      };
      await _call('close', arguments);
    } catch (e) {
      throw Exception('Failed to close: $e');
    }
  }

  Future<String> getTSSNodeID() async {
    try {
      final Map<String, dynamic> arguments = {
        'handler': handler,
      };
      final result = await _call('getTSSNodeID', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
      if (nodeResult.tssNodeID == null) {
        throw Exception('tssNodeID is null');
      }

      return nodeResult.tssNodeID;
    } catch (e) {
      throw Exception('Failed to getTSSNodeID: $e');
    }
  }

  Future<List<TSSKeyShareGroup>> getTSSKeyShareGroups(List<String> tssKeyShareGroupIDs) async {
    try {
      final Map<String, dynamic> arguments = {
        'handler': handler,
        'tssKeyShareGroupIDs': tssKeyShareGroupIDs,
      };
      var result = await _call('getTSSKeyShareGroups', arguments);
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
      final Map<String, dynamic> arguments = {
        'handler': handler,
      };
      var result = await _call('listTSSKeyShareGroups', arguments);
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
