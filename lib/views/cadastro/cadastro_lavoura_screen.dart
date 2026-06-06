import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/cultura.dart';
import '../../viewmodels/cadastro_lavoura_viewmodel.dart';
import '../../viewmodels/lavouras_viewmodel.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/responsive_content.dart';
import '../../widgets/section_header.dart';

/// Tela de cadastro de uma nova lavoura, com formulário validado.
class CadastroLavouraScreen extends StatefulWidget {
  const CadastroLavouraScreen({super.key});

  @override
  State<CadastroLavouraScreen> createState() => _CadastroLavouraScreenState();
}

class _CadastroLavouraScreenState extends State<CadastroLavouraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lonCtrl = TextEditingController();

  late final CadastroLavouraViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CadastroLavouraViewModel();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<LavourasViewModel>().adicionar(
          nome: _nomeCtrl.text,
          cultura: _vm.culturaSelecionada,
          latitude: _vm.parseCoordenada(_latCtrl.text),
          longitude: _vm.parseCoordenada(_lonCtrl.text),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lavoura cadastrada com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CadastroLavouraViewModel>.value(
      value: _vm,
      child: Scaffold(
        appBar: const AppTopBar(titulo: AppStrings.cadastroTitle),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ResponsiveContent(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeader(
                        titulo: 'Dados da lavoura', icone: Icons.info_outline),
                    TextFormField(
                      controller: _nomeCtrl,
                      decoration: const InputDecoration(
                        labelText: AppStrings.campoNome,
                        hintText: 'Ex.: Talhão Norte',
                        prefixIcon: Icon(Icons.spa_outlined),
                      ),
                      validator: _vm.validarNome,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDimens.md),
                    _SeletorCultura(),
                    const SizedBox(height: AppDimens.lg),
                    const SectionHeader(
                        titulo: 'Localização', icone: Icons.place_outlined),
                    const Text(
                      'Coordenadas geográficas usadas para consultar os '
                      'dados de satélite da NASA.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: AppDimens.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latCtrl,
                            decoration: const InputDecoration(
                              labelText: AppStrings.campoLatitude,
                              hintText: '-23.5505',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            validator: _vm.validarLatitude,
                          ),
                        ),
                        const SizedBox(width: AppDimens.md),
                        Expanded(
                          child: TextFormField(
                            controller: _lonCtrl,
                            decoration: const InputDecoration(
                              labelText: AppStrings.campoLongitude,
                              hintText: '-46.6333',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            validator: _vm.validarLongitude,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          // Exemplo prático (região agrícola de MT).
                          _latCtrl.text = '-13.0';
                          _lonCtrl.text = '-55.9';
                        },
                        icon: const Icon(Icons.my_location, size: 18),
                        label: const Text('Usar coordenadas de exemplo'),
                      ),
                    ),
                    const SizedBox(height: AppDimens.lg),
                    ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text(AppStrings.salvar),
                    ),
                    const SizedBox(height: AppDimens.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeletorCultura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CadastroLavouraViewModel>(
      builder: (context, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.campoCultura,
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimens.sm),
            Wrap(
              spacing: AppDimens.sm,
              runSpacing: AppDimens.sm,
              children: Cultura.values.map((c) {
                final selecionada = c == vm.culturaSelecionada;
                return ChoiceChip(
                  label: Text('${c.emoji} ${c.label}'),
                  selected: selecionada,
                  onSelected: (_) => vm.selecionarCultura(c),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
