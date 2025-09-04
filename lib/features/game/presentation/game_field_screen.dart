import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/shared/models/isar_models.dart';
import 'package:intuition/shared/services/database_service.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class GameFieldScreen extends StatefulWidget {
  final String gameId;

  const GameFieldScreen({super.key, required this.gameId});

  @override
  State<GameFieldScreen> createState() => _GameFieldScreenState();
}

class _GameFieldScreenState extends State<GameFieldScreen> {
  // TODO: Загрузить игру из БД
  late Game _game;
  List<Fact> _facts = [];

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  void _loadGame() async {
    // Загружаем игру из базы данных
    _game =
        await DatabaseService.getGameById(widget.gameId) ??
        (await DatabaseService.getAllGames()).first;

    // Загружаем все факты
    _facts = await DatabaseService.getAllFacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogoIcon(size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _game.name,
                style: const TextStyle(color: AppTheme.primaryColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
            onPressed: () {
              context.go('/card-editor/${widget.gameId}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Название игры по центру сверху
            Center(
              child: Text(
                _game.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            // Карточки со стартовыми фактами
            Expanded(child: _buildStartFactCards(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildStartFactCards(BuildContext context) {
    // Получаем стартовые факты из mock данных
    final startFacts = _facts.where((fact) => fact.isStartFact).toList();

    if (startFacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.help_outline,
              size: 64,
              color: AppTheme.accentColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Нет стартовых фактов',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.accentColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Создайте игру с персонажами и стартовыми фактами',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentColor.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          startFacts.map((fact) {
            return _buildStartFactCard(context, fact);
          }).toList(),
    );
  }

  Widget _buildStartFactCard(BuildContext context, Fact fact) {
    return Container(
      width: 200, // Фиксированная ширина карточки
      height: 120, // Фиксированная высота карточки
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              fact.isSecret
                  ? AppTheme.hintCardColor.withValues(alpha: 0.8)
                  : AppTheme.accentColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                fact.isSecret
                    ? AppTheme.hintCardColor.withValues(alpha: 0.3)
                    : AppTheme.accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onStartFactCardTapped(fact),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Стартовый факт (занимает больше места)
                Expanded(
                  child: Center(
                    child: Text(
                      fact.text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Индикатор типа факта
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        fact.isSecret ? Icons.visibility_off : Icons.visibility,
                        size: 16,
                        color:
                            fact.isSecret
                                ? AppTheme.primaryColor
                                : AppTheme.accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fact.isSecret ? 'Секретный' : 'Известный',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              fact.isSecret
                                  ? AppTheme.primaryColor
                                  : AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStartFactCardTapped(Fact fact) {
    // TODO: Переход к экрану с дополнительными фактами
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            fact.isSecret ? 'Секретный факт' : 'Известный факт',
            style: const TextStyle(color: AppTheme.primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fact.text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(
                'Этот факт поможет вам отгадать персонажа!',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Понятно'),
            ),
          ],
        );
      },
    );
  }
}
