import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/facts_section.dart';
import 'package:intuition/shared/widgets/custom_text_field.dart';
import 'package:intuition/shared/widgets/custom_button.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    // Определяем цвет обводки в зависимости от индекса
    final borderColor =
        index % 2 == 0 ? AppTheme.personCardColor1 : AppTheme.personCardColor2;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildNameField(context),
          const SizedBox(height: 12),
          FactsSection(
            personIndex: index,
            person: person,
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
            onAddFact: onAddFact,
            onRemoveFact: onRemoveFact,
            onFactTextChanged: onFactTextChanged,
            onFactTypeChanged: onFactTypeChanged,
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
        DeleteButton(onPressed: onRemove, tooltip: 'Удалить персонажа'),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return PersonNameTextField(
      initialValue: person.name,
      onChanged: onPersonNameChanged,
      personIndex: index,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите ФИО персонажа';
        }
        return null;
      },
    );
  }
}
