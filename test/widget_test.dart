// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// !!! ЗАМІНИ шлях нижче, щоб він збігався з name: у pubspec.yaml
import 'package:lab_1/main.dart';

void main() {
  testWidgets('Початкове значення лічильника 0 і +1 працює', (tester) async {
    // Будуємо додаток (наш кореневий віджет тепер App, не MyApp)
    await tester.pumpWidget(const App());

    // На старті має бути “0”
    expect(find.text('0'), findsOneWidget);

    // Тиснемо на кнопку з іконкою додавання
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // або await tester.pumpAndSettle();

    // Очікуємо “1”
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Ввід числа додає до лічильника', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('0'), findsOneWidget);

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), '5');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Підтвердити')
        .first
        .evaluate()
        .isNotEmpty
        ? find.widgetWithText(ElevatedButton, 'Підтвердити')
        : find.widgetWithText(FilledButton, 'Підтвердити'));
    await tester.pump();

    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('Avada Kedavra скидає до 0', (tester) async {
    await tester.pumpWidget(const App());

    await tester.enterText(find.byType(TextField), '3');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Підтвердити').evaluate().isNotEmpty
          ? find.widgetWithText(ElevatedButton, 'Підтвердити')
          : find.widgetWithText(FilledButton, 'Підтвердити'),
    );
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Avada Kedavra');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Підтвердити').evaluate().isNotEmpty
          ? find.widgetWithText(ElevatedButton, 'Підтвердити')
          : find.widgetWithText(FilledButton, 'Підтвердити'),
    );
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
  });
}
