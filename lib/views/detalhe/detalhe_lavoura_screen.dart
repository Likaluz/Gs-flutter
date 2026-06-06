import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/state/ui_state.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/diagnostico.dart';
import '../../data/models/lavoura.dart';
import '../../viewmodels/detalhe_lavoura_viewmodel.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/clima_chart.dart';
import '../../widgets/indicador_card.dart';
import '../../widgets/metric_tile.dart';
import '../../widgets/responsive_content.dart';
import '../../widgets/section_header.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';

/// Tela de detalhes de uma lavoura: dispara a consulta à NASA POWER
/// e exibe o diagnóstico agroclimático com indicadores, métricas e gráficos.
class DetalheLavouraScreen extends StatelessWidget {
  final Lavoura lavoura;

  const DetalheLavouraScreen({super.key, required this.lavoura});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetalheLavouraViewModel>(
      create: (_) =>
          DetalheLavouraViewModel(lavoura: lavoura)..carregarDiagnostico(),
      child: _DetalheView(lavoura: lavoura),
    );
  }
}

class _DetalheView extends StatelessWidget {
  final Lavoura lavoura;
  const _DetalheView({required this.lavoura});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(titulo: lavoura.nome),
      body: SafeArea(
        child: Consumer<DetalheLavouraViewModel>(
          builder: (context, vm, _) {
            final state = vm.state;
            return switch (state) {
              UiInitial() || UiLoading() =>
                const LoadingView(mensagem: AppStrings.carregando),
              UiError(message: final msg) => ErrorView(
                  mensagem: msg,
                  onRetry: vm.carregarDiagnostico,
                ),
              UiSuccess(data: final diag) =>
                _Conteudo(lavoura: lavoura, diagnostico: diag),
            };
          },
        ),
      ),
    );
  }
}

class _Conteudo extends StatelessWidget {
  final Lavoura lavoura;
  final Diagnostico diagnostico;

  const _Conteudo({required this.lavoura, required this.diagnostico});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Cabecalho(lavoura: lavoura, diagnostico: diagnostico),
            const SizedBox(height: AppDimens.md),
            const SectionHeader(
                titulo: AppStrings.indicadores, icone: Icons.fact_check_outlined),
            ...diagnostico.indicadores.map(
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.sm),
                child: IndicadorCard(indicador: i),
              ),
            ),
            const SizedBox(height: AppDimens.sm),
            const SectionHeader(
                titulo: 'Resumo do período', icone: Icons.analytics_outlined),
            _GradeMetricas(diagnostico: diagnostico),
            const SizedBox(height: AppDimens.lg),
            const SectionHeader(
                titulo: AppStrings.condicoesClimaticas,
                icone: Icons.show_chart),
            ClimaChart(
              serie: diagnostico.serie,
              seletor: (r) => r.temperatura,
              cor: AppColors.statusCritico,
              titulo: 'Temperatura média (°C)',
            ),
            const SizedBox(height: AppDimens.md),
            ClimaChart(
              serie: diagnostico.serie,
              seletor: (r) => r.precipitacao,
              cor: AppColors.secondary,
              titulo: 'Precipitação diária (mm)',
            ),
            const SizedBox(height: AppDimens.lg),
            const Center(
              child: Text(
                AppStrings.fonteDados,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: AppDimens.lg),
          ],
        ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  final Lavoura lavoura;
  final Diagnostico diagnostico;

  const _Cabecalho({required this.lavoura, required this.diagnostico});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.md),
        child: Row(
          children: [
            Text(lavoura.cultura.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lavoura.cultura.label,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(lavoura.coordenadas,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: AppDimens.sm),
                  Row(
                    children: [
                      const Text('Situação geral: ',
                          style: TextStyle(color: AppColors.textSecondary)),
                      StatusChip(nivel: diagnostico.nivelGeral, compacto: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeMetricas extends StatelessWidget {
  final Diagnostico diagnostico;
  const _GradeMetricas({required this.diagnostico});

  @override
  Widget build(BuildContext context) {
    final soloPct = diagnostico.umidadeSoloMedia != null
        ? '${(diagnostico.umidadeSoloMedia! * 100).toStringAsFixed(0)}%'
        : '--';

    final metricas = [
      MetricTile(
        icone: Icons.thermostat,
        rotulo: 'Temp. média',
        valor: Formatters.numero(diagnostico.temperaturaMedia, unidade: '°C'),
        cor: AppColors.statusCritico,
      ),
      MetricTile(
        icone: Icons.water_drop_outlined,
        rotulo: 'Chuva total',
        valor: '${diagnostico.precipitacaoTotal.toStringAsFixed(0)} mm',
        cor: AppColors.secondary,
      ),
      MetricTile(
        icone: Icons.cloud_outlined,
        rotulo: 'Umidade do ar',
        valor: Formatters.numero(diagnostico.umidadeMedia, unidade: '%'),
        cor: AppColors.accent,
      ),
      MetricTile(
        icone: Icons.grass,
        rotulo: 'Umidade do solo',
        valor: soloPct,
        cor: AppColors.primary,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsivo: 2 colunas em telas estreitas, 4 em telas largas.
        final colunas = constraints.maxWidth > 520 ? 4 : 2;
        return GridView.count(
          crossAxisCount: colunas,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimens.sm,
          crossAxisSpacing: AppDimens.sm,
          childAspectRatio: 1.25,
          children: metricas,
        );
      },
    );
  }
}
