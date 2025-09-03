import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/features/menu/presentation/menu_screen.dart';
import 'package:intuition/features/game/presentation/game_field_screen.dart';
import 'package:intuition/features/guessing/presentation/guessing_screen.dart';
import 'package:intuition/features/card_editor/presentation/card_editor_screen.dart';
import 'package:intuition/features/person_editor/presentation/person_editor_screen.dart';
import 'package:intuition/features/game_creation/presentation/game_creation_screen.dart';

class AppRouter {
  static const String menu = '/';
  static const String gameField = '/game/:gameId';
  static const String guessing = '/guessing/:sessionId';
  static const String cardEditor = '/card-editor/:gameId';
  static const String personEditor = '/person-editor/:gameId/:personId?';
  static const String gameCreation = '/game-creation';

  static final GoRouter router = GoRouter(
    initialLocation: menu,
    routes: [
      GoRoute(
        path: menu,
        name: 'menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: gameField,
        name: 'gameField',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return GameFieldScreen(gameId: gameId);
        },
      ),
      GoRoute(
        path: guessing,
        name: 'guessing',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return GuessingScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: cardEditor,
        name: 'cardEditor',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return CardEditorScreen(gameId: gameId);
        },
      ),
      GoRoute(
        path: personEditor,
        name: 'personEditor',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          final personId = state.pathParameters['personId'];
          return PersonEditorScreen(gameId: gameId, personId: personId);
        },
      ),
      GoRoute(
        path: gameCreation,
        name: 'gameCreation',
        builder: (context, state) => const GameCreationScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Страница не найдена',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Путь: ${state.uri}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(menu),
                  child: const Text('На главную'),
                ),
              ],
            ),
          ),
        ),
  );
}
