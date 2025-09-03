import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';

class GameNameSection extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const GameNameSection({super.key, required this.controller, this.onChanged});

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
            _buildTextField(),
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
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryColor, width: 1),
          ),
          child: const Icon(
            Icons.title,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Название игры',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Введите название игры',
        prefixIcon: Icon(Icons.games, color: AppTheme.primaryColor),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите название игры';
        }
        return null;
      },
    );
  }
}
