import 'package:flutter/foundation.dart';

import '../data/models/cultura.dart';

/// ViewModel do formulário de cadastro de lavoura.
/// Concentra a validação dos campos, mantendo as regras fora da tela.
class CadastroLavouraViewModel extends ChangeNotifier {
  Cultura culturaSelecionada = Cultura.soja;

  void selecionarCultura(Cultura cultura) {
    culturaSelecionada = cultura;
    notifyListeners();
  }

  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe um nome para a lavoura.';
    }
    if (valor.trim().length < 3) {
      return 'O nome deve ter ao menos 3 caracteres.';
    }
    return null;
  }

  String? validarLatitude(String? valor) {
    final n = double.tryParse((valor ?? '').replaceAll(',', '.'));
    if (n == null) return 'Latitude inválida.';
    if (n < -90 || n > 90) return 'A latitude deve estar entre -90 e 90.';
    return null;
  }

  String? validarLongitude(String? valor) {
    final n = double.tryParse((valor ?? '').replaceAll(',', '.'));
    if (n == null) return 'Longitude inválida.';
    if (n < -180 || n > 180) return 'A longitude deve estar entre -180 e 180.';
    return null;
  }

  double parseCoordenada(String valor) =>
      double.parse(valor.replaceAll(',', '.'));
}
