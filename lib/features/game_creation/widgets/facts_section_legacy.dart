import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/fact_card_legacy.dart';

class FactsSectionLegacy extends StatefulWidget {
  final int personIndex;
  final PersonData person;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;

  const FactsSectionLegacy({
    super.key,
    required this.personIndex,
    required this.person,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
  });

  @override
  State<FactsSectionLegacy> createState() => _FactsSectionLegacyState();
}

class _FactsSectionLegacyState extends State<FactsSectionLegacy> {
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
        TextButton.icon(
          onPressed: _addFact,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Добавить факт'),
          style: TextButton.styleFrom(foregroundColor: AppTheme.accentColor),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.person.facts.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ...widget.person.facts.asMap().entries.map((entry) {
          final factIndex = entry.key;
          final fact = entry.value;
          return FactCardLegacy(
            personIndex: widget.personIndex,
            factIndex: factIndex,
            fact: fact,
            onRemove: () => _removeFact(factIndex),
            selectedStartFactIndex: widget.selectedStartFactIndex,
            onStartFactChanged: widget.onStartFactChanged,
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
          Icon(Icons.info_outline, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Нет фактов',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте факты о персонаже',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _addFact() {
    setState(() {
      widget.person.facts.add(FactData());
    });
  }

  void _removeFact(int factIndex) {
    setState(() {
      widget.person.facts.removeAt(factIndex);
    });
  }
}
