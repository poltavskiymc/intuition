import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intuition/shared/models/isar_models.dart';
import 'package:intuition/shared/services/database_service.dart';

part 'games_provider.g.dart';

@riverpod
class Games extends _$Games {
  @override
  Future<List<Game>> build() async {
    return await DatabaseService.getAllGames();
  }

  /// Обновить список игр
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Добавить игру в список
  void addGame(Game game) {
    state = state.whenData((games) {
      final updatedGames = List<Game>.from(games);
      updatedGames.add(game);
      return updatedGames;
    });
  }

  /// Обновить игру в списке
  void updateGame(Game updatedGame) {
    state = state.whenData((games) {
      final updatedGames = List<Game>.from(games);
      final index = updatedGames.indexWhere(
        (game) => game.id == updatedGame.id,
      );
      if (index != -1) {
        updatedGames[index] = updatedGame;
      }
      return updatedGames;
    });
  }

  /// Удалить игру из списка
  void removeGame(String gameId) {
    state = state.whenData((games) {
      final updatedGames = games.where((game) => game.id != gameId).toList();
      return updatedGames;
    });
  }
}
