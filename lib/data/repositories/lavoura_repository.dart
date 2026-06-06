import '../datasources/lavoura_storage.dart';
import '../datasources/lavoura_storage_factory.dart';
import '../models/lavoura.dart';

/// Repositório responsável por gerenciar as lavouras do usuário.
///
/// Faz a ponte entre a fonte de dados (Firestore/local) e as ViewModels,
/// isolando a lógica de persistência das camadas superiores.
class LavouraRepository {
  final LavouraStorage _storage;

  LavouraRepository({LavouraStorage? storage})
      : _storage = storage ?? LavouraStorageFactory.criar();

  Future<List<Lavoura>> listar() async {
    return _storage.listar();
  }

  Future<List<Lavoura>> adicionar(Lavoura lavoura) async {
    return _storage.adicionar(lavoura);
  }

  Future<List<Lavoura>> remover(String id) async {
    return _storage.remover(id);
  }
}
