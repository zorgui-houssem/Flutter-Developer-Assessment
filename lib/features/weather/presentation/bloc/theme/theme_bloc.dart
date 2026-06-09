import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

const _kSettingsBox = 'settings';
const _kThemeModeKey = 'theme_mode';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.dark)) {
    on<ThemeStarted>(_onStarted);
    on<ThemeToggled>(_onToggled);
    add(const ThemeStarted());
  }

  Future<void> _onStarted(ThemeStarted event, Emitter<ThemeState> emit) async {
    try {
      final box = Hive.box<String>(_kSettingsBox);
      final saved = box.get(_kThemeModeKey);
      emit(ThemeState(saved == 'light' ? ThemeMode.light : ThemeMode.dark));
    } catch (_) {
      emit(const ThemeState(ThemeMode.dark));
    }
  }

  Future<void> _onToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final newMode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    try {
      final box = Hive.box<String>(_kSettingsBox);
      await box.put(
          _kThemeModeKey, newMode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
    emit(ThemeState(newMode));
  }
}
