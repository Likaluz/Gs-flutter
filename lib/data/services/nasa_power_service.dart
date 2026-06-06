import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/formatters.dart';
import '../models/nasa_power_response.dart';

/// Exceção específica para falhas no consumo da NASA POWER.
class NasaPowerException implements Exception {
  final String message;
  NasaPowerException(this.message);
  @override
  String toString() => message;
}

/// Cliente da API pública NASA POWER (Prediction Of Worldwide Energy Resources).
///
/// Endpoint de séries diárias por ponto geográfico, comunidade "AG"
/// (Agroclimatology). Não requer chave de API.
///
/// Documentação: https://power.larc.nasa.gov/docs/services/api/
class NasaPowerService {
  final http.Client _client;

  NasaPowerService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl =
      'https://power.larc.nasa.gov/api/temporal/daily/point';

  /// Parâmetros agroclimáticos consultados:
  /// - T2M / T2M_MAX / T2M_MIN: temperatura do ar a 2 m (°C)
  /// - PRECTOTCORR: precipitação corrigida (mm/dia)
  /// - RH2M: umidade relativa a 2 m (%)
  /// - GWETROOT: umidade do solo na zona radicular (fração 0-1)
  static const String _parametros =
      'T2M,T2M_MAX,T2M_MIN,PRECTOTCORR,RH2M,GWETROOT';

  Future<NasaPowerResponse> buscarDadosAgro({
    required double latitude,
    required double longitude,
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'parameters': _parametros,
      'community': 'AG',
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'start': Formatters.nasaDate(inicio),
      'end': Formatters.nasaDate(fim),
      'format': 'JSON',
    });

    try {
      final resp =
          await _client.get(uri).timeout(const Duration(seconds: 30));

      if (resp.statusCode != 200) {
        throw NasaPowerException(
          'Falha na consulta à NASA POWER (código ${resp.statusCode}).',
        );
      }

      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final resposta = NasaPowerResponse.fromJson(json);

      if (resposta.registros.isEmpty) {
        throw NasaPowerException(
          'Nenhum dado de satélite disponível para esta região/período.',
        );
      }
      return resposta;
    } on TimeoutException {
      throw NasaPowerException('Tempo de conexão esgotado. Tente novamente.');
    } on FormatException {
      throw NasaPowerException('Resposta inesperada do servidor da NASA.');
    }
  }
}
