import 'package:flutter/material.dart';

/// Paleta de cores centralizada do AgroSpace.
/// Une o verde do agronegócio ao azul "espacial" da tecnologia de satélite.
class AppColors {
  AppColors._();

  // Marca
  static const Color primary = Color(0xFF1B5E20); // verde lavoura
  static const Color primaryLight = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFF0B3D91); // azul NASA / espaço
  static const Color accent = Color(0xFF00ACC1); // ciano tecnológico

  // Superfícies
  static const Color background = Color(0xFFF4F7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEAF1E8);

  // Texto
  static const Color textPrimary = Color(0xFF1A1C19);
  static const Color textSecondary = Color(0xFF5A655A);

  // Status de diagnóstico
  static const Color statusOk = Color(0xFF2E7D32);
  static const Color statusAtencao = Color(0xFFF9A825);
  static const Color statusCritico = Color(0xFFC62828);

  static const Color divider = Color(0xFFD8E0D6);
}
