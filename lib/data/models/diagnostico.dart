import 'nasa_power_response.dart';

/// Nível de severidade de um indicador agroclimático.
enum NivelStatus {
  ok('Normal'),
  atencao('Atenção'),
  critico('Crítico');

  const NivelStatus(this.label);
  final String label;
}

/// Tipo de risco avaliado a partir dos dados de satélite.
enum TipoIndicador {
  seca('Seca', '☀️'),
  excessoAgua('Excesso de água', '🌧️'),
  pragas('Risco de pragas', '🐛');

  const TipoIndicador(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// Um indicador individual (ex.: risco de seca) com nível e explicação.
class Indicador {
  final TipoIndicador tipo;
  final NivelStatus nivel;
  final String descricao;

  const Indicador({
    required this.tipo,
    required this.nivel,
    required this.descricao,
  });
}

/// Diagnóstico completo de uma lavoura: indicadores + médias do período
/// + a série usada para os gráficos.
class Diagnostico {
  final List<Indicador> indicadores;
  final double? temperaturaMedia;
  final double precipitacaoTotal;
  final double? umidadeMedia;
  final double? umidadeSoloMedia;
  final List<RegistroDiario> serie;

  const Diagnostico({
    required this.indicadores,
    required this.temperaturaMedia,
    required this.precipitacaoTotal,
    required this.umidadeMedia,
    required this.umidadeSoloMedia,
    required this.serie,
  });

  /// Nível geral = o mais severo entre os indicadores.
  NivelStatus get nivelGeral {
    if (indicadores.any((i) => i.nivel == NivelStatus.critico)) {
      return NivelStatus.critico;
    }
    if (indicadores.any((i) => i.nivel == NivelStatus.atencao)) {
      return NivelStatus.atencao;
    }
    return NivelStatus.ok;
  }
}
