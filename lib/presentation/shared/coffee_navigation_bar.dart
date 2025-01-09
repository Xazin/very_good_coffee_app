import 'package:flutter/material.dart';

/// A destination in the [CoffeeNavigationBar].
///
class CoffeeDestination extends StatelessWidget {
  /// Creates a [CoffeeDestination].
  ///
  const CoffeeDestination({required this.icon, required this.label, super.key});

  /// The icon to display for the destination.
  ///
  final Icon icon;

  /// The label associated with the destination.
  ///
  /// This label is not displayed, but is used for accessibility purposes.
  ///
  final String label;

  @override
  Widget build(BuildContext context) {
    final parent = _CoffeeDestinationParent.of(context);

    const selectedState = <WidgetState>{WidgetState.selected};
    const unselectedState = <WidgetState>{};
    final iconTheme = _getIconTheme();
    final selectedIconTheme =
        iconTheme?.resolve(selectedState) ?? iconTheme!.resolve(selectedState)!;
    final unselectedIconTheme = iconTheme?.resolve(unselectedState) ??
        iconTheme!.resolve(unselectedState)!;

    return Material(
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: parent.onPressed,
        child: Tooltip(
          message: label,
          preferBelow: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: parent.isSelected
                    ? const [
                        BoxShadow(
                          color: Colors.black12,
                        ),
                      ]
                    : null,
              ),
              child: IconTheme.merge(
                data:
                    parent.isSelected ? selectedIconTheme : unselectedIconTheme,
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the [IconThemeData] for the [CoffeeDestination].
  ///
  WidgetStateProperty<IconThemeData?>? _getIconTheme() {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return IconThemeData(
        size: 24,
        color: states.contains(WidgetState.selected)
            ? Colors.brown
            : Colors.black.withAlpha(200),
      );
    });
  }
}

/// A [BottomNavigationBar] that displays the provided destinations.
///
/// The selected destination is highlighted.
///
class CoffeeNavigationBar extends StatelessWidget {
  /// Creates a [CoffeeNavigationBar].
  ///
  const CoffeeNavigationBar({
    required this.destinations,
    this.onDestinationSelected,
    this.selectedIndex = 0,
    super.key,
  });

  /// The destinations to display in the [CoffeeNavigationBar].
  ///
  final List<CoffeeDestination> destinations;

  /// The callback that is called when a destination is selected.
  ///
  final ValueChanged<int>? onDestinationSelected;

  /// The index of the selected destination.
  ///
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final navigationBarTheme = NavigationBarTheme.of(context);

    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          child: Container(
            // 80.0 is the default height of the BottomNavigationBar in
            // Material 3 Specifications.
            height: navigationBarTheme.height ?? 80,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < destinations.length; i++)
                  _CoffeeDestinationParent(
                    index: i,
                    onPressed: () => onDestinationSelected?.call(i),
                    isSelected: i == selectedIndex,
                    child: destinations[i],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoffeeDestinationParent extends InheritedWidget {
  const _CoffeeDestinationParent({
    required this.index,
    required this.onPressed,
    required this.isSelected,
    required super.child,
  });

  final int index;
  final VoidCallback onPressed;
  final bool isSelected;

  static _CoffeeDestinationParent of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_CoffeeDestinationParent>();
    assert(
      result != null,
      'Navigation destinations require a _CoffeeDestinationParent parent.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(_CoffeeDestinationParent oldWidget) {
    return index != oldWidget.index ||
        isSelected != oldWidget.isSelected ||
        onPressed != oldWidget.onPressed;
  }
}
