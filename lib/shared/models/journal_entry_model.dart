import 'package:json_annotation/json_annotation.dart';

part 'journal_entry_model.g.dart';

@JsonSerializable()
class JournalEntryModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String>? tags;
  final String? aiSummary;
  final List<String>? aiAffirmations;
  final double? sentimentScore;
  final String? dominantEmotion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags,
    this.aiSummary,
    this.aiAffirmations,
    this.sentimentScore,
    this.dominantEmotion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$JournalEntryModelToJson(this);
}
