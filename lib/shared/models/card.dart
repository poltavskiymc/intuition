import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
class Card with _$Card {
  const factory Card({
    required String id,
    required String factId,
    required bool isSecret, // true for secret, false for hint
    @Default(false) bool isRevealed,
    @Default(false) bool isClickable,
  }) = _Card;

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}

enum CardType { secret, hint }

extension CardTypeExtension on CardType {
  bool get isSecretType => this == CardType.secret;
  bool get isHintType => this == CardType.hint;
}
