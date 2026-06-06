/// Funcoes utilitarias de formatacao reutilizadas pela aplicacao.
/// Implementadas sem dependencias externas para maxima portabilidade.
class Formatters {
  Formatters._();

  static String _2(int n) => n.toString().padLeft(2, '0');

  static String _4(int n) => n.toString().padLeft(4, '0');

  /// Formato de data exibido para o usuario (ex.: 05/06).
  static String diaMes(DateTime date) => '${_2(date.day)}/${_2(date.month)}';

  /// Formato completo (ex.: 05/06/2026).
  static String diaMesAno(DateTime date) =>
      '${_2(date.day)}/${_2(date.month)}/${_4(date.year)}';

  /// Formato exigido pela API da NASA POWER (ex.: 20260605).
  static String nasaDate(DateTime date) =>
      '${_4(date.year)}${_2(date.month)}${_2(date.day)}';

  /// Numero com casas decimais e unidade opcional.
  static String numero(double? valor, {String unidade = '', int casas = 1}) {
    if (valor == null) return '--';
    return '${valor.toStringAsFixed(casas)}$unidade';
  }
}
