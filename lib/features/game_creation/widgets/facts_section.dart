import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/fact_card.dart';
import 'package:intuition/shared/widgets/custom_button.dart';

class FactsSection extends StatelessWidget {
  final int personIndex;
  final PersonData person;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;
  final VoidCallback onAddFact;
  final void Function(int) onRemoveFact;
  final void Function(int, String) onFactTextChanged;
  final void Function(int, bool) onFactTypeChanged;

  const FactsSection({
    super.key,
    required this.personIndex,
    required this.person,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
    required this.onAddFact,
    required this.onRemoveFact,
    required this.onFactTextChanged,
    required this.onFactTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        _buildContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Факты',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const Spacer(),
        AddFactButton(onPressed: onAddFact),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (person.facts.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ...person.facts.asMap().entries.map((entry) {
          final factIndex = entry.key;
          final fact = entry.value;
          return FactCard(
            personIndex: personIndex,
            factIndex: factIndex,
            fact: fact,
            onRemove: () => onRemoveFact(factIndex),
            selectedStartFactIndex: selectedStartFactIndex,
            onStartFactChanged: onStartFactChanged,
            onFactTextChanged: (text) => onFactTextChanged(factIndex, text),
            onFactTypeChanged:
                (isSecret) => onFactTypeChanged(factIndex, isSecret),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.fact_check_outlined,
            color: AppTheme.accentColor.withValues(alpha: 0.6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Нет фактов',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.accentColor),
          ),
        ],
      ),
    );
  }
}
