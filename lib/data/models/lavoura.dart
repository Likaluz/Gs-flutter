import 'cultura.dart';

/// Representa uma lavoura monitorada pelo usuário.
/// É a entidade persistida localmente (SharedPreferences).
class Lavoura {
  final String id;
  final String nome;
  final Cultura cultura;
  final double latitude;
  final double longitude;
  final DateTime criadaEm;

  const Lavoura({
    required this.id,
    required this.nome,
    required this.cultura,
    required this.latitude,
    required this.longitude,
    required this.criadaEm,
  });

  Lavoura copyWith({
    String? nome,
    Cultura? cultura,
    double? latitude,
    double? longitude,
  }) {
    return Lavoura(
      id: id,
      nome: nome ?? this.nome,
      cultura: cultura ?? this.cultura,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      criadaEm: criadaEm,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cultura': cultura.id,
        'latitude': latitude,
        'longitude': longitude,
        'criadaEm': criadaEm.toIso8601String(),
      };

  factory Lavoura.fromJson(Map<String, dynamic> json) {
    return Lavoura(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cultura: Cultura.fromId(json['cultura'] as String?),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      criadaEm: DateTime.parse(json['criadaEm'] as String),
    );
  }

  String get coordenadas =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}
