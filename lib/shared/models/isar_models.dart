import 'package:isar/isar.dart';
import 'package:intuition/shared/utils/json_utils.dart';

part 'isar_models.g.dart';

@collection
class Game {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;
  late String personIds; // JSON string of List<String>
  @enumerated
  late GameStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Game({
    required this.name,
    this.description,
    this.personIds = '[]',
    this.status = GameStatus.draft,
    this.createdAt,
    this.updatedAt,
  });

  Game copyWith({
    String? name,
    String? description,
    String? personIds,
    GameStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Game(
      name: name ?? this.name,
      description: description ?? this.description,
      personIds: personIds ?? this.personIds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@collection
class Person {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;
  late String gameId;
  late String factIds; // JSON string of List<String>
  DateTime? createdAt;
  DateTime? updatedAt;

  Person({
    required this.name,
    this.description,
    required this.gameId,
    this.factIds = '[]',
    this.createdAt,
    this.updatedAt,
  });

  Person copyWith({
    String? name,
    String? description,
    String? gameId,
    String? factIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Person(
      name: name ?? this.name,
      description: description ?? this.description,
      gameId: gameId ?? this.gameId,
      factIds: factIds ?? this.factIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@collection
class Fact {
  Id id = Isar.autoIncrement;

  late String text;
  late bool isSecret; // true for secret, false for hint
  late String personId;
  late bool isRevealed;
  DateTime? createdAt;
  DateTime? updatedAt;

  Fact({
    required this.text,
    required this.isSecret,
    required this.personId,
    required this.isRevealed,
    this.createdAt,
    this.updatedAt,
  });

  Fact copyWith({
    String? text,
    bool? isSecret,
    String? personId,
    bool? isRevealed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Fact(
      text: text ?? this.text,
      isSecret: isSecret ?? this.isSecret,
      personId: personId ?? this.personId,
      isRevealed: isRevealed ?? this.isRevealed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@collection
class GameSession {
  Id id = Isar.autoIncrement;

  late String gameId;
  late String targetPersonId;
  late String firstFactId;
  late String revealedFactIds; // JSON string of List<String>
  @enumerated
  late GameSessionStatus status;
  DateTime? startedAt;
  DateTime? completedAt;

  GameSession({
    required this.gameId,
    required this.targetPersonId,
    required this.firstFactId,
    this.revealedFactIds = '[]',
    this.status = GameSessionStatus.active,
    this.startedAt,
    this.completedAt,
  });

  GameSession copyWith({
    String? gameId,
    String? targetPersonId,
    String? firstFactId,
    String? revealedFactIds,
    GameSessionStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return GameSession(
      gameId: gameId ?? this.gameId,
      targetPersonId: targetPersonId ?? this.targetPersonId,
      firstFactId: firstFactId ?? this.firstFactId,
      revealedFactIds: revealedFactIds ?? this.revealedFactIds,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum GameStatus { draft, published, archived }

enum GameSessionStatus { active, completed, abandoned }

// Extension methods for convenient work with JSON strings
extension GameExtensions on Game {
  List<String> get personIdsList => JsonUtils.stringToList(personIds);
  set personIdsList(List<String> list) =>
      personIds = JsonUtils.listToString(list);

  void addPersonId(String personId) {
    personIds = JsonUtils.addToList(personIds, personId);
  }

  void removePersonId(String personId) {
    personIds = JsonUtils.removeFromList(personIds, personId);
  }
}

extension PersonExtensions on Person {
  List<String> get factIdsList => JsonUtils.stringToList(factIds);
  set factIdsList(List<String> list) => factIds = JsonUtils.listToString(list);

  void addFactId(String factId) {
    factIds = JsonUtils.addToList(factIds, factId);
  }

  void removeFactId(String factId) {
    factIds = JsonUtils.removeFromList(factIds, factId);
  }
}

extension GameSessionExtensions on GameSession {
  List<String> get revealedFactIdsList =>
      JsonUtils.stringToList(revealedFactIds);
  set revealedFactIdsList(List<String> list) =>
      revealedFactIds = JsonUtils.listToString(list);

  void addRevealedFactId(String factId) {
    revealedFactIds = JsonUtils.addToList(revealedFactIds, factId);
  }

  void removeRevealedFactId(String factId) {
    revealedFactIds = JsonUtils.removeFromList(revealedFactIds, factId);
  }
}
