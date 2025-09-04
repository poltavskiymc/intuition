import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_selection/providers/games_provider.dart';
import 'package:intuition/shared/models/isar_models.dart';
import 'package:intuition/shared/utils/json_utils.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class GameSelectionScreen extends ConsumerWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите игру',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Выберите игру для начала угадывания персонажей',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: gamesAsync.when(
                data:
                    (games) =>
                        games.isEmpty
                            ? _buildEmptyState(context)
                            : _buildGamesList(context, games),
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ),
                error:
                    (error, stackTrace) => Center(
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
                            'Ошибка загрузки игр',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.red.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => ref.refresh(gamesProvider),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.games_outlined,
            size: 64,
            color: AppTheme.accentColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Нет созданных игр',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.accentColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте игру, чтобы начать играть',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.accentColor.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/game-creation'),
            icon: const Icon(Icons.add),
            label: const Text('Создать игру'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: games.map((game) => _buildGameCard(context, game)).toList(),
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Game game) {
    return SizedBox(
      width: 300, // Фиксированная ширина карточки
      child: Card(
        elevation: 2,
        color: AppTheme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка игры
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.games,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),

              // Название игры (одна строка)
              Text(
                game.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Описание игры (две строки)
              // if (game.description != null) ...[
              Text(
                game.description ?? '',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // ],

              // Количество персонажей
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: AppTheme.accentColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Персонажей: ${_getPersonCount(game)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.softCoral,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Кнопки горизонтально
              Row(
                children: [
                  // Кнопка "Редактировать"
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _editGame(context, game),
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('Ред.'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 1,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Кнопка "Играть"
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startGame(context, game),
                      icon: const Icon(Icons.play_arrow, size: 14),
                      label: const Text('Играть'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 1,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getPersonCount(Game game) {
    try {
      final personIds = JsonUtils.stringToList(game.personIds);
      return personIds.length;
    } catch (e) {
      return 0;
    }
  }

  void _startGame(BuildContext context, Game game) {
    // Создаем игровую сессию
    final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';

    // TODO: Сохранить сессию в базу данных
    // MockDatabaseService.createGameSession(sessionId, game.id.toString());

    // Переходим на игровой экран
    context.push('/guessing/$sessionId');
  }

  void _editGame(BuildContext context, Game game) {
    // Переходим на экран редактирования игры
    context.push('/game-edit/${game.id}');
  }
}
