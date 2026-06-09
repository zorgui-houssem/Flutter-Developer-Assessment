part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode mode;

  const ThemeState(this.mode);

  bool get isDark => mode == ThemeMode.dark;

  @override
  List<Object?> get props => [mode];
}
