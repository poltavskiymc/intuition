import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';

class GamePreview extends StatelessWidget {
  final GameCreationData gameData;

  const GamePreview({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    if (gameData.name.trim().isEmpty && gameData.persons.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.accentColor.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.preview,
                size: 48,
                color: AppTheme.accentColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Создайте игру, чтобы увидеть превью',
                style: TextStyle(
                  color: AppTheme.accentColor.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Название игры по центру сверху
            _buildGameTitle(context),
            const SizedBox(height: 32),
            // Карточки со стартовыми фактами
            _buildStartFactCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTitle(BuildContext context) {
    return Center(
      child: Text(
        gameData.name,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStartFactCards(BuildContext context) {
    // Собираем все стартовые факты
    final startFacts = <MapEntry<int, FactData>>[];
    for (
      int personIndex = 0;
      personIndex < gameData.persons.length;
      personIndex++
    ) {
      final person = gameData.persons[personIndex];
      for (int factIndex = 0; factIndex < person.facts.length; factIndex++) {
        final fact = person.facts[factIndex];
        if (fact.isStartFact) {
          startFacts.add(MapEntry(personIndex, fact));
          break; // У каждого персонажа только один стартовый факт
        }
      }
    }

    if (startFacts.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.accentColor.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Выберите стартовые факты для персонажей',
            style: TextStyle(
              color: AppTheme.accentColor.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          startFacts.map((entry) {
            final personIndex = entry.key;
            final fact = entry.value;
            final person = gameData.persons[personIndex];

            return _buildStartFactCard(context, person.name, fact);
          }).toList(),
    );
  }

  Widget _buildStartFactCard(
    BuildContext context,
    String personName,
    FactData fact,
  ) {
    return Container(
      width: 200, // Фиксированная ширина карточки
      height: 120, // Фиксированная высота карточки
      decoration: BoxDecoration(
        color: AppTheme.cardColor, // Всегда белый фон для читаемости
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              fact.isSecret
                  ? AppTheme.hintCardColor.withValues(alpha: 0.8)
                  : AppTheme.accentColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                fact.isSecret
                    ? AppTheme.hintCardColor.withValues(alpha: 0.3)
                    : AppTheme.accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Стартовый факт (занимает больше места)
            Expanded(
              child: Center(
                child: Text(
                  fact.text.isEmpty ? 'Факт не указан' : fact.text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        AppTheme
                            .primaryColor, // Темный цвет для лучшей видимости
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4, // Больше строк для факта
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Индикатор типа факта
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    fact.isSecret ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                    color:
                        fact.isSecret
                            ? AppTheme
                                .primaryColor // Темный цвет для лучшей видимости
                            : AppTheme.accentColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fact.isSecret ? 'Секретный' : 'Известный',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          fact.isSecret
                              ? AppTheme
                                  .primaryColor // Темный цвет для лучшей видимости
                              : AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
