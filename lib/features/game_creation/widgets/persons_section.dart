import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/person_card.dart';
import 'package:intuition/shared/widgets/custom_button.dart';

class PersonsSection extends StatelessWidget {
  final List<PersonData> persons;
  final VoidCallback onAddPerson;
  final void Function(int) onRemovePerson;
  final int Function(int) getSelectedStartFactIndex;
  final void Function(int, int) onStartFactChanged;
  final void Function(int, String) onPersonNameChanged;
  final void Function(int) onAddFact;
  final void Function(int, int) onRemoveFact;
  final void Function(int, int, String) onFactTextChanged;
  final void Function(int, int, bool) onFactTypeChanged;

  const PersonsSection({
    super.key,
    required this.persons,
    required this.onAddPerson,
    required this.onRemovePerson,
    required this.getSelectedStartFactIndex,
    required this.onStartFactChanged,
    required this.onPersonNameChanged,
    required this.onAddFact,
    required this.onRemoveFact,
    required this.onFactTextChanged,
    required this.onFactTypeChanged,
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
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.people, color: Colors.white, size: 20),
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
        AddPersonButton(onPressed: onAddPerson),
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
            selectedStartFactIndex: getSelectedStartFactIndex(index),
            onStartFactChanged:
                (factIndex) => onStartFactChanged(index, factIndex),
            onPersonNameChanged: (name) => onPersonNameChanged(index, name),
            onAddFact: () => onAddFact(index),
            onRemoveFact: (factIndex) => onRemoveFact(index, factIndex),
            onFactTextChanged:
                (factIndex, text) => onFactTextChanged(index, factIndex, text),
            onFactTypeChanged:
                (factIndex, isSecret) =>
                    onFactTypeChanged(index, factIndex, isSecret),
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
