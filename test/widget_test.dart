import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/parceleAjout.dart';

void main() {
  testWidgets('Affiche une erreur si le nom est vide', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ParcelleFormScreen(),
      ),
    );

    final liste = find.byType(ListView);
    final bouton = find.widgetWithText(
      ElevatedButton,
      'ENREGISTRER',
    );

    await tester.drag(
      liste,
      const Offset(0, -500),
    );
    await tester.pump();

    await tester.tap(bouton);
    await tester.pump();

    expect(find.text('Veuillez entrer le nom'), findsOneWidget);
  });
}