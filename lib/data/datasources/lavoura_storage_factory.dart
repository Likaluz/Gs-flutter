import 'package:firebase_core/firebase_core.dart';

import 'firestore_lavoura_storage.dart';
import 'lavoura_storage.dart';
import 'local_storage.dart';

class LavouraStorageFactory {
  const LavouraStorageFactory._();

  static LavouraStorage criar() {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreLavouraStorage();
    }

    return LocalStorage();
  }
}
