part of 'theme_bloc.dart';

enum ThemeLoadStatus {
  /// Not yet initialised — waiting for SharedPreferences.
  initial,

  /// Preference has been loaded; theme is ready to use.
  ready,
}

class ThemeState extends Equatable {
  /// The active [ThemeMode] passed to [MaterialApp.themeMode].
  final ThemeMode themeMode;

  /// Whether the bloc has finished loading the persisted preference.
  final ThemeLoadStatus status;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.status = ThemeLoadStatus.initial,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeLoadStatus? status,
  }) => ThemeState(
    themeMode: themeMode ?? this.themeMode,
    status: status ?? this.status,
 );

   /// Returns `true` when the effective theme is dark.
  /// Resolves [ThemeMode.system] against the device brightness.
  bool get isDark {
    if (themeMode == ThemeMode.dark) return true;
    if (themeMode == ThemeMode.light) return false;
    // ThemeMode.system — inspect the platform brightness
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Human-readable label for the active mode — useful for UI toggle labels.
  String get modeLabel {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Icon that represents the current state for toggle buttons.
  IconData get modeIcon {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  @override
  List<Object?> get props => [themeMode, status];

  @override
  String toString() =>
      'ThemeState(mode: $themeMode, status: $status, isDark: $isDark)';
}
