/// Textos fixos da aplicação, centralizados para padronização e fácil manutenção.
class AppStrings {
  AppStrings._();

  static const String appName = 'AgroSpace';
  static const String tagline = 'Monitoramento de lavouras por satélite';

  // Home
  static const String homeTitle = 'AgroSpace';
  static const String homeSubtitle =
      'Dados de satélite da NASA aplicados à agricultura de precisão';
  static const String verLavouras = 'Minhas lavouras';
  static const String sobreProjeto = 'Sobre o projeto';

  // Lavouras
  static const String lavourasTitle = 'Minhas lavouras';
  static const String nenhumaLavoura =
      'Nenhuma lavoura cadastrada ainda.\nToque em "+" para adicionar a primeira.';
  static const String adicionarLavoura = 'Adicionar lavoura';

  // Cadastro
  static const String cadastroTitle = 'Nova lavoura';
  static const String campoNome = 'Nome da lavoura';
  static const String campoCultura = 'Cultura';
  static const String campoLatitude = 'Latitude';
  static const String campoLongitude = 'Longitude';
  static const String salvar = 'Salvar lavoura';

  // Detalhe
  static const String diagnosticoTitle = 'Diagnóstico de satélite';
  static const String indicadores = 'Indicadores';
  static const String condicoesClimaticas = 'Condições climáticas (30 dias)';
  static const String fonteDados = 'Fonte: NASA POWER (dados agroclimáticos)';

  // Genéricos
  static const String tentarNovamente = 'Tentar novamente';
  static const String carregando = 'Carregando dados de satélite...';
  static const String erroGenerico =
      'Não foi possível obter os dados. Verifique a conexão e tente novamente.';
}
