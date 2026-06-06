import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../data/models/lavoura.dart';

/// Card que representa uma lavoura na listagem.
/// Reutilizável e padronizado; recebe callbacks de toque e remoção.
class LavouraCard extends StatelessWidget {
  final Lavoura lavoura;
  final VoidCallback onTap;
  final VoidCallback? onRemover;

  const LavouraCard({
    super.key,
    required this.lavoura,
    required this.onTap,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  lavoura.cultura.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lavoura.nome,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lavoura.cultura.label,
                      style: const TextStyle(color: AppColors.primaryLight),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            lavoura.coordenadas,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onRemover != null)
                IconButton(
                  onPressed: onRemover,
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.textSecondary),
                  tooltip: 'Remover',
                ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
