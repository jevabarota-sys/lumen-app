// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) =>
    JournalEntryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      aiSummary: json['aiSummary'] as String?,
      aiAffirmations: (json['aiAffirmations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JournalEntryModelToJson(JournalEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'aiSummary': instance.aiSummary,
      'aiAffirmations': instance.aiAffirmations,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
