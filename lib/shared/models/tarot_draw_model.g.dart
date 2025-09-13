// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarot_draw_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TarotDrawModel _$TarotDrawModelFromJson(Map<String, dynamic> json) =>
    TarotDrawModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      spreadType: $enumDecode(_$TarotSpreadTypeEnumMap, json['spreadType']),
      cards: (json['cards'] as List<dynamic>)
          .map((e) => TarotCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiReflection: json['aiReflection'] as String?,
      drawDate: DateTime.parse(json['drawDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TarotDrawModelToJson(TarotDrawModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'spreadType': _$TarotSpreadTypeEnumMap[instance.spreadType]!,
      'cards': instance.cards,
      'aiReflection': instance.aiReflection,
      'drawDate': instance.drawDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TarotSpreadTypeEnumMap = {
  TarotSpreadType.oneCard: 'oneCard',
  TarotSpreadType.threeCard: 'threeCard',
};

TarotCard _$TarotCardFromJson(Map<String, dynamic> json) => TarotCard(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      position: json['position'] as String,
      isReversed: json['isReversed'] as bool? ?? false,
    );

Map<String, dynamic> _$TarotCardToJson(TarotCard instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'position': instance.position,
      'isReversed': instance.isReversed,
    };
