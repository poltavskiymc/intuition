import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';

class GamePreview extends StatelessWidget {
  final GameCreationData gameData;

  const GamePreview({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    if (gameData.name.trim().isEmpty && gameData.persons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildPreviewContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.hintCardColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.preview,
            color: AppTheme.hintCardColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Превью игры',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (gameData.name.trim().isNotEmpty) ...[
          _buildGameTitle(context),
          const SizedBox(height: 16),
        ],
        if (gameData.persons.isNotEmpty) ...[
          _buildPersonsPreview(context),
          const SizedBox(height: 16),
        ],
        if (gameData.selectedStartFactIndex >= 0) ...[
          _buildStartFactPreview(context),
        ],
      ],
    );
  }

  Widget _buildGameTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.games, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              gameData.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonsPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Персонажи (${gameData.persons.length})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...gameData.persons.asMap().entries.map((entry) {
          final index = entry.key;
          final person = entry.value;
          return _buildPersonPreview(context, index, person);
        }),
      ],
    );
  }

  Widget _buildPersonPreview(
    BuildContext context,
    int index,
    PersonData person,
  ) {
    final factCount = person.facts.length;
    final secretCount = person.facts.where((f) => f.isSecret).length;
    final publicCount = factCount - secretCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name.isNotEmpty
                      ? person.name
                      : 'Персонаж ${index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (factCount > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (publicCount > 0) ...[
                        Icon(
                          Icons.info_outline,
                          size: 12,
                          color: AppTheme.hintCardColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$publicCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.hintCardColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (secretCount > 0) ...[
                        Icon(
                          Icons.lock,
                          size: 12,
                          color: AppTheme.secretCardColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$secretCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secretCardColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartFactPreview(BuildContext context) {
    final startFact = _getStartFact();
    if (startFact == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.hintCardColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.hintCardColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_circle_outline,
            color: AppTheme.hintCardColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Стартовый факт',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.hintCardColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  startFact.text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FactData? _getStartFact() {
    int currentIndex = 0;
    for (final person in gameData.persons) {
      for (final fact in person.facts) {
        if (currentIndex == gameData.selectedStartFactIndex) {
          return fact;
        }
        currentIndex++;
      }
    }
    return null;
  }
}
