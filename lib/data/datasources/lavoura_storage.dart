import '../models/lavoura.dart';

/// Contrato de persistencia das lavouras.
abstract class LavouraStorage {
  Future<List<Lavoura>> listar();

  Future<List<Lavoura>> adicionar(Lavoura lavoura);

  Future<List<Lavoura>> remover(String id);
}
