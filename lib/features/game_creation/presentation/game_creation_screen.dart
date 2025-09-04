import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/providers/game_creation_provider.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/game_name_section.dart';
import 'package:intuition/features/game_creation/widgets/person_card.dart';
import 'package:intuition/features/game_creation/widgets/game_creation_progress.dart';
import 'package:intuition/features/game_creation/widgets/game_preview.dart';
import 'package:intuition/features/game_creation/widgets/save_game_button.dart';
import 'package:intuition/shared/widgets/app_logo.dart';
import 'package:intuition/shared/widgets/custom_button.dart';
import 'package:intuition/shared/services/database_service.dart';

class GameCreationScreen extends ConsumerStatefulWidget {
  final String? gameId; // Если null - создание, если не null - редактирование

  const GameCreationScreen({super.key, this.gameId});

  @override
  ConsumerState<GameCreationScreen> createState() => _GameCreationScreenState();
}

extension GameCreationScreenExtension on GameCreationScreen {
  bool get isEditMode => gameId != null;
  bool get isCreateMode => gameId == null;

  String get title => isEditMode ? 'Редактирование игры' : 'Создание игры';
  String get saveButtonText =>
      isEditMode ? 'Сохранить изменения' : 'Сохранить игру';
  String get successMessage =>
      isEditMode ? 'Игра успешно обновлена!' : 'Игра успешно создана!';
  String get infoTitle =>
      isEditMode ? 'Редактирование игры' : 'Как создавать игру';
  String get infoDescription =>
      isEditMode
          ? 'Вы можете изменить название игры, добавить или удалить персонажей, редактировать факты и изменять стартовые факты.\n\nПосле сохранения изменения будут применены к игре.'
          : 'Для каждого персонажа необходимо указать несколько фактов, которые о нём никто не знает, и несколько известных фактов, которые будут использоваться как подсказки.\n\nОдин из неизвестных фактов помечается знаком "стартовый факт", он будет указан на карточке на игровом поле. Чем интереснее факт, тем больше желания будет у игроков его выбрать и отгадать.';
}

