// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compatibility_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompatibilityResultModel _$CompatibilityResultModelFromJson(
        Map<String, dynamic> json) =>
    CompatibilityResultModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      person1Name: json['person1Name'] as String,
      person2Name: json['person2Name'] as String,
      compatibilityType: json['compatibilityType'] as String,
      overallScore: (json['overallScore'] as num).toInt(),
      details: json['details'] as Map<String, dynamic>,
      insights:
          (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
      advice: json['advice'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CompatibilityResultModelToJson(
        CompatibilityResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'person1Name': instance.person1Name,
      'person2Name': instance.person2Name,
      'compatibilityType': instance.compatibilityType,
      'overallScore': instance.overallScore,
      'details': instance.details,
      'insights': instance.insights,
      'advice': instance.advice,
      'createdAt': instance.createdAt.toIso8601String(),
    };
