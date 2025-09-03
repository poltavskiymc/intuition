import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class Splash extends _$Splash {
  @override
  bool build() {
    return true; // Показываем splash screen по умолчанию
  }

  void hideSplash() {
    state = false;
  }
}
