import 'package:flutter/material.dart';

/// Модели данных для создания игры
class PersonData {
  String name = '';
  final List<FactData> facts = [];

  PersonData();

  PersonData.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String? ?? '';

  Map<String, dynamic> toJson() => {
    'name': name,
    'facts': facts.map((f) => f.toJson()).toList(),
  };

  PersonData copyWith({String? name, List<FactData>? facts}) {
    return PersonData()
      ..name = name ?? this.name
      ..facts.addAll(facts ?? this.facts);
  }

  @override
  String toString() => 'PersonData(name: $name, facts: ${facts.length})';
}

class FactData {
  String text = '';
  bool isSecret = false;

  FactData();

  FactData.fromJson(Map<String, dynamic> json)
    : text = json['text'] as String? ?? '',
      isSecret = json['isSecret'] as bool? ?? false;

  Map<String, dynamic> toJson() => {'text': text, 'isSecret': isSecret};

  FactData copyWith({String? text, bool? isSecret}) {
    return FactData()
      ..text = text ?? this.text
      ..isSecret = isSecret ?? this.isSecret;
  }

  @override
  String toString() => 'FactData(text: $text, isSecret: $isSecret)';
}

class GameCreationData {
  final TextEditingController nameController = TextEditingController();
  final List<PersonData> persons = [];
  int selectedStartFactIndex = -1;

  String get name => nameController.text;

  GameCreationData();

  GameCreationData.fromJson(Map<String, dynamic> json)
    : selectedStartFactIndex = json['selectedStartFactIndex'] as int? ?? -1 {
    nameController.text = json['name'] as String? ?? '';
    if (json['persons'] != null) {
      persons.addAll(
        (json['persons'] as List).map(
          (p) => PersonData.fromJson(p as Map<String, dynamic>),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'persons': persons.map((p) => p.toJson()).toList(),
    'selectedStartFactIndex': selectedStartFactIndex,
  };

  /// Получить текст выбранного стартового факта
  String getSelectedStartFactText() {
    int currentIndex = 0;
    for (int i = 0; i < persons.length; i++) {
      for (int j = 0; j < persons[i].facts.length; j++) {
        if (currentIndex == selectedStartFactIndex) {
          return '${persons[i].name}: ${persons[i].facts[j].text}';
        }
        currentIndex++;
      }
    }
    return '';
  }

  /// Получить глобальный индекс факта
  int getFactGlobalIndex(int personIndex, int factIndex) {
    int globalIndex = 0;
    for (int i = 0; i < personIndex; i++) {
      globalIndex += persons[i].facts.length;
    }
    return globalIndex + factIndex;
  }

  /// Обновить индекс стартового факта при удалении элементов
  void updateStartFactIndex() {
    int currentIndex = 0;
    for (int i = 0; i < persons.length; i++) {
      for (int j = 0; j < persons[i].facts.length; j++) {
        if (currentIndex == selectedStartFactIndex) {
          return; // Индекс все еще валиден
        }
        currentIndex++;
      }
    }
    // Если дошли сюда, значит индекс больше не валиден
    selectedStartFactIndex = -1;
  }

  /// Валидация данных
  List<String> validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Введите название игры');
    }

    if (persons.isEmpty) {
      errors.add('Добавьте хотя бы одного персонажа');
    }

    for (int i = 0; i < persons.length; i++) {
      if (persons[i].name.trim().isEmpty) {
        errors.add('У персонажа ${i + 1} не заполнено ФИО');
      }
      if (persons[i].facts.isEmpty) {
        errors.add('У персонажа ${i + 1} нет фактов');
      }
      for (int j = 0; j < persons[i].facts.length; j++) {
        if (persons[i].facts[j].text.trim().isEmpty) {
          errors.add('У персонажа ${i + 1} не заполнен факт ${j + 1}');
        }
      }
    }

    if (selectedStartFactIndex < 0) {
      errors.add('Выберите стартовый факт');
    }

    return errors;
  }

  GameCreationData copyWith({
    String? name,
    List<PersonData>? persons,
    int? selectedStartFactIndex,
  }) {
    final newData = GameCreationData();
    newData.nameController.text = name ?? this.name;
    newData.persons.addAll(persons ?? this.persons);
    newData.selectedStartFactIndex =
        selectedStartFactIndex ?? this.selectedStartFactIndex;
    return newData;
  }

  @override
  String toString() =>
      'GameCreationData(name: $name, persons: ${persons.length}, startFact: $selectedStartFactIndex)';
}
