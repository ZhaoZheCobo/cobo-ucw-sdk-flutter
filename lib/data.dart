import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

class SDKConfig {
  final Env env;
  final int timeout;
  final bool debug;

  SDKConfig({
    required this.env,
    required this.timeout,
    required this.debug,
  });
}

enum Env { development, production, local}

extension EnvExtension on Env {
  String get value {
    switch (this) {
      case Env.development:
        return "development";
      case Env.production:
        return "production";
      case Env.local:
        return "local";
    }
  }
}

enum ConnCode {
  unknown(0),

  connected(1300),
  disconnected(1301),
  connectClose(1302),

  connectError(1310),
  connectURLParseError(1311),

  connectRefused(1320),
  connectFail(1321),

  connectProxyError(1350),
  connectProxyParseError(1351);

  final int value;

  const ConnCode(this.value);

  static ConnCode fromValue(int value) {
    return ConnCode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConnCode.unknown,
    );
  }
}

class ConnStatus {
  ConnCode? connCode;
  String? connMessage;

  ConnStatus({this.connCode, this.connMessage});
}

enum Status {
  unknown,
  scheduling,
  initializing,
  approving,
  processing,
  declined,
  failed,
  canceled,
  completed,
}

extension StatusExtension on Status {
  int toInt() {
    switch (this) {
      case Status.unknown:
        return 100;
      case Status.scheduling:
        return 110;
      case Status.initializing:
        return 120;
      case Status.approving:
        return 130;
      case Status.processing:
        return 140;
      case Status.declined:
        return 160;
      case Status.failed:
        return 170;
      case Status.canceled:
        return 180;
      case Status.completed:
        return 190;
    }
  }
}

enum GroupType {
  ecdsaTSS,
  eddsaTSS,
}

extension GroupTypeExtension on GroupType {
  int toInt() {
    switch (this) {
      case GroupType.ecdsaTSS:
        return 1;
      case GroupType.eddsaTSS:
        return 2;
    }
  }
}

@JsonSerializable()
class NodeResult {
  @JsonKey(name: 'tss_node_id')
  final String tssNodeID;

  NodeResult({required this.tssNodeID});

  factory NodeResult.fromJson(Map<String, dynamic> json) =>
      _$NodeResultFromJson(json);

  Map<String, dynamic> toJson() => _$NodeResultToJson(this);
}

@JsonSerializable()
class HandlerResult {
  @JsonKey(name: 'handler')
  final String handler;

  HandlerResult({required this.handler});

  factory HandlerResult.fromJson(Map<String, dynamic> json) =>
      _$HandlerResultFromJson(json);

  Map<String, dynamic> toJson() => _$HandlerResultToJson(this);
}

@JsonSerializable()
class SecretsResult {
  @JsonKey(name: 'data')
  final String data;

  SecretsResult({required this.data});

  factory SecretsResult.fromJson(Map<String, dynamic> json) =>
      _$SecretsResultFromJson(json);

  Map<String, dynamic> toJson() => _$SecretsResultToJson(this);
}

class AddressInfo {
  final String bip32Path;
  final String publicKey;

  AddressInfo({required this.bip32Path, required this.publicKey});
}

@JsonSerializable()
class RecoverResult {
  @JsonKey(name: 'data')
  final List<PrivateKeyInfo>? data;

  RecoverResult({this.data});

  factory RecoverResult.fromJson(Map<String, dynamic> json) =>
      _$RecoverResultFromJson(json);

  Map<String, dynamic> toJson() => _$RecoverResultToJson(this);
}

@JsonSerializable()
class PrivateKeyInfo {
  @JsonKey(name: 'bip32_path')
  final String bip32Path;
  @JsonKey(name: 'extended_public_key')
  final String publicKey;
  @JsonKey(name: 'private_key')
  final PrivateKey? privateKey;

  PrivateKeyInfo({
    required this.bip32Path,
    required this.publicKey,
    this.privateKey,
  });

  factory PrivateKeyInfo.fromJson(Map<String, dynamic> json) =>
      _$PrivateKeyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateKeyInfoToJson(this);
}

@JsonSerializable()
class PrivateKey {
  @JsonKey(name: 'extended_private_key')
  final String extPrivateKey;
  @JsonKey(name: 'hex_private_key')
  final String hexPrivateKey;

  PrivateKey({
    required this.extPrivateKey,
    required this.hexPrivateKey,
  });

