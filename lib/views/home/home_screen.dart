import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/responsive_content.dart';

/// Tela inicial do aplicativo. Apresenta a proposta do AgroSpace
/// e dá acesso à listagem de lavouras.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContent(
            padding: const EdgeInsets.all(AppDimens.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.lg),
                _Header(),
                const SizedBox(height: AppDimens.xl),
                _CardProposta(),
                const SizedBox(height: AppDimens.lg),
                _ComoFunciona(),
                const SizedBox(height: AppDimens.xl),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.lavouras),
                  icon: const Icon(Icons.satellite_alt),
                  label: const Text(AppStrings.verLavouras),
                ),
                const SizedBox(height: AppDimens.lg),
                const _FontesODS(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(AppDimens.radius),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.public, color: Colors.white, size: 36),
        ),
        const SizedBox(height: AppDimens.md),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 30,
              ),
        ),
        const SizedBox(height: AppDimens.xs),
        const Text(
          AppStrings.homeSubtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      ],
    );
  }
}

class _CardProposta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.secondary),
                const SizedBox(width: AppDimens.sm),
                Text('A proposta',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppDimens.sm),
            const Text(
              'Produtores rurais perdem produtividade por falta de '
              'monitoramento. O AgroSpace usa dados de satélite da NASA para '
              'acompanhar lavouras e detectar seca, excesso de água e risco '
              'de pragas — gerando diagnósticos automáticos.',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComoFunciona extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const passos = [
      ('1', 'Cadastre sua lavoura', 'Informe nome, cultura e localização.'),
      ('2', 'Coletamos dados de satélite', 'Via API pública da NASA POWER.'),
      ('3', 'Receba o diagnóstico', 'Indicadores de seca, água e pragas.'),
    ];
    return Column(
      children: passos.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary,
                child: Text(p.$1,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.$2,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(p.$3,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _FontesODS extends StatelessWidget {
  const _FontesODS();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppDimens.sm,
      runSpacing: AppDimens.sm,
      children: [
        _Tag(label: 'NASA POWER', icone: Icons.satellite_alt),
        _Tag(label: 'ODS 2 — Fome zero', icone: Icons.eco),
        _Tag(label: 'ODS 9 — Indústria e inovação', icone: Icons.factory),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData icone;
  const _Tag({required this.label, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md, vertical: AppDimens.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: AppColors.primary),
          const SizedBox(width: AppDimens.xs),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
