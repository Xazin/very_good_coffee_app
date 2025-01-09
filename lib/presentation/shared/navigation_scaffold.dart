import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A scaffold that builds a [BottomNavigationBar] with the provided items.
///
class NavigationScaffold extends StatelessWidget {
  /// Creates a [NavigationScaffold].
  ///
  const NavigationScaffold({
    required this.navigationShell,
    required this.destinations,
    required this.onDestinationSelected,
    super.key,
  });

  /// The [StatefulNavigationShell] that manages the
  /// current content.
  ///
  final StatefulNavigationShell navigationShell;

  /// The destinations to display in the [BottomNavigationBar].
  ///
  final List<NavigationDestination> destinations;

  /// The callback that is called when a destination is selected.
  ///
  /// The callback is passed the index of the selected destination.
  ///
  final void Function(int) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destinations[navigationShell.currentIndex].label),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
