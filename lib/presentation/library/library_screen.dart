import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/application/coffee_library_bloc.dart';

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
        builder: (context, state) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...state.map(
                  loading: (_) {
                    return [const CircularProgressIndicator()];
                  },
                  loaded: (state) => state.images.map(Image.file),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
