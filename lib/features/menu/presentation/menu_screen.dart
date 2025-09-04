import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: const AppLogo(size: 32, showText: false),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.primaryColor),
            onPressed: () {
              // TODO: Настройки
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Большой логотип в центре
                const Center(child: AppLogo(size: 80, showText: true)),
                const SizedBox(height: 24),
                Text(
                  'Добро пожаловать в игру "Интуиция"!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Угадайте персонажа по фактам',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildMenuCard(
                  context,
                  icon: Icons.play_circle_outline,
                  title: 'Играть',
                  subtitle: 'Выберите игру и начните угадывать',
                  onTap: () {
                    // TODO: Список игр
                    context.push('/gameField');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  icon: Icons.add_circle_outline,
                  title: 'Создать игру',
                  subtitle: 'Создайте новую игру с персонажами и фактами',
                  onTap: () {
                    context.push('/game-creation');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'Редактировать',
                  subtitle: 'Редактируйте существующие игры',
                  onTap: () {
                    // TODO: Редактирование игр
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Редактирование будет добавлено'),
                      ),
                    );
                  },
                ),
                const Spacer(),
                _buildInfoCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppTheme.cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Как играть:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '1. Выберите карточку с фактом\n'
              '2. Открывайте новые карточки для получения подсказок\n'
              '3. Угадайте персонажа по собранным фактам',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                height: 1.4,
              ),
              overflow: TextOverflow.visible,
              maxLines: null,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