class _GameCreationScreenState extends ConsumerState<GameCreationScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode) {
      // Загружаем данные после первого рендера
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadGameForEdit();
      });
    }
  }

  Future<void> _loadGameForEdit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final game = await DatabaseService.getGameById(widget.gameId!);

      if (game == null) {
        setState(() {
          _error = 'Игра не найдена (ID: ${widget.gameId})';
          _isLoading = false;
        });
        return;
      }

      // Загружаем данные игры в провайдер
      final gameCreationNotifier = ref.read(gameCreationProvider.notifier);
      await gameCreationNotifier.loadGameForEdit(game);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки игры: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }

    if (_error != null) {
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
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Назад'),
              ),
            ],
          ),
        ),
      );
    }

    final gameData = ref.watch(gameCreationProvider);
    final gameCreationNotifier = ref.read(gameCreationProvider.notifier);

    // Слушаем изменения состояния провайдера
    ref.listen(gameCreationProvider, (previous, next) {
      // Обрабатываем изменения состояния
      if (next.persons.isNotEmpty && _isLoading) {
        setState(() {
          _isLoading = false;
          _error = null;
        });
      }
    });

    // Сбрасываем провайдер для режима создания только один раз
    if (widget.isCreateMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameCreationNotifier.reset();
      });
    }

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
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: _buildSaveButton(context, ref),
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок с названием, описанием и прогрессом
              _buildHeaderSection(context, gameData),
              const SizedBox(height: 24),

              // Создание персонажей с информацией
              _buildPersonsCreationSection(
                context,
                gameData,
                gameCreationNotifier,
              ),
              const SizedBox(height: 24),

              // Превью игры
              _buildGamePreviewSection(context, gameData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, GameCreationData gameData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название игры и описание
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameNameSection(
                nameController: gameData.nameController,
                descriptionController: gameData.descriptionController,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Прогресс создания
        Expanded(flex: 1, child: GameCreationProgress(gameData: gameData)),
      ],
    );
  }

  Widget _buildPersonsCreationSection(
    BuildContext context,
    GameCreationData gameData,
    GameCreation gameCreationNotifier,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Левая часть - создание персонажей
        Expanded(
          flex: 2,
          child: _buildPersonsSection(context, gameData, gameCreationNotifier),
        ),
        const SizedBox(width: 24),
        // Правая часть - информация о создании
        Expanded(flex: 1, child: _buildCreationInfoCard(context)),
      ],
    );
  }

  Widget _buildCreationInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppTheme.accentColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isEditMode ? Icons.edit_outlined : Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.infoTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.infoDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamePreviewSection(
    BuildContext context,
    GameCreationData gameData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Превью игры',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GamePreview(gameData: gameData),
      ],
    );
  }

  Widget _buildPersonsSection(
    BuildContext context,
    GameCreationData gameData,
    GameCreation gameCreationNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Персонажи',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            AddPersonButton(onPressed: () => gameCreationNotifier.addPerson()),
          ],
        ),
        const SizedBox(height: 12),
        // Персонажи в вертикальной компоновке
        if (gameData.persons.isEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 48,
                    color: AppTheme.accentColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте первого персонажа',
                    style: TextStyle(
                      color: AppTheme.accentColor.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children:
                gameData.persons.asMap().entries.map<Widget>((
                  MapEntry<int, PersonData> entry,
                ) {
                  final int index = entry.key;
                  final PersonData person = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: PersonCard(
                      index: index,
                      person: person,
                      selectedStartFactIndex: person.facts.indexWhere(
                        (FactData fact) => fact.isStartFact,
                      ),
                      onRemove: () => gameCreationNotifier.removePerson(index),
                      onStartFactChanged:
                          (int factIndex) => gameCreationNotifier
                              .setPersonStartFact(index, factIndex),
                      onPersonNameChanged:
                          (String name) => gameCreationNotifier
                              .updatePersonName(index, name),
                      onAddFact: () => gameCreationNotifier.addFact(index),
                      onRemoveFact:
                          (int factIndex) =>
                              gameCreationNotifier.removeFact(index, factIndex),
                      onFactTextChanged:
                          (int factIndex, String text) => gameCreationNotifier
                              .updateFactText(index, factIndex, text),
                      onFactTypeChanged:
                          (int factIndex, bool isSecret) => gameCreationNotifier
                              .updateFactType(index, factIndex, isSecret),
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, WidgetRef ref) {
    final gameCreationNotifier = ref.read(gameCreationProvider.notifier);
    final saveState = gameCreationNotifier.saveState;

    if (saveState == SaveButtonState.saving) {
      return ElevatedButton.icon(
        onPressed: null, // Отключаем кнопку во время сохранения
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        label: const Text('Сохранение...'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      );
    }

    if (saveState == SaveButtonState.error) {
      return ElevatedButton.icon(
        onPressed: () => _saveGame(context, ref),
        icon: const Icon(Icons.error_outline, size: 18),
        label: const Text('Ошибка'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _saveGame(context, ref),
      icon: const Icon(Icons.save, size: 18),
      label: Text(widget.saveButtonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }

  void _saveGame(BuildContext context, WidgetRef ref) async {
    try {
      final gameCreationNotifier = ref.read(gameCreationProvider.notifier);

      if (widget.isEditMode) {
        // Обновляем игру через провайдер
        await gameCreationNotifier.updateGame(widget.gameId!);
      } else {
        // Сохраняем игру через провайдер
        await gameCreationNotifier.saveGame();
      }

      // Показываем уведомление об успехе
      if (gameCreationNotifier.saveState == SaveButtonState.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(widget.successMessage),
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
      }
    } catch (e) {
      // Показываем уведомление об ошибке
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Ошибка сохранения: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
