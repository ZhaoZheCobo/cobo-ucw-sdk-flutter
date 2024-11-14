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

RecoverResult _$RecoverResultFromJson(Map<String, dynamic> json) =>
    RecoverResult(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PrivateKeyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecoverResultToJson(RecoverResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

PrivateKeyInfo _$PrivateKeyInfoFromJson(Map<String, dynamic> json) =>
    PrivateKeyInfo(
      bip32Path: json['bip32_path'] as String,
      publicKey: json['extended_public_key'] as String,
      privateKey: json['private_key'] == null
          ? null
          : PrivateKey.fromJson(json['private_key'] as Map<String, dynamic>),
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
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TSSKeyShareGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupResultToJson(GroupResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

TSSKeyShareGroup _$TSSKeyShareGroupFromJson(Map<String, dynamic> json) =>
    TSSKeyShareGroup(
      tssKeyShareGroupID: json['id'] as String,
      createdTimestamp: json['created_timestamp'] as String,
      rootPubKey: json['root_extended_public_key'] as String,
      chainCode: json['chaincode'] as String,
      curve: json['curve'] as String,
      threshold: json['threshold'] as int,
    );

Map<String, dynamic> _$TSSKeyShareGroupToJson(TSSKeyShareGroup instance) =>
    <String, dynamic>{
      'id': instance.tssKeyShareGroupID,
      'created_timestamp': instance.createdTimestamp,
      'root_extended_public_key': instance.rootPubKey,
      'chaincode': instance.chainCode,
      'curve': instance.curve,
      'threshold': instance.threshold,
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
      status: $enumDecode(_$StatusEnumMap, json['status']),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => TSSKeyShareGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionResultToJson(TransactionResult instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transactionID: json['transaction_id'] as String,
      status: $enumDecode(_$StatusEnumMap, json['status']),
      failedReasons: (json['failed_reasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionID,
      'status': _$StatusEnumMap[instance.status]!,
      'failed_reasons': instance.failedReasons,
    };
