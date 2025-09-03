import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';

class FactCard extends StatelessWidget {
  final int personIndex;
  final int factIndex;
  final FactData fact;
  final VoidCallback onRemove;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;
  final void Function(String) onFactTextChanged;
  final void Function(bool) onFactTypeChanged;
  final int Function() getFactGlobalIndex;

  const FactCard({
    super.key,
    required this.personIndex,
    required this.factIndex,
    required this.fact,
    required this.onRemove,
    required this.selectedStartFactIndex,
    required this.onStartFactChanged,
    required this.onFactTextChanged,
    required this.onFactTypeChanged,
    required this.getFactGlobalIndex,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            fact.isSecret
                ? AppTheme.secretCardColor.withValues(alpha: 0.1)
                : AppTheme.hintCardColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              fact.isSecret
                  ? AppTheme.secretCardColor.withValues(alpha: 0.3)
                  : AppTheme.hintCardColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _buildTextField(context),
          const SizedBox(height: 8),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: fact.text,
            decoration: InputDecoration(
              labelText: 'Факт ${factIndex + 1}',
              hintText: 'Введите факт о персонаже',
              prefixIcon: Icon(
                fact.isSecret ? Icons.lock : Icons.info_outline,
                color:
                    fact.isSecret
                        ? AppTheme.secretCardColor
                        : AppTheme.hintCardColor,
              ),
            ),
            onChanged: onFactTextChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Введите факт';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          iconSize: 18,
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSecretCheckbox(context)),
        Expanded(child: _buildStartFactRadio(context)),
      ],
    );
  }

  Widget _buildSecretCheckbox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: fact.isSecret,
          onChanged: (value) {
            onFactTypeChanged(value ?? false);
          },
          activeColor: AppTheme.secretCardColor,
        ),
        Text(
          'Секретный факт',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.secretCardColor),
        ),
      ],
    );
  }

  Widget _buildStartFactRadio(BuildContext context) {
    final factGlobalIndex = getFactGlobalIndex();
    return Row(
      children: [
        Radio<int>(
          value: factGlobalIndex,
          groupValue: selectedStartFactIndex,
          onChanged: (value) {
            onStartFactChanged(value ?? -1);
          },
          activeColor: AppTheme.primaryColor,
        ),
        Text(
          'Стартовый факт',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.primaryColor),
        ),
      ],
    );
  }
}
