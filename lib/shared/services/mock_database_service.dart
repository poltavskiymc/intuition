import '../models/isar_models.dart';

class MockDatabaseService {
  static final List<Game> _games = [];
  static final List<Person> _persons = [];
  static final List<Fact> _facts = [];
  static final List<GameSession> _sessions = [];

  static Future<void> initialize() async {
    // Создаем тестовые данные
    _createMockData();
  }

  static void _createMockData() {
    // Создаем тестовую игру
    final game = Game(
      name: 'День рождения Игоря',
      description: 'Угадайте друзей Игоря по фактам',
      personIds: '["1", "2"]',
    );
    _games.add(game);

    // Создаем тестовых персонажей
    final person1 = Person(
      name: 'Алексей',
      description: 'Лучший друг Игоря',
      gameId: '1',
      factIds: '["1", "2"]',
    );
    _persons.add(person1);

    final person2 = Person(
      name: 'Мария',
      description: 'Коллега Игоря',
      gameId: '1',
      factIds: '["3", "4"]',
    );
    _persons.add(person2);

    // Создаем тестовые факты
    final facts = [
      Fact(
        text: 'Любит играть в футбол',
        isSecret: true,
        personId: '1',
        isRevealed: false,
      ),
      Fact(
        text: 'Работает программистом',
        isSecret: false,
        personId: '1',
        isRevealed: false,
      ),
      Fact(
        text: 'Живет в Москве',
        isSecret: true,
        personId: '2',
        isRevealed: false,
      ),
      Fact(
        text: 'Изучает английский язык',
        isSecret: false,
        personId: '2',
        isRevealed: false,
      ),
    ];
    _facts.addAll(facts);
  }

  // Методы для работы с играми
  static List<Game> getAllGames() => List.from(_games);
  static Game? getGameById(String id) =>
      _games.firstWhere((g) => g.id.toString() == id);

  // Методы для работы с персонажами
  static List<Person> getPersonsByGameId(String gameId) =>
      _persons.where((p) => p.gameId == gameId).toList();
  static Person? getPersonById(String id) =>
      _persons.firstWhere((p) => p.id.toString() == id);

  // Методы для работы с фактами
  static List<Fact> getFactsByPersonId(String personId) =>
      _facts.where((f) => f.personId == personId).toList();
  static List<Fact> getAllFacts() => List.from(_facts);

  // Методы для работы с сессиями
  static List<GameSession> getAllSessions() => List.from(_sessions);
  static GameSession? getSessionById(String id) =>
      _sessions.firstWhere((s) => s.id.toString() == id);

  static Future<void> close() async {
    // Очищаем данные
    _games.clear();
    _persons.clear();
    _facts.clear();
    _sessions.clear();
  }
}
