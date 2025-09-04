import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/save_game_button.dart';
import 'package:intuition/features/game_selection/providers/games_provider.dart';
import 'package:intuition/shared/models/isar_models.dart';
import 'package:intuition/shared/services/database_service.dart';
import 'package:intuition/shared/utils/json_utils.dart';

part 'game_creation_provider.g.dart';

@Riverpod(keepAlive: true)
class GameCreation extends _$GameCreation {
  @override
  GameCreationData build() {
    return GameCreationData();
  }

  SaveButtonState _saveState = SaveButtonState.ready;
  String? _errorMessage;

  SaveButtonState get saveState => _saveState;
  String? get errorMessage => _errorMessage;

  /// Обновить название игры
  void updateGameName(String name) {
    state = state.copyWith(name: name);
  }

  /// Обновить описание игры
  void updateGameDescription(String description) {
    state = state.copyWith(description: description);
  }

  /// Добавить персонажа
  void addPerson() {
    final persons = List<PersonData>.from(state.persons);
    persons.add(PersonData());
    state = state.copyWith(persons: persons);
  }

  /// Удалить персонажа
  void removePerson(int index) {
    final persons = List<PersonData>.from(state.persons);
    persons.removeAt(index);
    state = state.copyWith(persons: persons);
    _updateStartFactIndex();
  }