  factory PrivateKey.fromJson(Map<String, dynamic> json) =>
      _$PrivateKeyFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateKeyToJson(this);
}

@JsonSerializable()
class SDKInfo {
  @JsonKey(name: 'version')
  final String version;

  SDKInfo({required this.version});

  factory SDKInfo.fromJson(Map<String, dynamic> json) =>
      _$SDKInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SDKInfoToJson(this);
}

@JsonSerializable()
class GroupResult {
  @JsonKey(name: 'data', fromJson: _tssKeyShareGroupListFromUntypedJson)
  final List<TSSKeyShareGroup>? data;

  GroupResult({this.data});

  static List<TSSKeyShareGroup> _tssKeyShareGroupListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => TSSKeyShareGroup.fromUntypedJson(e)).toList();
  }

  factory GroupResult.fromJson(Map<String, dynamic> json) =>
      _$GroupResultFromJson(json);

  Map<String, dynamic> toJson() => _$GroupResultToJson(this);
}

@JsonSerializable()
class TSSKeyShareGroup {
  @JsonKey(name: 'id')
  final String tssKeyShareGroupID;
  // @JsonKey(name: 'canonical_group_id')
  // final String canonicalGroupID;
  // @JsonKey(name: 'protocol_group_id')
  // final String protocolGroupID;
  // @JsonKey(name: 'protocol_type')
  // final String protocolType;
  @JsonKey(name: 'created_timestamp')
  final int createdTimestamp;
  @JsonKey(name: 'type')
  final GroupType type;
  @JsonKey(name: 'root_extended_public_key')
  final String rootPubKey;
  @JsonKey(name: 'chaincode')
  final String chainCode;
  @JsonKey(name: 'curve')
  final String curve;
  @JsonKey(name: 'threshold')
  final int threshold;
  @JsonKey(name: 'participants',
    fromJson: _sharePublicDataListFromUntypedJson)
  final List<SharePublicData>? participants;

  TSSKeyShareGroup({
    required this.tssKeyShareGroupID,
    // required this.canonicalGroupID,
    // required this.protocolGroupID,
    // required this.protocolType,
    required this.createdTimestamp,
    required this.type,
    required this.rootPubKey,
    required this.chainCode,
    required this.curve,
    required this.threshold,
    this.participants,
  });

  static List<SharePublicData> _sharePublicDataListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => SharePublicData.fromUntypedJson(e)).toList();
  }

  factory TSSKeyShareGroup.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$TSSKeyShareGroupFromJson(Map<String, dynamic>.from(json));

  factory TSSKeyShareGroup.fromJson(Map<String, dynamic> json) =>
      _$TSSKeyShareGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TSSKeyShareGroupToJson(this);
}

@JsonSerializable()
class SharePublicData {
  @JsonKey(name: 'node_id')
  final String tssNodeID;
  @JsonKey(name: 'share_id')
  final String shareID;
  @JsonKey(name: 'share_public_key')
  final String sharePubKey;

  SharePublicData({
    required this.tssNodeID,
    required this.shareID,
    required this.sharePubKey,
  });

  factory SharePublicData.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$SharePublicDataFromJson(Map<String, dynamic>.from(json));

  factory SharePublicData.fromJson(Map<String, dynamic> json) =>
      _$SharePublicDataFromJson(json);

  Map<String, dynamic> toJson() => _$SharePublicDataToJson(this);
}

@JsonSerializable()
class TSSRequestResult {
  @JsonKey(name: 'data', fromJson: _tssRequestListFromUntypedJson)
  final List<TSSRequest>? data;
 
  TSSRequestResult({this.data});

  static List<TSSRequest> _tssRequestListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => TSSRequest.fromUntypedJson(e)).toList();
  }

  factory TSSRequestResult.fromJson(Map<String, dynamic> json) =>
      _$TSSRequestResultFromJson(json);

  Map<String, dynamic> toJson() => _$TSSRequestResultToJson(this);
}

@JsonSerializable()
class TSSRequest {
  @JsonKey(name: 'tss_request_id')
  final String tssRequestID;
  @JsonKey(name: 'status')
  final Status status;
  
  // todo

  @JsonKey(name: 'results', fromJson: _tssKeyShareGroupListFromUntypedJson)
  final List<TSSKeyShareGroup>? results;
  @JsonKey(name: 'failed_reasons')
  final List<String>? failedReasons;

