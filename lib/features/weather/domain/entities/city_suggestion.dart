import 'package:equatable/equatable.dart';

class CitySuggestion extends Equatable {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;

  const CitySuggestion({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
  });

  String get displayName {
    final parts = [name];
    if (state != null && state!.isNotEmpty) parts.add(state!);
    parts.add(country);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [name, country, state, lat, lon];
}
