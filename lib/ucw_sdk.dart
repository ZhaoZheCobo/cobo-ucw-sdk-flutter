import 'package:ucw_sdk/ucw_sdk_event_channel.dart';
import 'ucw_sdk_platform_interface.dart';
import 'package:ucw_sdk/data.dart';
import 'dart:convert';

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

  static Future<UCWPublic> create({required String secretsFile}) async {
    final instance = UCWPublic(secretsFile: secretsFile);
    await instance._openPublic();
    return instance;
  }

  void dispose() async {
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
  ConnStatus? connStatus;
  Function(ConnCode connCode, String connMessage)? _connCallback;

  UCW({
    required super.secretsFile,
    required this.config,
  });

  static Future<UCW> create({
    required String secretsFile,
    required SDKConfig config,
    required String passphrase,
    Function(ConnCode connCode, String connMessage)? connCallback,
  }) async {
    final instance = UCW(secretsFile: secretsFile, config: config);
    await instance._init(passphrase, connCallback);
    return instance;
  }

  Future<void> _init(String passphrase, Function(ConnCode connCode, String connMessage)? connCallback) async {
    connStatus = ConnStatus(connCode: ConnCode.unknown, connMessage: null);
    _connCallback = connCallback;
    connListener ??= ConnListener();
    connListener?.registerConnCallback(_innerConnCallback);
    await _open(passphrase);
  }

  Future<void> _innerConnCallback(ConnCode connCode, String connMessage) async {
    connStatus = ConnStatus(connCode: connCode, connMessage: connMessage);
    if (_connCallback != null) {
      try {
        _connCallback!(connCode, connMessage);
      } catch (e) {
        throw Exception('Error in connection callback: $e');
      }
    }
  }

  @override
  void dispose() async {
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

  ConnStatus? getConnStatus() {
    return connStatus;
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

  Future<String> exportSecrets(String exportPassphrase) async {
    try {
      final arguments = {
        'handler': handler,
        'exportPassphrase': exportPassphrase,
      };
      final result = await _call('exportSecrets', arguments);
      if (result == null) {
          throw Exception('Received null result');
      }
      final secretsResult = SecretsResult.fromJson(Map<String, dynamic>.from(result));
      return secretsResult.data;
    } catch (e) {
      throw Exception('Failed to exportSecrets: $e');
    }
  }

  Future<String> exportRecoveryKeyShares(List<String> tssKeyShareGroupIDs, String exportPassphrase) async {
    try {
      final arguments = {
        'handler': handler,
        'tssKeyShareGroupIDs': tssKeyShareGroupIDs,
        'exportPassphrase': exportPassphrase,
      };
      final result = await _call('exportRecoveryKeyShares', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final secretsResult = SecretsResult.fromJson(Map<String, dynamic>.from(result));
      return secretsResult.data;
    } catch (e) {
      throw Exception('Failed to exportRecoveryKeyShares: $e');
    }
  }
}


class UCWRecoverKey {
  final String tssKeyShareGroupID;

  UCWRecoverKey({required this.tssKeyShareGroupID});

  void dispose() {
    _cleanRecoveryKeyShares();
  }

 Future<void> _cleanRecoveryKeyShares() async {
    try {
      await _call('cleanRecoveryKeyShares');
    } catch (e) {
      throw Exception('Failed to cleanRecoveryKeyShares: $e');
    }
  }

  Future<void> importRecoveryKeyShare(String jsonRecoverySecrets, String exportPassphrase) async {
    try {
      final arguments = {
        'tssKeyShareGroupID': tssKeyShareGroupID,
        'jsonRecoverySecrets': jsonRecoverySecrets,
        'exportPassphrase': exportPassphrase,
      };
      await _call('importRecoveryKeyShare', arguments);
    } catch (e) {
      throw Exception('Failed to importRecoveryKeyShare: $e');
    }
  }

  Future<List<PrivateKeyInfo>> recoverPrivateKeys(List<AddressInfo> addressInfos) async {
    try {
      String jsonAddressInfos = jsonEncode(addressInfos.map((e) => e.toJson()).toList());
      final arguments = {
        'tssKeyShareGroupID': tssKeyShareGroupID,
        'jsonAddressInfos': jsonAddressInfos,
      };
      final result = await _call('recoverPrivateKeys', arguments);
      if (result == null) {
        throw Exception('Received null result');
      }
      final recoverResult = RecoverResult.fromJson(Map<String, dynamic>.from(result));
      return recoverResult.data ?? [];
    } catch (e) {
      throw Exception('Failed to recoverPrivateKeys: $e');
    }
  }
}

Future<String> importSecrets(String jsonRecoverySecrets, String exportPassphrase, String newSecretsFile, String newPassphrase) async {
  try {
    final Map<String, dynamic> arguments = {
      'jsonRecoverySecrets': jsonRecoverySecrets,
      'exportPassphrase': exportPassphrase,
      'newSecretsFile': newSecretsFile,
      'newPassphrase': newPassphrase,
    };
    final result = await _call('importSecrets', arguments);
    if (result == null) {
      throw Exception('Received null result');
    }
    final nodeResult = NodeResult.fromJson(Map<String, dynamic>.from(result));
    return nodeResult.tssNodeID;
  } catch (e) {
    throw Exception('Failed to importSecrets: $e');
  }
}

Future<SDKInfo> getSDKInfo() async {
  try {
    final result = await _call('getSDKInfo');
    if (result == null) {
      throw Exception('Received null result');
    }
    final sdkInfoResult = SDKInfo.fromJson(Map<String, dynamic>.from(result));
    return sdkInfoResult;
  } catch (e) {
    throw Exception('Failed to getSDKInfo: $e');
  }
}

Future<void> setLogger(Function(String level, String message)? logCallback) async {
  if (logCallback != null) {
    logListener ??= LogListener();
    logListener?.registerLogCallback(logCallback);
  } else {
    logListener?.unregisterLogCallback();
  }
}