  /// Обновить имя персонажа
  void updatePersonName(int personIndex, String name) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length) {
      persons[personIndex] = persons[personIndex].copyWith(name: name);
      state = state.copyWith(persons: persons);
    }
  }

  /// Добавить факт к персонажу
  void addFact(int personIndex) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length) {
      final facts = List<FactData>.from(persons[personIndex].facts);
      facts.add(FactData());
      persons[personIndex] = persons[personIndex].copyWith(facts: facts);
      state = state.copyWith(persons: persons);
    }
  }

  /// Удалить факт у персонажа
  void removeFact(int personIndex, int factIndex) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length) {
      final facts = List<FactData>.from(persons[personIndex].facts);
      facts.removeAt(factIndex);
      persons[personIndex] = persons[personIndex].copyWith(facts: facts);
      state = state.copyWith(persons: persons);
      _updateStartFactIndex();
    }
  }

  /// Обновить текст факта
  void updateFactText(int personIndex, int factIndex, String text) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length &&
        factIndex < persons[personIndex].facts.length) {
      final facts = List<FactData>.from(persons[personIndex].facts);
      facts[factIndex] = facts[factIndex].copyWith(text: text);
      persons[personIndex] = persons[personIndex].copyWith(facts: facts);
      state = state.copyWith(persons: persons);
    }
  }

  /// Обновить тип факта (секретный/обычный)
  void updateFactType(int personIndex, int factIndex, bool isSecret) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length &&
        factIndex < persons[personIndex].facts.length) {
      final facts = List<FactData>.from(persons[personIndex].facts);
      facts[factIndex] = facts[factIndex].copyWith(isSecret: isSecret);
      persons[personIndex] = persons[personIndex].copyWith(facts: facts);
      state = state.copyWith(persons: persons);
    }
  }

  /// Установить стартовый факт для персонажа
  void setPersonStartFact(int personIndex, int factIndex) {
    final persons = List<PersonData>.from(state.persons);
    if (personIndex < persons.length &&
        factIndex < persons[personIndex].facts.length) {
      // Сначала сбрасываем все стартовые факты у этого персонажа
      final facts =
          persons[personIndex].facts
              .map((fact) => fact.copyWith(isStartFact: false))
              .toList();

      // Устанавливаем выбранный факт как стартовый
      facts[factIndex] = facts[factIndex].copyWith(isStartFact: true);

      persons[personIndex] = persons[personIndex].copyWith(facts: facts);
      state = state.copyWith(persons: persons);
    }
  }

  /// Получить глобальный индекс факта
  int getFactGlobalIndex(int personIndex, int factIndex) {
    int globalIndex = 0;
    for (int i = 0; i < personIndex; i++) {
      globalIndex += state.persons[i].facts.length;
    }
    return globalIndex + factIndex;
  }

  /// Обновить индекс стартового факта при удалении элементов
  void _updateStartFactIndex() {
    int currentIndex = 0;
    for (int i = 0; i < state.persons.length; i++) {
      for (int j = 0; j < state.persons[i].facts.length; j++) {
        if (currentIndex == state.selectedStartFactIndex) {
          return; // Индекс все еще валиден
        }
        currentIndex++;
      }
    }
    // Если дошли сюда, значит индекс больше не валиден
    state = state.copyWith(selectedStartFactIndex: -1);
  }

  /// Валидация данных
  List<String> validate() {
    return state.validate();
  }

  /// Сбросить состояние
  void reset() {
    state = GameCreationData();
    _saveState = SaveButtonState.ready;
    _errorMessage = null;
  }

  /// Начать сохранение
  void startSaving() {
    _saveState = SaveButtonState.saving;
    _errorMessage = null;
  }

  /// Успешное сохранение
  void saveSuccess() {
    _saveState = SaveButtonState.success;
    _errorMessage = null;
  }

  /// Ошибка сохранения
  void saveError(String error) {
    _saveState = SaveButtonState.error;
    _errorMessage = error;
  }

  /// Сбросить состояние кнопки
  void resetSaveState() {
    _saveState = SaveButtonState.ready;
    _errorMessage = null;
  }

  /// Сохранить игру в базу данных
  Future<void> saveGame() async {
    // Обновляем название и описание игры из контроллеров
    updateGameName(state.nameController.text);
    updateGameDescription(state.descriptionController.text);

    // Очищаем пустые факты перед валидацией
    cleanEmptyFacts();

    final errors = validate();

    if (errors.isNotEmpty) {
      saveError(errors.first);
      return;
    }

    // Начинаем сохранение
    startSaving();

    try {
      // Сохраняем в базу данных
      final savedGame = await DatabaseService.saveGame(state);

      // Уведомляем провайдер игр о новой игре
      ref.read(gamesProvider.notifier).addGame(savedGame);

      // Успешное сохранение
      saveSuccess();
    } catch (e) {
      // Ошибка сохранения
      saveError('Ошибка сохранения: ${e.toString()}');
    }
  }

  /// Обновить игру в базе данных
  Future<void> updateGame(String gameId) async {
    // Обновляем название и описание игры из контроллеров
    updateGameName(state.nameController.text);
    updateGameDescription(state.descriptionController.text);

    // Очищаем пустые факты перед валидацией
    cleanEmptyFacts();

    final errors = validate();

    if (errors.isNotEmpty) {
      saveError(errors.first);
      return;
    }

    // Начинаем сохранение
    startSaving();

    try {
      // Обновляем в базе данных
      final updatedGame = await DatabaseService.updateGame(gameId, state);

      // Уведомляем провайдер игр об обновленной игре
      ref.read(gamesProvider.notifier).updateGame(updatedGame);

      // Успешное сохранение
      saveSuccess();
    } catch (e) {
      // Ошибка сохранения
      saveError('Ошибка сохранения: ${e.toString()}');
    }
  }

  /// Очистить пустые факты у всех персонажей
  void cleanEmptyFacts() {
    final cleanedPersons =
        state.persons.map((person) {
          final cleanedFacts =
              person.facts
                  .where((fact) => fact.text.trim().isNotEmpty)
                  .toList();
          return person.copyWith(facts: cleanedFacts);
        }).toList();

    state = state.copyWith(persons: cleanedPersons);
  }

  /// Загрузить игру для редактирования
  Future<void> loadGameForEdit(Game game) async {
    try {
      // Получаем всех персонажей игры
      final personIds = JsonUtils.stringToList(game.personIds);
      final persons = <PersonData>[];

      for (final personId in personIds) {
        final person = await DatabaseService.getPersonById(personId);
        if (person != null) {
          // Получаем все факты персонажа
          final factIds = JsonUtils.stringToList(person.factIds);
          final facts = <FactData>[];

          for (final factId in factIds) {
            final fact = await DatabaseService.getFactById(factId);
            if (fact != null) {
              final factData = FactData();
              factData.text = fact.text;
              factData.isSecret = fact.isSecret;
              factData.isStartFact = fact.isStartFact;
              facts.add(factData);
            }
          }

          final personData = PersonData();
          personData.name = person.name;
          personData.facts.addAll(facts);
          persons.add(personData);
        }
      }

      // Создаем контроллеры для названия и описания игры
      final nameController = TextEditingController(text: game.name);
      final descriptionController = TextEditingController(
        text: game.description ?? '',
      );

      // Обновляем состояние
      state = GameCreationData.create(
        name: game.name,
        description: game.description ?? '',
        nameController: nameController,
        descriptionController: descriptionController,
        persons: persons,
      );

      // Сбрасываем состояние сохранения
      _saveState = SaveButtonState.ready;
      _errorMessage = null;
    } catch (e) {
      throw Exception('Ошибка загрузки игры: ${e.toString()}');
    }
  }
}
