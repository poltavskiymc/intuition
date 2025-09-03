import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/providers/game_creation_provider.dart';
import 'package:intuition/features/game_creation/widgets/game_name_section.dart';
import 'package:intuition/features/game_creation/widgets/persons_section.dart';
import 'package:intuition/features/game_creation/widgets/start_fact_section.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class GameCreationScreenV2 extends ConsumerWidget {
  const GameCreationScreenV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameCreationProvider);
    final gameCreationNotifier = ref.read(gameCreationProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: const AppLogoIcon(size: 28),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveGame(context, ref),
            child: const Text(
              'Сохранить',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameNameSection(
                controller: gameData.nameController,
                onChanged:
                    (String value) =>
                        gameCreationNotifier.updateGameName(value),
              ),
              const SizedBox(height: 24),
              PersonsSection(
                persons: gameData.persons,
                onAddPerson: () => gameCreationNotifier.addPerson(),
                onRemovePerson:
                    (index) => gameCreationNotifier.removePerson(index),
                selectedStartFactIndex: gameData.selectedStartFactIndex,
                onStartFactChanged:
                    (index) => gameCreationNotifier.setStartFact(index),
                onPersonNameChanged:
                    (personIndex, name) => gameCreationNotifier
                        .updatePersonName(personIndex, name),
                onAddFact:
                    (personIndex) => gameCreationNotifier.addFact(personIndex),
                onRemoveFact:
                    (personIndex, factIndex) =>
                        gameCreationNotifier.removeFact(personIndex, factIndex),
                onFactTextChanged:
                    (personIndex, factIndex, text) => gameCreationNotifier
                        .updateFactText(personIndex, factIndex, text),
                onFactTypeChanged:
                    (personIndex, factIndex, isSecret) => gameCreationNotifier
                        .updateFactType(personIndex, factIndex, isSecret),
                getFactGlobalIndex:
                    (personIndex, factIndex) => gameCreationNotifier
                        .getFactGlobalIndex(personIndex, factIndex),
              ),
              const SizedBox(height: 24),
              StartFactSection(gameData: gameData),
              const SizedBox(height: 32),
              _buildSaveButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _saveGame(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Создать игру',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _saveGame(BuildContext context, WidgetRef ref) {
    final gameCreationNotifier = ref.read(gameCreationProvider.notifier);
    final errors = gameCreationNotifier.validate();

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errors.first), backgroundColor: Colors.red),
      );
      return;
    }

    // TODO: Сохранить игру в базу данных
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Игра успешно создана!'),
        backgroundColor: Colors.green,
      ),
    );

    // Возвращаемся на главный экран
    context.pop();
  }
}
