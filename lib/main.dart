import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/firebase/firebase_bootstrap.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/lavouras_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const AgroSpaceApp());
}

/// Widget raiz do AgroSpace.
///
/// Registra os providers globais (gerenciamento de estado com Provider)
/// e configura tema, rota inicial e navegação nomeada.
class AgroSpaceApp extends StatelessWidget {
  const AgroSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModel da lista de lavouras é global para manter o estado
        // (e a persistência) ao navegar entre as telas.
        ChangeNotifierProvider<LavourasViewModel>(
          create: (_) => LavourasViewModel(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
