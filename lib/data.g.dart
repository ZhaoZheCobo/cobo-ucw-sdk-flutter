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
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TSSRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
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
