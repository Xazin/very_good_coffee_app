import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/presentation/shared/rounded_icon_button.dart';

import 'utils.dart';

void main() {
  group('RoundedIconButton tests', () {
    testWidgets('functionality', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithMaterialApp(
          RoundedIconButton(
            icon: Icons.abc,
            onTap: () => taps++,
          ),
        ),
      );

      expect(taps, 0);

      await tester.tap(find.byType(RoundedIconButton));
      await tester.pump();

      expect(taps, 1);

      await tester.tap(find.byType(RoundedIconButton));
      await tester.pump();

      expect(taps, 2);
    });
  });
}
