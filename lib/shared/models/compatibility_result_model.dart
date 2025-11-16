import 'package:json_annotation/json_annotation.dart';

part 'compatibility_result_model.g.dart';

@JsonSerializable()
class CompatibilityResultModel {
  final String id;
  final String userId;
  final String person1Name;
  final String person2Name;
  final String compatibilityType;
  final int overallScore;
  final Map<String, dynamic> details;
  final List<String> insights;
  final String advice;
  final DateTime createdAt;

  const CompatibilityResultModel({
    required this.id,
    required this.userId,
    required this.person1Name,
    required this.person2Name,
    required this.compatibilityType,
    required this.overallScore,
    required this.details,
    required this.insights,
    required this.advice,
    required this.createdAt,
  });

  factory CompatibilityResultModel.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompatibilityResultModelToJson(this);
}
