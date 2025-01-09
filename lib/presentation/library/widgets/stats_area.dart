import 'package:flutter/material.dart';

/// A widget that displays the amount of saved images and the used storage.
///
class StatsArea extends StatelessWidget {
  /// Creates a [StatsArea].
  ///
  const StatsArea({
    required this.amountOfImages,
    required this.bytes,
    super.key,
  });

  /// The amount of saved images.
  ///
  final int amountOfImages;

  /// The amount of used storage in megabytes.
  ///
  final int bytes;

  @override
  Widget build(BuildContext context) {
    final megabytes = (bytes / 1024 / 1024).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Statistic(
            label: 'Saved images',
            value: amountOfImages.toString(),
          ),
          _Statistic(
            label: 'Used storage',
            value: '$megabytes MB',
          ),
        ],
      ),
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
