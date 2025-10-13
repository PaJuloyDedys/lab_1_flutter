// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/main.dart';

/// Допоміжний пошук кнопки "Підтвердити" для будь-якого типу кнопки.
Finder _confirmBtn() {
  final filled = find.widgetWithText(FilledButton, 'Підтвердити');
  if (filled.evaluate().isNotEmpty) return filled;

  final elevated = find.widgetWithText(ElevatedButton, 'Підтвердити');
  if (elevated.evaluate().isNotEmpty) return elevated;

  // запасний варіант (натиск по тексту всередині кнопки)
  return find.text('Підтвердити');
}

void main() {
  testWidgets('Початкове значення 0 і +1 працює', (tester) async {
    await tester.pumpWidget(const App());

    // Перевіряємо саме лічильник через ValueKey(0)
    expect(find.byKey(const ValueKey(0)), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byKey(const ValueKey(1)), findsOneWidget);
  });

  testWidgets('Ввід числа додає до лічильника', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.byKey(const ValueKey(0)), findsOneWidget);

    await tester.enterText(find.byType(TextField), '5');
    await tester.tap(_confirmBtn());
    await tester.pump();

    // Перевіряємо, що лічильник став 5 (а не просто є текст "5" десь у повідомленні)
    expect(find.byKey(const ValueKey(5)), findsOneWidget);
  });

  testWidgets('"Avada Kedavra" скидає до 0', (tester) async {
    await tester.pumpWidget(const App());

    // Спершу піднімемо лічильник до 3
    await tester.enterText(find.byType(TextField), '3');
    await tester.tap(_confirmBtn());
    await tester.pump();
    expect(find.byKey(const ValueKey(3)), findsOneWidget);

    // Тепер магічна фраза — має скинути до 0
    await tester.enterText(find.byType(TextField), 'Avada Kedavra');
    await tester.tap(_confirmBtn());
    await tester.pump();

    expect(find.byKey(const ValueKey(0)), findsOneWidget);
  });
}
