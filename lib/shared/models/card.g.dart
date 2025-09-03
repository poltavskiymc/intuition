// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardImpl _$$CardImplFromJson(Map<String, dynamic> json) => _$CardImpl(
      id: json['id'] as String,
      factId: json['factId'] as String,
      isSecret: json['isSecret'] as bool,
      isRevealed: json['isRevealed'] as bool? ?? false,
      isClickable: json['isClickable'] as bool? ?? false,
    );

Map<String, dynamic> _$$CardImplToJson(_$CardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'factId': instance.factId,
      'isSecret': instance.isSecret,
      'isRevealed': instance.isRevealed,
      'isClickable': instance.isClickable,
    };
