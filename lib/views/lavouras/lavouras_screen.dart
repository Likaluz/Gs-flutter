import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/ui_state.dart';
import '../../data/models/lavoura.dart';
import '../../viewmodels/lavouras_viewmodel.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/lavoura_card.dart';
import '../../widgets/responsive_content.dart';
import '../../widgets/state_views.dart';

/// Tela de listagem das lavouras cadastradas (com persistência local).
class LavourasScreen extends StatefulWidget {
  const LavourasScreen({super.key});

  @override
  State<LavourasScreen> createState() => _LavourasScreenState();
}

class _LavourasScreenState extends State<LavourasScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega a lista assim que a tela é montada.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LavourasViewModel>().carregar();
    });
  }

  Future<void> _abrirCadastro() async {
    await Navigator.pushNamed(context, AppRoutes.cadastro);
  }

  void _confirmarRemocao(Lavoura lavoura) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover lavoura'),
        content: Text('Deseja remover "${lavoura.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<LavourasViewModel>().remover(lavoura.id);
              Navigator.pop(ctx);
            },
            child: const Text('Remover',
                style: TextStyle(color: AppColors.statusCritico)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(titulo: AppStrings.lavourasTitle),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova lavoura'),
      ),
      body: SafeArea(
        child: Consumer<LavourasViewModel>(
          builder: (context, vm, _) {
            final state = vm.state;
            return switch (state) {
              UiInitial() || UiLoading() =>
                const LoadingView(mensagem: 'Carregando lavouras...'),
              UiError(message: final msg) =>
                ErrorView(mensagem: msg, onRetry: vm.carregar),
              UiSuccess(data: final lista) => _buildLista(lista),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLista(List<Lavoura> lista) {
    if (lista.isEmpty) {
      return const EmptyView(
        icone: Icons.grass,
        mensagem: AppStrings.nenhumaLavoura,
      );
    }
    return ResponsiveContent(
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: lista.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppDimens.sm),
        itemBuilder: (context, index) {
          final lavoura = lista[index];
          return LavouraCard(
            lavoura: lavoura,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.detalhe,
              arguments: lavoura,
            ),
            onRemover: () => _confirmarRemocao(lavoura),
          );
        },
      ),
    );
  }
}
