import 'package:json_annotation/json_annotation.dart';

part 'tarot_draw_model.g.dart';

enum TarotSpreadType { oneCard, threeCard }

@JsonSerializable()
class TarotDrawModel {
  final String id;
  final String userId;
  final TarotSpreadType spreadType;
  final List<TarotCard> cards;
  final String? aiReflection;
  final DateTime drawDate;
  final DateTime createdAt;
  
  const TarotDrawModel({
    required this.id,
    required this.userId,
    required this.spreadType,
    required this.cards,
    this.aiReflection,
    required this.drawDate,
    required this.createdAt,
  });
  
  factory TarotDrawModel.fromJson(Map<String, dynamic> json) => _$TarotDrawModelFromJson(json);
  Map<String, dynamic> toJson() => _$TarotDrawModelToJson(this);
}

@JsonSerializable()
class TarotCard {
  final String name;
  final String description;
  final String imageUrl;
  final String position;
  final bool isReversed;
  
  const TarotCard({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.position,
    this.isReversed = false,
  });
  
  factory TarotCard.fromJson(Map<String, dynamic> json) => _$TarotCardFromJson(json);
  Map<String, dynamic> toJson() => _$TarotCardToJson(this);
}
