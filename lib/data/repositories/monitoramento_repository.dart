import '../models/diagnostico.dart';
import '../models/lavoura.dart';
import '../services/analise_service.dart';
import '../services/nasa_power_service.dart';

/// Repositório que orquestra o monitoramento de uma lavoura:
/// busca os dados de satélite (NASA POWER) e aplica a análise agroclimática,
/// devolvendo um [Diagnostico] pronto para a interface.
class MonitoramentoRepository {
  final NasaPowerService _nasaService;
  final AnaliseService _analiseService;

  MonitoramentoRepository({
    NasaPowerService? nasaService,
    AnaliseService? analiseService,
  })  : _nasaService = nasaService ?? NasaPowerService(),
        _analiseService = analiseService ?? AnaliseService();

  /// Gera o diagnóstico dos últimos [dias] para a lavoura informada.
  Future<Diagnostico> diagnosticar(Lavoura lavoura, {int dias = 30}) async {
    // A NASA POWER consolida os dados com alguns dias de defasagem,
    // por isso a janela termina há ~7 dias.
    final fim = DateTime.now().subtract(const Duration(days: 7));
    final inicio = fim.subtract(Duration(days: dias));

    final resposta = await _nasaService.buscarDadosAgro(
      latitude: lavoura.latitude,
      longitude: lavoura.longitude,
      inicio: inicio,
      fim: fim,
    );

    return _analiseService.analisar(resposta);
  }
}
