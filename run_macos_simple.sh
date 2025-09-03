#!/bin/bash

# Простой скрипт для запуска без CocoaPods

echo "🎮 Запуск игры 'Интуиция' на macOS (без CocoaPods)..."

# Устанавливаем зависимости
echo "📦 Установка зависимостей..."
flutter pub get

# Генерируем код
echo "🔧 Генерация кода..."
dart run build_runner build --delete-conflicting-outputs

# Запускаем приложение без CocoaPods
echo "🚀 Запуск приложения на macOS..."
flutter run -d macos --no-pub

echo "✅ Готово!"
