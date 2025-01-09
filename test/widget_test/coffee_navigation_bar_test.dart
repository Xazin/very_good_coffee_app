import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/presentation/shared/coffee_navigation_bar.dart';

import 'utils.dart';

void main() {
  group('CoffeeNavigationBar tests', () {
    testWidgets('functionality', (tester) async {
      var currentIndex = 0;
      await tester.pumpWidget(
        wrapWithMaterialApp(
          CoffeeNavigationBar(
            destinations: const [
              CoffeeDestination(icon: Icon(Icons.abc), label: 'ABC'),
              CoffeeDestination(icon: Icon(Icons.apple), label: 'APPLE'),
              CoffeeDestination(icon: Icon(Icons.alarm), label: 'ALARM'),
            ],
            onDestinationSelected: (index) => currentIndex = index,
          ),
        ),
      );

      expect(currentIndex, 0);

      await tester.tap(find.byIcon(Icons.alarm));
      await tester.pump();

      expect(currentIndex, 2);

      await tester.tap(find.byIcon(Icons.abc));
      await tester.pump();

      expect(currentIndex, 0);

      await tester.tap(find.byIcon(Icons.apple));
      await tester.pump();

      expect(currentIndex, 1);
    });
  });
}
