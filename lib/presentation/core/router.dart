import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee_app/presentation/explore/explore_screen.dart';
import 'package:very_good_coffee_app/presentation/library/library_screen.dart';
import 'package:very_good_coffee_app/presentation/shared/shared.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _exploreNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'key_explore');
final _libraryNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'key_library');

/// The [GoRouter] for the application.
///
GoRouter get appRouter => _router;

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ExploreScreen.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) => NavigationScaffold(
        navigationShell: navigationShell,
        destinations: _rootDestinations,
        onDestinationSelected: navigationShell.goBranch,
      ),
      branches: [
        StatefulShellBranch(
          navigatorKey: _exploreNavigatorKey,
          routes: [
            GoRoute(
              path: ExploreScreen.path,
              builder: (_, __) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _libraryNavigatorKey,
          routes: [
            GoRoute(
              path: LibraryScreen.path,
              builder: (_, __) => const LibraryScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

const _rootDestinations = [
  NavigationDestination(
    icon: Icon(Icons.explore),
    label: 'Explore',
  ),
  NavigationDestination(
    icon: Icon(Icons.favorite),
    label: 'Library',
  ),
];
