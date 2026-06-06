import 'package:flutter/foundation.dart';

import '../core/state/ui_state.dart';
import '../data/models/diagnostico.dart';
import '../data/models/lavoura.dart';
import '../data/repositories/monitoramento_repository.dart';

/// ViewModel da tela de detalhes. Busca os dados de satélite da lavoura
/// e expõe o diagnóstico como [UiState], cobrindo os estados de
/// carregamento, sucesso e erro.
class DetalheLavouraViewModel extends ChangeNotifier {
  final MonitoramentoRepository _repository;
  final Lavoura lavoura;

  DetalheLavouraViewModel({
    required this.lavoura,
    MonitoramentoRepository? repository,
  }) : _repository = repository ?? MonitoramentoRepository();

  UiState<Diagnostico> _state = const UiInitial();
  UiState<Diagnostico> get state => _state;

  Future<void> carregarDiagnostico() async {
    _state = const UiLoading();
    notifyListeners();
    try {
      final diagnostico = await _repository.diagnosticar(lavoura);
      _state = UiSuccess(diagnostico);
    } catch (e) {
      _state = UiError(e.toString());
    }
    notifyListeners();
  }
}
