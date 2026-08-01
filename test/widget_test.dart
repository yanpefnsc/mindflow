import 'package:flutter_test/flutter_test.dart';
import 'package:mindflow/main.dart';

void main() {
  testWidgets('MindFlow sobe e mostra a tela de boas-vindas', (WidgetTester tester) async {
    await tester.pumpWidget(const MindFlowApp());

    // Avança o tempo da SplashScreen (2 segundos)
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verifica se a tela de Welcome apareceu
    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Criar sua conta'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
