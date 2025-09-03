import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/facts_section.dart';

class PersonCard extends StatelessWidget {
  final int index;
  final PersonData person;
  final VoidCallback onRemove;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;
  final void Function(String) onPersonNameChanged;
  final VoidCallback onAddFact;
  final void Function(int) onRemoveFact;
  final void Function(int, String) onFactTextChanged;
  final void Function(int, bool) onFactTypeChanged;
  final int Function(int) getFactGlobalIndex;

  const PersonCard({
    super.key,
    required this.index,
    required this.person,
    required this.onRemove,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildNameField(context),
          const SizedBox(height: 16),
          FactsSection(
            personIndex: index,
            person: person,
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
            onAddFact: onAddFact,
            onRemoveFact: onRemoveFact,
            onFactTextChanged: onFactTextChanged,
            onFactTypeChanged: onFactTypeChanged,
            getFactGlobalIndex: getFactGlobalIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Персонаж ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      initialValue: person.name,
      decoration: const InputDecoration(
        labelText: 'ФИО персонажа',
        hintText: 'Например: Иван Петров',
        prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
      ),
      onChanged: onPersonNameChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите ФИО персонажа';
        }
        return null;
      },
    );
  }
}
