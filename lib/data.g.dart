// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeResult _$NodeResultFromJson(Map<String, dynamic> json) => NodeResult(
      tssNodeID: json['tss_node_id'] as String,
    );

Map<String, dynamic> _$NodeResultToJson(NodeResult instance) =>
    <String, dynamic>{
      'tss_node_id': instance.tssNodeID,
    };

HandlerResult _$HandlerResultFromJson(Map<String, dynamic> json) =>
    HandlerResult(
      handler: json['handler'] as String,
    );

Map<String, dynamic> _$HandlerResultToJson(HandlerResult instance) =>
    <String, dynamic>{
      'handler': instance.handler,
    };

SecretsResult _$SecretsResultFromJson(Map<String, dynamic> json) =>
    SecretsResult(
      data: json['data'] as String,
    );

Map<String, dynamic> _$SecretsResultToJson(SecretsResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

AddressInfo _$AddressInfoFromJson(Map<String, dynamic> json) => AddressInfo(
      bip32Path: json['bip32_path'] as String,
      publicKey: json['extended_public_key'] as String?,
    );

Map<String, dynamic> _$AddressInfoToJson(AddressInfo instance) =>
    <String, dynamic>{
      'bip32_path': instance.bip32Path,
      'extended_public_key': instance.publicKey,
    };

RecoverResult _$RecoverResultFromJson(Map<String, dynamic> json) =>
    RecoverResult(
      data: RecoverResult._privateKeyInfoListFromUntypedJson(
          json['data'] as List?),
    );

Map<String, dynamic> _$RecoverResultToJson(RecoverResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

PrivateKeyInfo _$PrivateKeyInfoFromJson(Map<String, dynamic> json) =>
    PrivateKeyInfo(
      bip32Path: json['bip32_path'] as String,
      publicKey: json['extended_public_key'] as String,
      privateKey:
          PrivateKeyInfo._privateKeyFromUntypedJson(json['private_key']),
    );

Map<String, dynamic> _$PrivateKeyInfoToJson(PrivateKeyInfo instance) =>
    <String, dynamic>{
      'bip32_path': instance.bip32Path,
      'extended_public_key': instance.publicKey,
      'private_key': instance.privateKey,
    };

PrivateKey _$PrivateKeyFromJson(Map<String, dynamic> json) => PrivateKey(
      extPrivateKey: json['extended_private_key'] as String,
      hexPrivateKey: json['hex_private_key'] as String,
    );

Map<String, dynamic> _$PrivateKeyToJson(PrivateKey instance) =>
    <String, dynamic>{
      'extended_private_key': instance.extPrivateKey,
      'hex_private_key': instance.hexPrivateKey,
    };

SDKInfo _$SDKInfoFromJson(Map<String, dynamic> json) => SDKInfo(
      version: json['version'] as String,
    );

Map<String, dynamic> _$SDKInfoToJson(SDKInfo instance) => <String, dynamic>{
      'version': instance.version,
    };

GroupResult _$GroupResultFromJson(Map<String, dynamic> json) => GroupResult(
      data: GroupResult._tssKeyShareGroupListFromUntypedJson(
          json['data'] as List?),
    );

Map<String, dynamic> _$GroupResultToJson(GroupResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

TSSKeyShareGroup _$TSSKeyShareGroupFromJson(Map<String, dynamic> json) =>
    TSSKeyShareGroup(
      tssKeyShareGroupID: json['id'] as String,
      createdTimestamp: (json['created_timestamp'] as num).toInt(),
      type: GroupTypeExtension.fromInt((json['type'] as num).toInt()),
      rootPubKey: json['root_extended_public_key'] as String,
      chainCode: json['chaincode'] as String,
      curve: json['curve'] as String,
      threshold: (json['threshold'] as num).toInt(),
      participants: TSSKeyShareGroup._sharePublicDataListFromUntypedJson(
          json['participants'] as List?),
    );

Map<String, dynamic> _$TSSKeyShareGroupToJson(TSSKeyShareGroup instance) =>
    <String, dynamic>{
      'id': instance.tssKeyShareGroupID,
      'created_timestamp': instance.createdTimestamp,
      'type': _$GroupTypeEnumMap[instance.type]!,
      'root_extended_public_key': instance.rootPubKey,
      'chaincode': instance.chainCode,
      'curve': instance.curve,
      'threshold': instance.threshold,
      'participants': instance.participants,
    };

const _$GroupTypeEnumMap = {
  GroupType.ECDSA: 'ECDSA',
  GroupType.EdDSA: 'EdDSA',
};

SharePublicData _$SharePublicDataFromJson(Map<String, dynamic> json) =>
    SharePublicData(
      tssNodeID: json['node_id'] as String,
      shareID: json['share_id'] as String,
      sharePubKey: json['share_public_key'] as String,
    );

Map<String, dynamic> _$SharePublicDataToJson(SharePublicData instance) =>
    <String, dynamic>{
      'node_id': instance.tssNodeID,
      'share_id': instance.shareID,
      'share_public_key': instance.sharePubKey,
    };

TSSRequestResult _$TSSRequestResultFromJson(Map<String, dynamic> json) =>
    TSSRequestResult(
      data: TSSRequestResult._tssRequestListFromUntypedJson(
          json['data'] as List?),
    );

Map<String, dynamic> _$TSSRequestResultToJson(TSSRequestResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

TSSRequest _$TSSRequestFromJson(Map<String, dynamic> json) => TSSRequest(
      tssRequestID: json['tss_request_id'] as String,
      status: StatusExtension.fromInt((json['status'] as num).toInt()),
      results: TSSRequest._tssKeyShareGroupListFromUntypedJson(
          json['results'] as List?),
      failedReasons: (json['failed_reasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TSSRequestToJson(TSSRequest instance) =>
    <String, dynamic>{
      'tss_request_id': instance.tssRequestID,
      'status': _$StatusEnumMap[instance.status]!,
      'results': instance.results,
      'failed_reasons': instance.failedReasons,
    };

const _$StatusEnumMap = {
  Status.unknown: 'unknown',
  Status.scheduling: 'scheduling',
  Status.initializing: 'initializing',
  Status.approving: 'approving',
  Status.processing: 'processing',
  Status.declined: 'declined',
  Status.failed: 'failed',
  Status.canceled: 'canceled',
  Status.completed: 'completed',
};

TransactionResult _$TransactionResultFromJson(Map<String, dynamic> json) =>
    TransactionResult(
      data: TransactionResult._transactionListFromUntypedJson(
          json['data'] as List?),
    );

Map<String, dynamic> _$TransactionResultToJson(TransactionResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transactionID: json['transaction_id'] as String,
      status: StatusExtension.fromInt((json['status'] as num).toInt()),
      signDetails: Transaction._signDetailListFromUntypedJson(
          json['sign_details'] as List?),
      results:
          Transaction._signaturesListFromUntypedJson(json['results'] as List?),
      failedReasons: (json['failed_reasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionID,
      'status': _$StatusEnumMap[instance.status]!,
      'sign_details': instance.signDetails,
      'results': instance.results,
      'failed_reasons': instance.failedReasons,
    };

SignDetail _$SignDetailFromJson(Map<String, dynamic> json) => SignDetail(
      signatureType: SignatureTypeExtension.fromInt(
          (json['signature_type'] as num?)?.toInt()),
      tssProtocol:
          TssProtocolExtension.fromInt((json['tss_protocol'] as num?)?.toInt()),
      bip32PathList: (json['bip32_path_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      msgHashList: (json['msg_hash_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tweakList: (json['tweak_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SignDetailToJson(SignDetail instance) =>
    <String, dynamic>{
      'signature_type': _$SignatureTypeEnumMap[instance.signatureType]!,
      'tss_protocol': _$TssProtocolEnumMap[instance.tssProtocol]!,
      'bip32_path_list': instance.bip32PathList,
      'msg_hash_list': instance.msgHashList,
      'tweak_list': instance.tweakList,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.Unknown: 'Unknown',
  SignatureType.ECDSA: 'ECDSA',
  SignatureType.EdDSA: 'EdDSA',
  SignatureType.Schnorr: 'Schnorr',
};

const _$TssProtocolEnumMap = {
  TssProtocol.Default: 'Default',
  TssProtocol.GG18: 'GG18',
  TssProtocol.Lindell: 'Lindell',
  TssProtocol.EdDSATSS: 'EdDSATSS',
};

Signatures _$SignaturesFromJson(Map<String, dynamic> json) => Signatures(
      signatures:
          Signatures._signatureListFromUntypedJson(json['signatures'] as List?),
      signatureType: SignatureTypeExtension.fromInt(
          (json['signature_type'] as num?)?.toInt()),
      tssProtocol:
          TssProtocolExtension.fromInt((json['tss_protocol'] as num?)?.toInt()),
    );

Map<String, dynamic> _$SignaturesToJson(Signatures instance) =>
    <String, dynamic>{
      'signatures': instance.signatures,
      'signature_type': _$SignatureTypeEnumMap[instance.signatureType],
      'tss_protocol': _$TssProtocolEnumMap[instance.tssProtocol],
    };

Signature _$SignatureFromJson(Map<String, dynamic> json) => Signature(
      bip32Path: json['bip32_path'] as String,
      msgHash: json['msg_hash'] as String,
      tweak: json['tweak'] as String?,
      signature: json['signature'] as String?,
      signatureRecovery: json['signature_recovery'] as String?,
    );

Map<String, dynamic> _$SignatureToJson(Signature instance) => <String, dynamic>{
      'bip32_path': instance.bip32Path,
      'msg_hash': instance.msgHash,
      'tweak': instance.tweak,
      'signature': instance.signature,
      'signature_recovery': instance.signatureRecovery,
    };
