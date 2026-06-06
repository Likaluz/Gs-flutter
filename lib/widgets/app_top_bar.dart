import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// AppBar padronizada do AgroSpace (cor da marca e texto branco).
/// Componente reutilizável usado nas telas internas.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? actions;

  const AppTopBar({super.key, required this.titulo, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: actions,
    );
  }
}
