import 'package:flutter/material.dart';

import '../core/constants/app_dimens.dart';
import '../data/models/diagnostico.dart';
import 'status_visuals.dart';

/// Selo colorido que comunica o nível de um status (Normal/Atenção/Crítico).
class StatusChip extends StatelessWidget {
  final NivelStatus nivel;
  final bool compacto;

  const StatusChip({super.key, required this.nivel, this.compacto = false});

  @override
  Widget build(BuildContext context) {
    final cor = StatusVisuals.cor(nivel);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compacto ? AppDimens.sm : AppDimens.md,
        vertical: AppDimens.xs,
      ),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(StatusVisuals.icone(nivel), size: compacto ? 14 : 16, color: cor),
          const SizedBox(width: AppDimens.xs),
          Text(
            nivel.label,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.w600,
              fontSize: compacto ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
