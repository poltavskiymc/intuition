import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/shared/widgets/custom_text_field.dart';
import 'package:intuition/shared/widgets/custom_button.dart';

class FactCard extends StatelessWidget {
  final int personIndex;
  final int factIndex;
  final FactData fact;
  final VoidCallback onRemove;
  final int selectedStartFactIndex;
  final void Function(int) onStartFactChanged;
  final void Function(String) onFactTextChanged;
  final void Function(bool) onFactTypeChanged;
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
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
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
          const SizedBox(height: 6),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FactTextField(
            initialValue: fact.text,
            onChanged: onFactTextChanged,
            factIndex: factIndex,
            isSecret: fact.isSecret,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Введите факт';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
          ), // Поднимаем кнопку к верхней границе поля
          child: DeleteButton(onPressed: onRemove, tooltip: 'Удалить факт'),
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
    return Row(
      children: [
        Radio<int>(
          value: factIndex,
          groupValue: selectedStartFactIndex,
          onChanged: (value) {
            if (value != null) {
              onStartFactChanged(factIndex);
            }
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
