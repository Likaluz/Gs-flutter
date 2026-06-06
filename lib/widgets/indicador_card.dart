import 'package:flutter/material.dart';

import '../core/constants/app_dimens.dart';
import '../data/models/diagnostico.dart';
import 'status_chip.dart';
import 'status_visuals.dart';

/// Card que apresenta um indicador (seca, água, pragas) com seu nível,
/// emoji do tipo e descrição explicativa.
class IndicadorCard extends StatelessWidget {
  final Indicador indicador;

  const IndicadorCard({super.key, required this.indicador});

  @override
  Widget build(BuildContext context) {
    final cor = StatusVisuals.cor(indicador.nivel);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border(left: BorderSide(color: cor, width: 5)),
        ),
        padding: const EdgeInsets.all(AppDimens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(indicador.tipo.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: Text(
                    indicador.tipo.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatusChip(nivel: indicador.nivel, compacto: true),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            Text(
              indicador.descricao,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
