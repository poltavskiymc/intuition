import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';

class GameCreationProgress extends StatelessWidget {
  final GameCreationData gameData;

  const GameCreationProgress({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final completedSteps = _getCompletedSteps();

    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, progress),
            const SizedBox(height: 16),
            _buildProgressBar(progress),
            const SizedBox(height: 16),
            _buildStepsList(completedSteps),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double progress) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.track_changes, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          'Прогресс создания',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const Spacer(),
        Text(
          '${(progress * 100).round()}%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 8,
            width: 300 * progress, // Фиксированная ширина для прогресс-бара
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList(List<ProgressStep> completedSteps) {
    return Column(
      children: completedSteps.map((step) => _buildStepItem(step)).toList(),
    );
  }

  Widget _buildStepItem(ProgressStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color:
                  step.isCompleted ? AppTheme.primaryColor : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child:
                step.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Text(
                      '${step.stepNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.title,
              style: TextStyle(
                color:
                    step.isCompleted ? AppTheme.primaryColor : Colors.grey[600],
                fontWeight:
                    step.isCompleted ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (step.isCompleted)
            Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 16),
        ],
      ),
    );
  }

  double _calculateProgress() {
    int completedSteps = 0;
    int totalSteps = 4;

    // Шаг 1: Название игры
    if (gameData.name.trim().isNotEmpty) completedSteps++;

    // Шаг 2: Персонажи
    if (gameData.persons.isNotEmpty) completedSteps++;

    // Шаг 3: Факты
    bool hasFacts = gameData.persons.any((person) => person.facts.isNotEmpty);
    if (hasFacts) completedSteps++;

    // Шаг 4: Стартовый факт
    if (gameData.selectedStartFactIndex >= 0) completedSteps++;

    return completedSteps / totalSteps;
  }

  List<ProgressStep> _getCompletedSteps() {
    return [
      ProgressStep(
        stepNumber: 1,
        title: 'Название игры',
        isCompleted: gameData.name.trim().isNotEmpty,
      ),
      ProgressStep(
        stepNumber: 2,
        title: 'Добавить персонажей',
        isCompleted: gameData.persons.isNotEmpty,
      ),
      ProgressStep(
        stepNumber: 3,
        title: 'Добавить факты',
        isCompleted: gameData.persons.any((person) => person.facts.isNotEmpty),
      ),
      ProgressStep(
        stepNumber: 4,
        title: 'Выбрать стартовый факт',
        isCompleted: gameData.selectedStartFactIndex >= 0,
      ),
    ];
  }
}

class ProgressStep {
  final int stepNumber;
  final String title;
  final bool isCompleted;

  ProgressStep({
    required this.stepNumber,
    required this.title,
    required this.isCompleted,
  });
}
