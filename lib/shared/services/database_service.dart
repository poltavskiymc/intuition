import 'package:isar/isar.dart';
import 'package:intuition/shared/models/isar_models.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/shared/utils/json_utils.dart';

class DatabaseService {
  static Isar? _isar;

  static Future<void> initialize() async {
    _isar = await Isar.open([
      GameSchema,
      PersonSchema,
      FactSchema,
      GameSessionSchema,
    ], directory: '');
  }

  static Future<void> close() async {
    await _isar?.close();
  }

  // Сохранение игры
  static Future<Game> saveGame(GameCreationData gameData) async {
    if (_isar == null) throw Exception('Database not initialized');

    final isar = _isar!;

    // Создаем игру
    final game = Game(
      name: gameData.name,
      description:
          gameData.description.isNotEmpty ? gameData.description : null,
      personIds: '[]', // Будем обновлять после создания персонажей
    );

    await isar.writeTxn(() async {
      await isar.games.put(game);
    });

    final personIds = <String>[];
    final factIds = <String>[];

    // Создаем персонажей и факты
    for (final personData in gameData.persons) {
      final person = Person(
        name: personData.name,
        gameId: game.id.toString(),
        factIds: '[]', // Будем обновлять после создания фактов
      );

      await isar.writeTxn(() async {
        await isar.persons.put(person);
      });

      personIds.add(person.id.toString());

      // Создаем факты для этого персонажа
      final personFactIds = <String>[];
      for (final factData in personData.facts) {
        final fact = Fact(
          text: factData.text,
          isSecret: factData.isSecret,
          personId: person.id.toString(),
          isRevealed: false,
          isStartFact: factData.isStartFact,
        );

        await isar.writeTxn(() async {
          await isar.facts.put(fact);
        });

        personFactIds.add(fact.id.toString());
        factIds.add(fact.id.toString());
      }

      // Обновляем personIds у персонажа
      person.factIds = JsonUtils.listToString(personFactIds);
      await isar.writeTxn(() async {
        await isar.persons.put(person);
      });
    }

    // Обновляем personIds у игры
    game.personIds = JsonUtils.listToString(personIds);
    await isar.writeTxn(() async {
      await isar.games.put(game);
    });

    return game;
  }

  // Обновление игры
  static Future<Game> updateGame(
    String gameId,
    GameCreationData gameData,
  ) async {
    if (_isar == null) throw Exception('Database not initialized');

    final isar = _isar!;

    // Находим существующую игру
    final existingGame = await isar.games.get(int.parse(gameId));
    if (existingGame == null) throw Exception('Game not found');

    // Удаляем старых персонажей и их факты
    final oldPersonIds = JsonUtils.stringToList(existingGame.personIds);
    for (final personId in oldPersonIds) {
      final person = await isar.persons.get(int.parse(personId));
      if (person != null) {
        final factIds = JsonUtils.stringToList(person.factIds);
        for (final factId in factIds) {
          await isar.writeTxn(() async {
            await isar.facts.delete(int.parse(factId));
          });
        }
        await isar.writeTxn(() async {
          await isar.persons.delete(int.parse(personId));
        });
      }
    }

    // Обновляем игру
    existingGame.name = gameData.name;
    existingGame.description =
        gameData.description.isNotEmpty ? gameData.description : null;
    existingGame.personIds = '[]';

    await isar.writeTxn(() async {
      await isar.games.put(existingGame);
    });

    // Создаем новых персонажей и факты (как в saveGame)
    final personIds = <String>[];

    for (final personData in gameData.persons) {
      final person = Person(
        name: personData.name,
        gameId: existingGame.id.toString(),
        factIds: '[]',
      );

      await isar.writeTxn(() async {
        await isar.persons.put(person);
      });

      personIds.add(person.id.toString());

      // Создаем факты для этого персонажа
      final personFactIds = <String>[];
      for (final factData in personData.facts) {
        final fact = Fact(
          text: factData.text,
          isSecret: factData.isSecret,
          personId: person.id.toString(),
          isRevealed: false,
          isStartFact: factData.isStartFact,
        );

        await isar.writeTxn(() async {
          await isar.facts.put(fact);
        });

        personFactIds.add(fact.id.toString());
      }

      // Обновляем personIds у персонажа
      person.factIds = JsonUtils.listToString(personFactIds);
      await isar.writeTxn(() async {
        await isar.persons.put(person);
      });
    }

    // Обновляем personIds у игры
    existingGame.personIds = JsonUtils.listToString(personIds);
    await isar.writeTxn(() async {
      await isar.games.put(existingGame);
    });

    return existingGame;
  }

  // Получение всех игр
  static Future<List<Game>> getAllGames() async {
    if (_isar == null) throw Exception('Database not initialized');
    return await _isar!.games.where().findAll();
  }

  // Получение игры по ID
  static Future<Game?> getGameById(String id) async {
    if (_isar == null) throw Exception('Database not initialized');
    return await _isar!.games.get(int.parse(id));
  }

  // Получение персонажа по ID
  static Future<Person?> getPersonById(String id) async {
    if (_isar == null) throw Exception('Database not initialized');
    return await _isar!.persons.get(int.parse(id));
  }

  // Получение факта по ID
  static Future<Fact?> getFactById(String id) async {
    if (_isar == null) throw Exception('Database not initialized');
    return await _isar!.facts.get(int.parse(id));
  }

  // Получение всех фактов
  static Future<List<Fact>> getAllFacts() async {
    if (_isar == null) throw Exception('Database not initialized');
    return await _isar!.facts.where().findAll();
  }
}
