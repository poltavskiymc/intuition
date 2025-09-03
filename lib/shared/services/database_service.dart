import 'package:isar/isar.dart';
import '../models/isar_models.dart';

class DatabaseService {
  static late Isar _isar;

  static Isar get instance => _isar;

  static Future<void> initialize() async {
    _isar = await Isar.open([
      GameSchema,
      PersonSchema,
      FactSchema,
      GameSessionSchema,
    ], directory: './data');
  }

  static Future<void> close() async {
    await _isar.close();
  }
}
