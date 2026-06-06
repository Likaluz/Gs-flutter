import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/models/diagnostico.dart';

/// Mapeia o nível de status em recursos visuais (cor e ícone),
/// garantindo padronização em toda a interface.
class StatusVisuals {
  StatusVisuals._();

  static Color cor(NivelStatus nivel) {
    switch (nivel) {
      case NivelStatus.ok:
        return AppColors.statusOk;
      case NivelStatus.atencao:
        return AppColors.statusAtencao;
      case NivelStatus.critico:
        return AppColors.statusCritico;
    }
  }

  static IconData icone(NivelStatus nivel) {
    switch (nivel) {
      case NivelStatus.ok:
        return Icons.check_circle;
      case NivelStatus.atencao:
        return Icons.warning_amber_rounded;
      case NivelStatus.critico:
        return Icons.error;
    }
  }
}
