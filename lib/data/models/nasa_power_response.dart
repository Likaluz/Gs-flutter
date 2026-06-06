/// Registro climático de um único dia, derivado dos dados de satélite/reanálise
/// da NASA POWER. Valores ausentes (-999 na API) são representados como null.
class RegistroDiario {
  final DateTime data;
  final double? temperatura; // T2M (°C)
  final double? temperaturaMax; // T2M_MAX (°C)
  final double? temperaturaMin; // T2M_MIN (°C)
  final double? precipitacao; // PRECTOTCORR (mm/dia)
  final double? umidade; // RH2M (%)
  final double? umidadeSolo; // GWETROOT (0-1, fração)

  const RegistroDiario({
    required this.data,
    this.temperatura,
    this.temperaturaMax,
    this.temperaturaMin,
    this.precipitacao,
    this.umidade,
    this.umidadeSolo,
  });
}

/// Resposta tratada da API NASA POWER, já convertida em uma série
/// de registros diários ordenados por data.
class NasaPowerResponse {
  final List<RegistroDiario> registros;

  const NasaPowerResponse({required this.registros});

  factory NasaPowerResponse.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>?;
    final parameter = properties?['parameter'] as Map<String, dynamic>?;

    if (parameter == null) {
      return const NasaPowerResponse(registros: []);
    }

    Map<String, dynamic> serie(String chave) =>
        (parameter[chave] as Map<String, dynamic>?) ?? const {};

    final t2m = serie('T2M');
    final t2mMax = serie('T2M_MAX');
    final t2mMin = serie('T2M_MIN');
    final precip = serie('PRECTOTCORR');
    final rh2m = serie('RH2M');
    final solo = serie('GWETROOT');

    // As chaves de data (yyyyMMdd) vêm de qualquer um dos parâmetros.
    final chaves = (t2m.isNotEmpty ? t2m.keys : precip.keys).toList()..sort();

    final registros = <RegistroDiario>[];
    for (final chave in chaves) {
      registros.add(
        RegistroDiario(
          data: _parseData(chave),
          temperatura: _valor(t2m[chave]),
          temperaturaMax: _valor(t2mMax[chave]),
          temperaturaMin: _valor(t2mMin[chave]),
          precipitacao: _valor(precip[chave]),
          umidade: _valor(rh2m[chave]),
          umidadeSolo: _valor(solo[chave]),
        ),
      );
    }

    return NasaPowerResponse(registros: registros);
  }

  /// A NASA POWER usa -999 como "sem dado". Convertemos para null.
  static double? _valor(dynamic raw) {
    if (raw == null) return null;
    final v = (raw as num).toDouble();
    if (v <= -999) return null;
    return v;
  }

  static DateTime _parseData(String yyyymmdd) {
    final ano = int.parse(yyyymmdd.substring(0, 4));
    final mes = int.parse(yyyymmdd.substring(4, 6));
    final dia = int.parse(yyyymmdd.substring(6, 8));
    return DateTime(ano, mes, dia);
  }
}
