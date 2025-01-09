import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/application/coffee_library_bloc.dart';
import 'package:very_good_coffee_app/presentation/library/widgets/library_item.dart';
import 'package:very_good_coffee_app/presentation/library/widgets/stats_area.dart';

/// A screen that enables the user to view and manage their
/// favorite coffee images.
///
/// The user can freely reorder their favorite images, and
/// remove them if they changed their mind.
///
/// The favorite images are stored locally on the device,
/// allowing them to be accessed even when offline.
///
class LibraryScreen extends StatelessWidget {
  /// Creates an [LibraryScreen].
  ///
  const LibraryScreen({super.key});

  /// The route name for the [LibraryScreen].
  ///
  /// Use this route name to navigate to the [LibraryScreen].
  ///
  static String path = '/library';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoffeeLibraryBloc>(
      create: (_) =>
          CoffeeLibraryBloc()..add(const CoffeeLibraryEvent.started()),
      child: BlocBuilder<CoffeeLibraryBloc, CoffeeLibraryState>(
        builder: (context, state) => SafeArea(
          child: state.map(
            loading: (_) => const CircularProgressIndicator(),
            loaded: (state) {
              final bytes = state.images.fold<int>(0, (a, b) => a + b.size);
              return Column(
                children: [
                  StatsArea(
                    amountOfImages: state.images.length,
                    bytes: bytes,
                  ),
                  if (state.images.isEmpty) ...[
                    const SizedBox(height: 64),
                    const Text(
                      'You have not saved any favorite coffee images yet!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                  Flexible(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        for (int i = 0; i < state.images.length; i++)
                          LibraryItem(coffeeImage: state.images[i], index: i),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
