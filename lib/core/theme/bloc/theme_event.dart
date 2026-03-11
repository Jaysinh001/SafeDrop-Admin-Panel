part of 'theme_bloc.dart';

// =============================================================================
// EVENTS
// =============================================================================

/// Base class — all theme events extend this.
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched once at app start. Loads persisted preference (or system default).
class ThemeInitialized extends ThemeEvent {
  const ThemeInitialized();
}

/// Toggles between light ↔ dark. If the current mode is [ThemeMode.system],
/// it resolves the current brightness first and then switches to the opposite.
class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

/// Explicitly sets a specific [ThemeMode].
class ThemeModeSet extends ThemeEvent {
  final ThemeMode mode;

  const ThemeModeSet(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Resets the mode to [ThemeMode.system] and clears the stored preference.
class ThemeReset extends ThemeEvent {
  const ThemeReset();
}