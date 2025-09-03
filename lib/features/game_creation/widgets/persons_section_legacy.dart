import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/person_card_legacy.dart';

class PersonsSectionLegacy extends StatelessWidget {
  final List<PersonData> persons;
  final VoidCallback onAddPerson;
  final void Function(int) onRemovePerson;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;

  const PersonsSectionLegacy({
    super.key,
    required this.persons,
    required this.onAddPerson,
    required this.onRemovePerson,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildContent(context),
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
            color: AppTheme.accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.people,
            color: AppTheme.accentColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Персонажи',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onAddPerson,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Добавить персонажа'),
          style: TextButton.styleFrom(foregroundColor: AppTheme.accentColor),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (persons.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ...persons.asMap().entries.map((entry) {
          final index = entry.key;
          final person = entry.value;
          return PersonCardLegacy(
            index: index,
            person: person,
            onRemove: () => onRemovePerson(index),
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Нет персонажей',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте персонажей для создания игры',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
