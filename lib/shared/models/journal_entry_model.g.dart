// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) =>
    JournalEntryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      aiSummary: json['ai_summary'] as String? ?? json['aiSummary'] as String?,
      aiAffirmations: (json['ai_affirmations'] as List<dynamic>? ?? json['aiAffirmations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sentimentScore: (json['sentiment_score'] as num?)?.toDouble() ?? (json['sentimentScore'] as num?)?.toDouble(),
      dominantEmotion: json['dominant_emotion'] as String? ?? json['dominantEmotion'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? json['updatedAt'] as String),
    );

Map<String, dynamic> _$JournalEntryModelToJson(JournalEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'ai_summary': instance.aiSummary,
      'ai_affirmations': instance.aiAffirmations,
      'sentiment_score': instance.sentimentScore,
      'dominant_emotion': instance.dominantEmotion,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
