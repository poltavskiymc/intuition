import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/isar_models.dart';
import '../../../shared/services/mock_database_service.dart';

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

  void _loadGame() {
    // Загружаем игру из mock базы данных
    _game =
        MockDatabaseService.getGameById(widget.gameId) ??
        MockDatabaseService.getAllGames().first;

    // Загружаем все факты
    _facts = MockDatabaseService.getAllFacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_game.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/card-editor/${widget.gameId}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_game.description != null) ...[
              Text(
                _game.description!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              'Выберите карточку с фактом:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _facts.length,
                itemBuilder: (context, index) {
                  final fact = _facts[index];
                  return _buildFactCard(context, fact);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactCard(BuildContext context, Fact fact) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _onFactCardTapped(fact),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  fact.isSecret
                      ? [
                        AppTheme.secretCardColor.withOpacity(0.1),
                        AppTheme.secretCardColor.withOpacity(0.05),
                      ]
                      : [
                        AppTheme.hintCardColor.withOpacity(0.1),
                        AppTheme.hintCardColor.withOpacity(0.05),
                      ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      fact.isSecret
                          ? AppTheme.secretCardColor
                          : AppTheme.hintCardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  fact.isSecret
                      ? Icons.visibility_off
                      : Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                fact.isSecret ? 'Секретный факт' : 'Подсказка',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      fact.isSecret
                          ? AppTheme.secretCardColor
                          : AppTheme.hintCardColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Нажмите, чтобы открыть',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFactCardTapped(Fact fact) {
    // TODO: Создать игровую сессию и перейти к экрану угадывания
    final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Начать игру?'),
            content: Text(
              'Вы выбрали факт: "${fact.text}"\n\nНачать угадывание?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/guessing/$sessionId');
                },
                child: const Text('Начать'),
              ),
            ],
          ),
    );
  }
}
