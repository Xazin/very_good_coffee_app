import 'package:flutter/material.dart';

/// A card that displays a Coffee image from a Network URL.
///
class ExploreCoffeeCard extends StatelessWidget {
  /// Creates an [ExploreCoffeeCard].
  const ExploreCoffeeCard({required this.imageUrl, super.key});

  /// The URL of the image to display.
  ///
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        height: 375,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
