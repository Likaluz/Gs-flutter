import '../models/diagnostico.dart';
import '../models/nasa_power_response.dart';

/// Serviço de análise agroclimática.
///
/// Concentra as REGRAS DE NEGÓCIO do AgroSpace, mantendo-as fora das telas
/// e das ViewModels. A partir da série de dados de satélite, gera um
/// diagnóstico com indicadores de seca, excesso de água e risco de pragas.
class AnaliseService {
  /// Analisa uma resposta da NASA POWER e retorna o diagnóstico.
  Diagnostico analisar(NasaPowerResponse resposta) {
    final serie = resposta.registros;

    final tempMedia = _media(serie.map((r) => r.temperatura));
    final umidadeMedia = _media(serie.map((r) => r.umidade));
    final soloMedia = _media(serie.map((r) => r.umidadeSolo));
    final precipTotal = _soma(serie.map((r) => r.precipitacao));

    final indicadores = <Indicador>[
      _avaliarSeca(precipTotal, soloMedia, tempMedia),
      _avaliarExcessoAgua(precipTotal, soloMedia),
      _avaliarPragas(umidadeMedia, tempMedia),
    ];

    return Diagnostico(
      indicadores: indicadores,
      temperaturaMedia: tempMedia,
      precipitacaoTotal: precipTotal,
      umidadeMedia: umidadeMedia,
      umidadeSoloMedia: soloMedia,
      serie: serie,
    );
  }

  // -- Regras de negócio --------------------------------------------------

  /// Seca: pouca chuva acumulada e solo seco, agravada por calor.
  Indicador _avaliarSeca(
    double precipTotal,
    double? soloMedia,
    double? tempMedia,
  ) {
    final solo = soloMedia ?? 0.5;
    final temp = tempMedia ?? 25;

    NivelStatus nivel;
    if (precipTotal < 15 && solo < 0.3) {
      nivel = NivelStatus.critico;
    } else if (precipTotal < 40 || (solo < 0.4 && temp > 30)) {
      nivel = NivelStatus.atencao;
    } else {
      nivel = NivelStatus.ok;
    }

    final descricao = switch (nivel) {
      NivelStatus.critico =>
        'Chuva acumulada muito baixa (${precipTotal.toStringAsFixed(0)} mm) '
            'e solo seco. Risco elevado de estresse hídrico — avalie irrigação.',
      NivelStatus.atencao =>
        'Chuva abaixo do ideal no período. Monitore a umidade do solo '
            'nos próximos dias.',
      NivelStatus.ok =>
        'Disponibilidade hídrica adequada para a cultura no período.',
    };

    return Indicador(tipo: TipoIndicador.seca, nivel: nivel, descricao: descricao);
  }

  /// Excesso de água: muita chuva acumulada e solo encharcado.
  Indicador _avaliarExcessoAgua(double precipTotal, double? soloMedia) {
    final solo = soloMedia ?? 0.5;

    NivelStatus nivel;
    if (precipTotal > 250 && solo > 0.85) {
      nivel = NivelStatus.critico;
    } else if (precipTotal > 150 || solo > 0.75) {
      nivel = NivelStatus.atencao;
    } else {
      nivel = NivelStatus.ok;
    }

    final descricao = switch (nivel) {
      NivelStatus.critico =>
        'Chuva muito intensa (${precipTotal.toStringAsFixed(0)} mm) com solo '
            'saturado. Risco de encharcamento e perda de raízes — verifique drenagem.',
      NivelStatus.atencao =>
        'Volume de chuva elevado. Atenção a áreas de baixada e drenagem.',
      NivelStatus.ok => 'Nível de água no solo dentro da normalidade.',
    };

    return Indicador(
      tipo: TipoIndicador.excessoAgua,
      nivel: nivel,
      descricao: descricao,
    );
  }

  /// Risco de pragas/doenças: alta umidade + temperatura amena favorecem
  /// fungos e insetos.
  Indicador _avaliarPragas(double? umidadeMedia, double? tempMedia) {
    final umidade = umidadeMedia ?? 60;
    final temp = tempMedia ?? 25;

    final faixaIdeal = temp >= 20 && temp <= 30;

    NivelStatus nivel;
    if (umidade > 80 && faixaIdeal) {
      nivel = NivelStatus.critico;
    } else if (umidade > 70 && faixaIdeal) {
      nivel = NivelStatus.atencao;
    } else {
      nivel = NivelStatus.ok;
    }

    final descricao = switch (nivel) {
      NivelStatus.critico =>
        'Umidade alta (${umidade.toStringAsFixed(0)}%) e temperatura favorável '
            'à proliferação de fungos e pragas. Recomenda-se monitoramento intensivo.',
      NivelStatus.atencao =>
        'Condições moderadamente favoráveis a pragas. Inspeções periódicas '
            'são recomendadas.',
      NivelStatus.ok => 'Condições pouco favoráveis ao surgimento de pragas.',
    };

    return Indicador(
      tipo: TipoIndicador.pragas,
      nivel: nivel,
      descricao: descricao,
    );
  }

  // -- Auxiliares estatísticos -------------------------------------------

  double? _media(Iterable<double?> valores) {
    final validos = valores.whereType<double>().toList();
    if (validos.isEmpty) return null;
    return validos.reduce((a, b) => a + b) / validos.length;
  }

  double _soma(Iterable<double?> valores) {
    final validos = valores.whereType<double>();
    if (validos.isEmpty) return 0;
    return validos.reduce((a, b) => a + b);
  }
}
