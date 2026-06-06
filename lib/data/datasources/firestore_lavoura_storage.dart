import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lavoura.dart';
import 'lavoura_storage.dart';

/// Persistencia remota das lavouras no Cloud Firestore.
class FirestoreLavouraStorage implements LavouraStorage {
  FirestoreLavouraStorage({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('lavouras');

  @override
  Future<List<Lavoura>> listar() async {
    final snapshot = await _collection.get();
    final lavouras = snapshot.docs
        .map((doc) => Lavoura.fromJson({
              ...doc.data(),
              'id': doc.id,
            }))
        .toList();

    lavouras.sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    return lavouras;
  }

  @override
  Future<List<Lavoura>> adicionar(Lavoura lavoura) async {
    await _collection.doc(lavoura.id).set(lavoura.toJson());
    return listar();
  }

  @override
  Future<List<Lavoura>> remover(String id) async {
    await _collection.doc(id).delete();
    return listar();
  }
}
