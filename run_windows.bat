@echo off
echo 🎮 Запуск игры "Интуиция" на Windows...

REM Проверяем наличие pubspec.yaml
if not exist "pubspec.yaml" (
    echo ❌ Ошибка: pubspec.yaml не найден. Убедитесь, что вы находитесь в корневой директории проекта.
    pause
    exit /b 1
)

REM Проверяем наличие Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Ошибка: Flutter не установлен или не добавлен в PATH
    pause
    exit /b 1
)

REM Устанавливаем зависимости
echo 📦 Установка зависимостей...
flutter pub get

REM Генерируем код
echo 🔧 Генерация кода...
dart run build_runner build --delete-conflicting-outputs

REM Запускаем приложение
echo 🚀 Запуск приложения на Windows...
flutter run -d windows

echo ✅ Готово!
pause
