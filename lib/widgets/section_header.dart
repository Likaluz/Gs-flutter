import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';

/// Título de seção padronizado com ícone opcional.
class SectionHeader extends StatelessWidget {
  final String titulo;
  final IconData? icone;

  const SectionHeader({super.key, required this.titulo, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.sm, top: AppDimens.sm),
      child: Row(
        children: [
          if (icone != null) ...[
            Icon(icone, size: 20, color: AppColors.primary),
            const SizedBox(width: AppDimens.sm),
          ],
          Text(
            titulo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
