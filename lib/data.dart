import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

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
class GroupResult {
  @JsonKey(name: 'data')
  final List<TSSKeyShareGroup>? data;

  GroupResult({this.data});

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
  final String createdTimestamp;
  // @JsonKey(name: 'type')
  // final GroupType type;
  @JsonKey(name: 'root_extended_public_key')
  final String rootPubKey;
  @JsonKey(name: 'chaincode')
  final String chainCode;
  @JsonKey(name: 'curve')
  final String curve;
  @JsonKey(name: 'threshold')
  final int threshold;
  // @JsonKey(name: 'participants',
  //   fromJson: _sharePublicDataListFromUntypedJson)
  // final List<SharePublicData>? participants;

  TSSKeyShareGroup({
    required this.tssKeyShareGroupID,
    // required this.canonicalGroupID,
    // required this.protocolGroupID,
    // required this.protocolType,
    required this.createdTimestamp,
    // required this.type,
    required this.rootPubKey,
    required this.chainCode,
    required this.curve,
    required this.threshold,
    // this.participants,
  });

  // static List<SharePublicData> _sharePublicDataListFromUntypedJson(List<dynamic>? json) {
  //   return (json ?? []).map((e) => SharePublicData.fromUntypedJson(e)).toList();
  // }

  // factory TSSKeyShareGroup.fromUntypedJson(Map<dynamic, dynamic> json) =>
  //     _$GroupPublicInfoFromJson(Map<String, dynamic>.from(json));

  factory TSSKeyShareGroup.fromJson(Map<String, dynamic> json) =>
      _$TSSKeyShareGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TSSKeyShareGroupToJson(this);
}
