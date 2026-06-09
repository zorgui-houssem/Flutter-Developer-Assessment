part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeStarted extends ThemeEvent {
  const ThemeStarted();
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}
