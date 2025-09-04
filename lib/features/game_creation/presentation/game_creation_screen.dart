import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/providers/game_creation_provider.dart';
import 'package:intuition/features/game_creation/widgets/game_name_section.dart';
import 'package:intuition/features/game_creation/widgets/persons_section.dart';
import 'package:intuition/features/game_creation/widgets/start_fact_section.dart';
import 'package:intuition/features/game_creation/widgets/game_creation_progress.dart';
import 'package:intuition/features/game_creation/widgets/game_preview.dart';
import 'package:intuition/features/game_creation/widgets/save_game_button.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class GameCreationScreen extends ConsumerWidget {
  const GameCreationScreen({super.key});

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
              // Индикатор прогресса
              GameCreationProgress(gameData: gameData),
              const SizedBox(height: 16),

              // Название игры
              GameNameSection(controller: gameData.nameController),
              const SizedBox(height: 16),

              // Персонажи
              PersonsSection(
                persons: gameData.persons,
                onAddPerson: () => gameCreationNotifier.addPerson(),
                onRemovePerson:
                    (index) => gameCreationNotifier.removePerson(index),
                getSelectedStartFactIndex: (personIndex) {
                  final person = gameData.persons[personIndex];
                  return person.facts.indexWhere((fact) => fact.isStartFact);
                },
                onStartFactChanged:
                    (personIndex, factIndex) => gameCreationNotifier
                        .setPersonStartFact(personIndex, factIndex),
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
              ),
              const SizedBox(height: 16),

              // Стартовый факт
              StartFactSection(gameData: gameData),
              const SizedBox(height: 16),

              // Превью игры
              GamePreview(gameData: gameData),
              const SizedBox(height: 24),

              // Кнопка сохранения
              SaveGameButton(
                state: gameCreationNotifier.saveState,
                errorMessage: gameCreationNotifier.errorMessage,
                onPressed: () => _saveGame(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGame(BuildContext context, WidgetRef ref) async {
    final gameCreationNotifier = ref.read(gameCreationProvider.notifier);
    final gameData = ref.read(gameCreationProvider);

    // Обновляем название игры из контроллера
    gameCreationNotifier.updateGameName(gameData.nameController.text);

    final errors = gameCreationNotifier.validate();

    if (errors.isNotEmpty) {
      gameCreationNotifier.saveError(errors.first);
      return;
    }

    // Начинаем сохранение
    gameCreationNotifier.startSaving();

    try {
      // Имитируем сохранение в базу данных
      await Future<void>.delayed(const Duration(seconds: 2));

      // TODO: Реальное сохранение в базу данных
      // await DatabaseService.saveGame(gameData);

      // Успешное сохранение
      gameCreationNotifier.saveSuccess();

      // Показываем уведомление
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Игра успешно создана!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Возвращаемся на главный экран через 1.5 секунды
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      // Ошибка сохранения
      gameCreationNotifier.saveError('Ошибка сохранения: ${e.toString()}');
    }
  }
}
