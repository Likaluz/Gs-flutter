import 'package:flutter/foundation.dart';

import '../core/state/ui_state.dart';
import '../data/models/cultura.dart';
import '../data/models/lavoura.dart';
import '../data/repositories/lavoura_repository.dart';

/// ViewModel responsável pela lista de lavouras e suas operações
/// (carregar, adicionar, remover). Mantém o estado da tela e expõe
/// apenas dados/ações para a View — sem lógica de UI.
class LavourasViewModel extends ChangeNotifier {
  final LavouraRepository _repository;
  Future<void>? _carregamentoAtual;
  bool _jaCarregou = false;

  LavourasViewModel({LavouraRepository? repository})
      : _repository = repository ?? LavouraRepository() {
    carregar();
  }

  UiState<List<Lavoura>> _state = const UiInitial();
  UiState<List<Lavoura>> get state => _state;

  List<Lavoura> get lavouras {
    final s = _state;
    return s is UiSuccess<List<Lavoura>> ? s.data : const [];
  }

  Future<void> carregar() {
    if (_carregamentoAtual != null) return _carregamentoAtual!;
    if (_jaCarregou) return Future<void>.value();

    _carregamentoAtual = _carregar().whenComplete(() {
      _carregamentoAtual = null;
    });
    return _carregamentoAtual!;
  }

  Future<void> _carregar() async {
    _setState(const UiLoading());
    try {
      final lista = await _repository.listar();
      _jaCarregou = true;
      _setState(UiSuccess(lista));
    } catch (e) {
      _setState(UiError('Erro ao carregar lavouras: $e'));
    }
  }

  Future<void> adicionar({
    required String nome,
    required Cultura cultura,
    required double latitude,
    required double longitude,
  }) async {
    final nova = Lavoura(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nome: nome.trim(),
      cultura: cultura,
      latitude: latitude,
      longitude: longitude,
      criadaEm: DateTime.now(),
    );
    final lista = await _repository.adicionar(nova);
    _jaCarregou = true;
    _setState(UiSuccess(lista));
  }

  Future<void> remover(String id) async {
    final lista = await _repository.remover(id);
    _jaCarregou = true;
    _setState(UiSuccess(lista));
  }

  void _setState(UiState<List<Lavoura>> novo) {
    _state = novo;
    notifyListeners();
  }
}
