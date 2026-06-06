import 'package:flutter/material.dart';

import '../../data/models/lavoura.dart';
import '../../views/cadastro/cadastro_lavoura_screen.dart';
import '../../views/detalhe/detalhe_lavoura_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/lavouras/lavouras_screen.dart';

/// Centraliza os nomes e a geração das rotas da aplicação,
/// mantendo a navegação organizada e desacoplada das telas.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String lavouras = '/lavouras';
  static const String detalhe = '/detalhe';
  static const String cadastro = '/cadastro';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _build(const HomeScreen(), settings);
      case lavouras:
        return _build(const LavourasScreen(), settings);
      case cadastro:
        return _build(const CadastroLavouraScreen(), settings);
      case detalhe:
        final lavoura = settings.arguments as Lavoura;
        return _build(DetalheLavouraScreen(lavoura: lavoura), settings);
      default:
        return _build(
          const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _build(Widget page, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
