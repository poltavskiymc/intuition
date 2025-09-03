#!/bin/bash

# Скрипт для запуска приложения "Интуиция" на macOS

echo "🎮 Запуск игры 'Интуиция' на macOS..."

# Настраиваем PATH для CocoaPods
export PATH="/Users/poltavchenko_av/.rbenv/shims:$PATH"

# Настраиваем архитектуру для Xcode (убираем предупреждение о множественных целях)
export ARCHS="arm64"

# Проверяем, что мы в правильной директории
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Ошибка: pubspec.yaml не найден. Убедитесь, что вы находитесь в корневой директории проекта."
    exit 1
fi

# Проверяем наличие Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Ошибка: Flutter не установлен или не добавлен в PATH"
    exit 1
fi

# Проверяем наличие CocoaPods
if ! command -v pod &> /dev/null; then
    echo "❌ Ошибка: CocoaPods не найден в PATH"
    echo "💡 Попробуйте выполнить: gem install cocoapods"
    exit 1
fi

echo "✅ CocoaPods найден: $(which pod)"

# Проверяем доступность macOS устройства
echo "📱 Проверка доступных устройств..."
flutter devices

# Устанавливаем зависимости
echo "📦 Установка зависимостей..."
flutter pub get

# Генерируем код
echo "🔧 Генерация кода..."
dart run build_runner build --delete-conflicting-outputs

# Запускаем приложение
echo "🚀 Запуск приложения на macOS..."
flutter run -d macos

echo "✅ Готово!"
