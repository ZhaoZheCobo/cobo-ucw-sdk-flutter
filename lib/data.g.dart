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
