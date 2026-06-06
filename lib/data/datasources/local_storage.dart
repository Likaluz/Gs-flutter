import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lavoura.dart';
import 'lavoura_storage.dart';

/// Fonte de dados local responsável por persistir as lavouras do usuário
/// usando SharedPreferences (armazenamento simples chave-valor).
///
/// A lista de lavouras é serializada como JSON sob uma única chave.
class LocalStorage implements LavouraStorage {
  static const String _chaveLavouras = 'agrospace.lavouras';

  @override
  Future<List<Lavoura>> listar() async {
    final lavouras = await lerLavouras();
    lavouras.sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    return lavouras;
  }

  @override
  Future<List<Lavoura>> adicionar(Lavoura lavoura) async {
    final lavouras = await lerLavouras();
    lavouras.add(lavoura);
    await salvarLavouras(lavouras);
    return listar();
  }

  @override
  Future<List<Lavoura>> remover(String id) async {
    final lavouras = await lerLavouras();
    lavouras.removeWhere((l) => l.id == id);
    await salvarLavouras(lavouras);
    return listar();
  }

  Future<List<Lavoura>> lerLavouras() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chaveLavouras);
    if (raw == null || raw.isEmpty) return [];

    final lista = jsonDecode(raw) as List<dynamic>;
    return lista
        .map((e) => Lavoura.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvarLavouras(List<Lavoura> lavouras) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(lavouras.map((l) => l.toJson()).toList());
    await prefs.setString(_chaveLavouras, raw);
  }
}
