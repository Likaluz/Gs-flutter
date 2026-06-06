import 'package:flutter_test/flutter_test.dart';

import 'package:agrospace/data/datasources/lavoura_storage.dart';
import 'package:agrospace/data/models/cultura.dart';
import 'package:agrospace/data/models/lavoura.dart';
import 'package:agrospace/data/repositories/lavoura_repository.dart';
import 'package:agrospace/viewmodels/lavouras_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LavouraRepository persiste lavoura para uma nova instancia',
      () async {
    final storage = FakeLavouraStorage();
    final repository = LavouraRepository(storage: storage);
    final lavoura = Lavoura(
      id: 'lavoura-1',
      nome: 'Talhao Norte',
      cultura: Cultura.soja,
      latitude: -13,
      longitude: -55.9,
      criadaEm: DateTime(2026, 6, 6),
    );

    await repository.adicionar(lavoura);

    final repositoryAoReabrir = LavouraRepository(storage: storage);
    final lavouras = await repositoryAoReabrir.listar();

    expect(lavouras, hasLength(1));
    expect(lavouras.single.id, lavoura.id);
    expect(lavouras.single.nome, lavoura.nome);
    expect(lavouras.single.cultura, lavoura.cultura);
    expect(lavouras.single.latitude, lavoura.latitude);
    expect(lavouras.single.longitude, lavoura.longitude);
  });

  test('LavourasViewModel carrega lavouras salvas ao ser criado', () async {
    final storage = FakeLavouraStorage();
    await LavouraRepository(storage: storage).adicionar(
      Lavoura(
        id: 'lavoura-2',
        nome: 'Talhao Sul',
        cultura: Cultura.milho,
        latitude: -14,
        longitude: -56,
        criadaEm: DateTime(2026, 6, 6),
      ),
    );

    final viewModel = LavourasViewModel(
      repository: LavouraRepository(storage: storage),
    );
    await viewModel.carregar();

    expect(viewModel.lavouras, hasLength(1));
    expect(viewModel.lavouras.single.nome, 'Talhao Sul');

    viewModel.dispose();
  });
}

class FakeLavouraStorage implements LavouraStorage {
  final List<Lavoura> _lavouras = [];

  @override
  Future<List<Lavoura>> listar() async {
    final lavouras = List<Lavoura>.from(_lavouras)
      ..sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    return lavouras;
  }

  @override
  Future<List<Lavoura>> adicionar(Lavoura lavoura) async {
    _lavouras.add(lavoura);
    return listar();
  }

  @override
  Future<List<Lavoura>> remover(String id) async {
    _lavouras.removeWhere((l) => l.id == id);
    return listar();
  }
}