  TSSRequest({
    required this.tssRequestID,
    required this.status,
    
    this.results,
    this.failedReasons,
  });

  static List<TSSKeyShareGroup> _tssKeyShareGroupListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => TSSKeyShareGroup.fromUntypedJson(e)).toList();
  }

  factory TSSRequest.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$TSSRequestFromJson(Map<String, dynamic>.from(json));

  factory TSSRequest.fromJson(Map<String, dynamic> json) {
    return _$TSSRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TSSRequestToJson(this);
}

@JsonSerializable()
class TransactionResult {
  @JsonKey(name: 'data', fromJson: _transactionListFromUntypedJson)
  final List<Transaction>? data;

  TransactionResult({this.data});

  static List<Transaction> _transactionListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => Transaction.fromUntypedJson(e)).toList();
  }

  factory TransactionResult.fromJson(Map<String, dynamic> json) =>
      _$TransactionResultFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResultToJson(this);
}

@JsonSerializable()
class Transaction {
  @JsonKey(name: 'transaction_id')
  final String transactionID;
  @JsonKey(name: 'status')
  final Status status;

  // todo
  
  @JsonKey(name: 'sign_details', fromJson: _signDetailListFromUntypedJson)
  final List<SignDetail>? signDetails;
  @JsonKey(name: 'results', fromJson: _signaturesListFromUntypedJson)
  final List<Signatures>? results;
  @JsonKey(name: 'failed_reasons')
  final List<String>? failedReasons;

  Transaction({
    required this.transactionID,
    required this.status,

    this.signDetails,
    this.results,
    this.failedReasons,
  });

  static List<SignDetail> _signDetailListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => SignDetail.fromUntypedJson(e)).toList();
  }

  static List<Signatures> _signaturesListFromUntypedJson(List<dynamic>? json) {
    return (json ?? []).map((e) => Signatures.fromUntypedJson(e)).toList();
  }

  factory Transaction.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$TransactionFromJson(Map<String, dynamic>.from(json));

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class SignDetail {
  @JsonKey(name: 'signature_type')
  final int signatureType;
  @JsonKey(name: 'tss_protocol')
  final int tssProtocol;
  @JsonKey(name: 'bip32_path_list')
  final List<String>? bip32PathList;
  @JsonKey(name: 'msg_hash_list')
  final List<String>? msgHashList;
  @JsonKey(name: 'tweak_list')
  final List<String>? tweakList;

  SignDetail({
    required this.signatureType,
    required this.tssProtocol,
    this.bip32PathList,
    this.msgHashList,
    this.tweakList,
  });

  factory SignDetail.fromUntypedJson(Map<dynamic, dynamic> json) =>
    _$SignDetailFromJson(Map<String, dynamic>.from(json));

  factory SignDetail.fromJson(Map<String, dynamic> json) =>
    _$SignDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SignDetailToJson(this);
}

@JsonSerializable()
class Signatures {
  @JsonKey(name: 'signatures')
  final List<Signature>? signatures;
  @JsonKey(name: 'signature_type')
  final int? signatureType;
  @JsonKey(name: 'tss_protocol')
  final int? tssProtocol;

  Signatures({
    this.signatures,
    this.signatureType,
    this.tssProtocol,
  });

  factory Signatures.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$SignaturesFromJson(Map<String, dynamic>.from(json));

  factory Signatures.fromJson(Map<String, dynamic> json) =>
      _$SignaturesFromJson(json);

  Map<String, dynamic> toJson() => _$SignaturesToJson(this);
}

@JsonSerializable()
class Signature {
  @JsonKey(name: 'bip32_path')
  final String bip32Path;
  @JsonKey(name: 'msg_hash')
  final String msgHash;
  @JsonKey(name: 'tweak')
  final String? tweak;
  @JsonKey(name: 'signature')
  final String? signature;
  @JsonKey(name: 'signature_recovery')
  final String? signatureRecovery;

  Signature({
    required this.bip32Path,
    required this.msgHash,
    this.tweak,
    this.signature,
    this.signatureRecovery,
  });

  factory Signature.fromUntypedJson(Map<dynamic, dynamic> json) =>
      _$SignatureFromJson(Map<String, dynamic>.from(json));

  factory Signature.fromJson(Map<String, dynamic> json) =>
      _$SignatureFromJson(json);

  Map<String, dynamic> toJson() => _$SignatureToJson(this);
}
