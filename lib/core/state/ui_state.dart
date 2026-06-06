/// Estado genérico de UI usado pelas ViewModels.
///
/// Cobre os quatro estados exigidos no consumo de dados:
/// inicial, carregamento, sucesso e erro.
sealed class UiState<T> {
  const UiState();
}

/// Estado inicial, antes de qualquer requisição.
class UiInitial<T> extends UiState<T> {
  const UiInitial();
}

/// Carregando dados (mostrar indicador de progresso).
class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

/// Dados carregados com sucesso.
class UiSuccess<T> extends UiState<T> {
  final T data;
  const UiSuccess(this.data);
}

/// Ocorreu um erro durante a operação.
class UiError<T> extends UiState<T> {
  final String message;
  const UiError(this.message);
}
