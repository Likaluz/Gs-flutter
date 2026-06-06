// Teste de widget do AgroSpace.
//
// Verifica, de forma isolada, que a tela inicial (HomeScreen) é construída
// corretamente e exibe os elementos essenciais da proposta. A HomeScreen não
// depende de Provider nem de persistência, o que mantém o teste rápido e
// determinístico.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrospace/core/constants/app_strings.dart';
import 'package:agrospace/core/theme/app_theme.dart';
import 'package:agrospace/views/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen exibe título e acesso às lavouras',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );

    // O nome do app aparece na tela inicial.
    expect(find.text(AppStrings.homeTitle), findsOneWidget);

    // Existe o botão que leva à listagem de lavouras.
    expect(find.text(AppStrings.verLavouras), findsOneWidget);
  });
}
