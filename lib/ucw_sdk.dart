
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
    throw Exception('Failed to initializeSecrets: $e');
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

}

class UCW extends UCWPublic {

  SDKConfig config;
  ConnCode? connCode;
  String? connMessage;

  UCW({
    required super.secretsFile,
    required this.config,
  });

  Future<void> init1(String passphrase) async {
    connCode = ConnCode.unknown;
    connMessage = null;
    await _open(passphrase);
  }

  @override
  void dispose() async {
    print("UCW deinitialization");
    await _close();
  }

  Future<void> _open(String passphrase) async {
    try {
      final arguments = {
        'config.env': config.env.value,
        'config.debug': config.debug,
        'secretsFile': secretsFile,
        'passphrase': passphrase,
      };
      final result = await _call('open', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final handlerResult = HandlerResult.fromJson(Map<String, dynamic>.from(result));
      handler = handlerResult.handler;
    } catch (e) {
      throw Exception('Failed to open: $e');
    }
  }

  Map<String, dynamic> getConnStatus() {
      return {
        'connCode': connCode,
        'connMessage': connMessage,
      };
  }

  Future<List<TSSRequest>> listPendingTSSRequests() async {
    try {
      final arguments = {
        'handler': handler,
        'timeout': config.timeout,
      };
      var result = await _call('listPendingTSSRequests', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final tssRequestResult = TSSRequestResult.fromJson(Map<String, dynamic>.from(result));
      return tssRequestResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to listPendingTSSRequests: $e');
    }
  }

  Future<List<TSSRequest>> getTSSRequests(List<String> tssRequestIDs) async {
    try {
      final arguments = {
        'handler': handler,
        'tssRequestIDs': tssRequestIDs,
        'timeout': config.timeout,
      };
      var result = await _call('getTSSRequests', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final tssRequestResult = TSSRequestResult.fromJson(Map<String, dynamic>.from(result));
      return tssRequestResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to getTSSRequests: $e');
    }
  }

    Future<void> approveTSSRequests(List<String> tssRequestIDs) async {
    try {
      final arguments = {
        'handler': handler,
        'tssRequestIDs': tssRequestIDs,
      };
      await _call('approveTSSRequests', arguments);
    } catch (e) {
      throw Exception('Failed to approveTSSRequests: $e');
    }
  }

  Future<void> rejectTSSRequests(List<String> tssRequestIDs, String reason) async {
    try {
      final arguments = {
        'handler': handler,
        'tssRequestIDs': tssRequestIDs,
        'reason': reason,
      };
      await _call('rejectTSSRequests', arguments);
    } catch (e) {
      throw Exception('Failed to rejectTSSRequests: $e');
    }
  }

  Future<List<Transaction>> listPendingTransactions() async {
    try {
      final arguments = {
        'handler': handler,
        'timeout': config.timeout,
      };
      var result = await _call('listPendingTransactions', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final transactionResult = TransactionResult.fromJson(Map<String, dynamic>.from(result));
      return transactionResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to listPendingTransactions: $e');
    }
  }

  Future<List<Transaction>> getTransactions(List<String> transactionIDs) async {
    try {
      final arguments = {
        'handler': handler,
        'transactionIDs': transactionIDs,
        'timeout': config.timeout,
      };
      var result = await _call('getTransactions', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final transactionResult = TransactionResult.fromJson(Map<String, dynamic>.from(result));
      return transactionResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to getTransactions: $e');
    }
  }

  Future<void> approveTransactions(List<String> transactionIDs) async {
    try {
      final arguments = {
        'handler': handler,
        'transactionIDs': transactionIDs,
      };
      await _call('approveTransactions', arguments);
    } catch (e) {
      throw Exception('Failed to approveTransactions: $e');
    }
  }

  Future<void> rejectTransactions(List<String> transactionIDs, String reason) async {
    try {
      final arguments = {
        'handler': handler,
        'transactionIDs': transactionIDs,
        'reason': reason,
      };
      await _call('rejectTransactions', arguments);
    } catch (e) {
      throw Exception('Failed to rejectTransactions: $e');
    }
  }


}

Future<void> setLogger() async {
  try {
    await _call('setLogger');
  } catch (e) {
    throw Exception('Failed to setLogger: $e');
  }
}
