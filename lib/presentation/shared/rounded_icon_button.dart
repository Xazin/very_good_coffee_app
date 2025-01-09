import 'package:flutter/material.dart';

/// A button that displays an icon in a rounded button with a border.
///
/// The button has an [InkWell] effect when tapped.
///
/// The button can be customized with a [color]. If no [color] is provided, the
/// button will be transparent.
///
class RoundedIconButton extends StatelessWidget {
  /// Creates a [RoundedIconButton].
  const RoundedIconButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
    super.key,
  });

  /// The [IconData] to display.
  ///
  final IconData icon;

  /// The callback that is called when the button is tapped.
  ///
  final VoidCallback onTap;

  /// The color of the button.
  ///
  /// If no color is provided, the button will be transparent.
  ///
  final Color? color;

  /// The color of the icon.
  ///
  /// If no color is provided, the button will use default text color.
  ///
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [BoxShadow(offset: Offset(3, 3))],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
