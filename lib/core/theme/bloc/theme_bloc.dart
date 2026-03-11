import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part  'theme_event.dart';
part 'theme_state.dart';

const _kThemePrefKey = 'safedrop_theme_mode';

/// Stored string values mapped to [ThemeMode].
const _kLight  = 'light';
const _kDark   = 'dark';
const _kSystem = 'system';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeInitialized>(_onInitialized);
    on<ThemeToggled>(_onToggled);
    on<ThemeModeSet>(_onModeSet);
    on<ThemeReset>(_onReset);
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  /// Loads the persisted [ThemeMode] from [SharedPreferences].
  /// Falls back to [ThemeMode.system] if no preference is stored.
  Future<void> _onInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemePrefKey);

    final mode = _modeFromString(stored);

    emit(state.copyWith(
      themeMode: mode,
      status:    ThemeLoadStatus.ready,
    ));
  }

  /// Toggles between [ThemeMode.light] and [ThemeMode.dark].
  /// If the current mode is [ThemeMode.system], resolves the current
  /// platform brightness first before switching to the opposite.
  Future<void> _onToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await _persistAndEmit(next, emit);
  }

  /// Sets a specific [ThemeMode] and persists it.
  Future<void> _onModeSet(
    ThemeModeSet event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.mode == state.themeMode) return; // no-op
    await _persistAndEmit(event.mode, emit);
  }

  /// Resets to [ThemeMode.system] and removes the stored preference.
  Future<void> _onReset(
    ThemeReset event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kThemePrefKey);

    emit(state.copyWith(
      themeMode: ThemeMode.system,
      status:    ThemeLoadStatus.ready,
    ));
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Persists [mode] to [SharedPreferences] then emits the updated state.
  Future<void> _persistAndEmit(
    ThemeMode mode,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePrefKey, _modeToString(mode));

    emit(state.copyWith(
      themeMode: mode,
      status:    ThemeLoadStatus.ready,
    ));
  }

  // ── Codec helpers ──────────────────────────────────────────────────────────

  static String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:  return _kLight;
      case ThemeMode.dark:   return _kDark;
      case ThemeMode.system: return _kSystem;
    }
  }

  static ThemeMode _modeFromString(String? value) {
    switch (value) {
      case _kLight:  return ThemeMode.light;
      case _kDark:   return ThemeMode.dark;
      default:       return ThemeMode.system;
    }
  }
}