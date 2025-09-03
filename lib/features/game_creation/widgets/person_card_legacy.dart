import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/facts_section_legacy.dart';

class PersonCardLegacy extends StatelessWidget {
  final int index;
  final PersonData person;
  final VoidCallback onRemove;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;

  const PersonCardLegacy({
    super.key,
    required this.index,
    required this.person,
    required this.onRemove,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
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
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildNameField(context),
          const SizedBox(height: 16),
          FactsSectionLegacy(
            personIndex: index,
            person: person,
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
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
          iconSize: 18,
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
      onChanged: (value) => person.name = value,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите ФИО персонажа';
        }
        return null;
      },
    );
  }
}
