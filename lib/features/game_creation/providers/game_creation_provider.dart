import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';

part 'game_creation_provider.g.dart';

@riverpod
class GameCreation extends _$GameCreation {
  @override
  GameCreationData build() {
    return GameCreationData();
  }

  /// Обновить название игры
  void updateGameName(String name) {
    state = state.copyWith(name: name);
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

  /// Установить стартовый факт
  void setStartFact(int globalIndex) {
    state = state.copyWith(selectedStartFactIndex: globalIndex);
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
  }
}
