import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/person_card.dart';

class PersonsSection extends StatelessWidget {
  final List<PersonData> persons;
  final VoidCallback onAddPerson;
  final void Function(int) onRemovePerson;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;
  final void Function(int, String) onPersonNameChanged;
  final void Function(int) onAddFact;
  final void Function(int, int) onRemoveFact;
  final void Function(int, int, String) onFactTextChanged;
  final void Function(int, int, bool) onFactTypeChanged;
  final int Function(int, int) getFactGlobalIndex;

  const PersonsSection({
    super.key,
    required this.persons,
    required this.onAddPerson,
    required this.onRemovePerson,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
    required this.onPersonNameChanged,
    required this.onAddFact,
    required this.onRemoveFact,
    required this.onFactTextChanged,
    required this.onFactTypeChanged,
    required this.getFactGlobalIndex,
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
            color: AppTheme.secondaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.secondaryColor, width: 1),
          ),
          child: const Icon(
            Icons.people,
            color: AppTheme.secondaryColor,
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
        ElevatedButton.icon(
          onPressed: onAddPerson,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Добавить'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
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
          return PersonCard(
            index: index,
            person: person,
            onRemove: () => onRemovePerson(index),
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
            onPersonNameChanged: (name) => onPersonNameChanged(index, name),
            onAddFact: () => onAddFact(index),
            onRemoveFact: (factIndex) => onRemoveFact(index, factIndex),
            onFactTextChanged:
                (factIndex, text) => onFactTextChanged(index, factIndex, text),
            onFactTypeChanged:
                (factIndex, isSecret) =>
                    onFactTypeChanged(index, factIndex, isSecret),
            getFactGlobalIndex:
                (factIndex) => getFactGlobalIndex(index, factIndex),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: AppTheme.accentColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'Пока нет персонажей',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.accentColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте персонажей для игры',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
