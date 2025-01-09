import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:very_good_coffee_app/application/startup.dart';
import 'package:very_good_coffee_app/main.dart';
import 'package:very_good_coffee_app/presentation/explore/widgets/explore_coffee_card.dart';
import 'package:very_good_coffee_app/presentation/library/widgets/library_item.dart';
import 'package:very_good_coffee_app/presentation/shared/coffee_navigation_bar.dart';
import 'package:very_good_coffee_app/presentation/shared/shared.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    registerGetIt();
  });

  group('Test explore & library functionality', () {
    testWidgets('', (tester) async {
      await tester.pumpWidget(const AppWidget());
      await tester.pumpAndSettle();

      // Ensure the card with a random coffee is seen
      expect(find.byType(ExploreCoffeeCard), findsOneWidget);

      final favoriteFinder = find.byWidgetPredicate(
        (w) => w is RoundedIconButton && w.icon == Icons.favorite,
      );

      // Ensure the favorite button can be found
      expect(favoriteFinder, findsOneWidget);

      // Navigate to the Library screen
      final libraryBtn = find.byWidgetPredicate(
        (w) => w is CoffeeDestination && w.label == 'Library',
      );
      await tester.tap(libraryBtn);
      await tester.pumpAndSettle();

      expect(find.byType(LibraryItem), findsNothing);

      // Navigate to the Explore screen
      final exploreBtn = find.byWidgetPredicate(
        (w) => w is CoffeeDestination && w.label == 'Explore',
      );
      await tester.tap(exploreBtn);
      await tester.pumpAndSettle();

      // Favorite first image
      await tester.tap(favoriteFinder);
      await tester.pumpAndSettle();

      // Expect favorite button to not be found
      expect(favoriteFinder, findsNothing);

      // Refresh image three times and favorite them all
      final refreshFinder = find.byWidgetPredicate(
        (w) => w is RoundedIconButton && w.icon == Icons.refresh,
      );

      for (var i = 0; i < 4; i++) {
        await tester.tap(refreshFinder);
        await tester.pumpAndSettle();

        await tester.tap(favoriteFinder);
        await tester.pumpAndSettle();
      }

      await tester.pumpAndSettle();

      // Expect favorite button to not be found
      expect(favoriteFinder, findsNothing);

      // Navigate to library
      await tester.tap(libraryBtn);
      await tester.pump();

      // Expect 5 saved images
      expect(find.byType(LibraryItem), findsNWidgets(5));

      // Tap on the first saved image, it is the one
      // that is visible on the ExploreCoffeeCard on the
      // Explore Screen.
      await tester.tap(find.byType(LibraryItem).first);
      await tester.pumpAndSettle();

      // Expect interactive viewer to be visible
      expect(find.byType(InteractiveViewer), findsOneWidget);

      // Unfavorite the image
      await tester.tap(find.text('Unfavorite'));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryItem), findsNWidgets(4));

      // Navigate to Explore screen
      await tester.tap(exploreBtn);
      await tester.pumpAndSettle();

      // Favorite button should now be visible again, since
      // we just removed the image from favorite.
      expect(favoriteFinder, findsOneWidget);
    });
  });
}
