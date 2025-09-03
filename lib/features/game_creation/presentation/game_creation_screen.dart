import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/features/game_creation/models/game_creation_models.dart';
import 'package:intuition/features/game_creation/widgets/game_name_section.dart';
import 'package:intuition/features/game_creation/widgets/persons_section_legacy.dart';
import 'package:intuition/features/game_creation/widgets/start_fact_section.dart';
import 'package:intuition/shared/widgets/app_logo.dart';

class GameCreationScreen extends StatefulWidget {
  const GameCreationScreen({super.key});

  @override
  State<GameCreationScreen> createState() => _GameCreationScreenState();
}

class _GameCreationScreenState extends State<GameCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gameData = GameCreationData();

  @override
  void dispose() {
    _gameData.nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: const AppLogoIcon(size: 28),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveGame,
            child: const Text(
              'Сохранить',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameNameSection(controller: _gameData.nameController),
              const SizedBox(height: 24),
              PersonsSectionLegacy(
                persons: _gameData.persons,
                onAddPerson: _addPerson,
                onRemovePerson: _removePerson,
                selectedStartFactIndex: _gameData.selectedStartFactIndex,
                onStartFactChanged: _onStartFactChanged,
              ),
              const SizedBox(height: 24),
              StartFactSection(gameData: _gameData),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _addPerson() {
    setState(() {
      _gameData.persons.add(PersonData());
    });
  }

  void _removePerson(int index) {
    setState(() {
      _gameData.persons.removeAt(index);
      _gameData.updateStartFactIndex();
    });
  }

  void _onStartFactChanged(int index) {
    setState(() {
      _gameData.selectedStartFactIndex = index;
    });
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Создать игру',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _saveGame() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final errors = _gameData.validate();
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errors.first), backgroundColor: Colors.red),
      );
      return;
    }

    // TODO: Сохранить игру в базу данных
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Игра успешно создана!'),
        backgroundColor: Colors.green,
      ),
    );

    // Возвращаемся на главный экран
    context.pop();
  }
}
