import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/application/explore_coffee_bloc.dart';
import 'package:very_good_coffee_app/presentation/explore/widgets/explore_coffee_card.dart';
import 'package:very_good_coffee_app/presentation/shared/shared.dart';

/// A screen that enables the user to quickly swipe through random
/// coffee images.
///
/// If the user swipes right, the image is saved to their favorites.
///
class ExploreScreen extends StatelessWidget {
  /// Creates an [ExploreScreen].
  ///
  const ExploreScreen({super.key});

  /// The route name for the [ExploreScreen].
  ///
  /// Use this route name to navigate to the [ExploreScreen].
  ///
  static String path = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExploreCoffeeBloc>(
      create: (_) =>
          ExploreCoffeeBloc()..add(const ExploreCoffeeEvent.started()),
      child: BlocBuilder<ExploreCoffeeBloc, ExploreCoffeeState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.map(
                  loading: (_) => const CircularProgressIndicator(),
                  loaded: (state) => ExploreCoffeeCard(
                    imageUrl: state.imageUrl,
                  ),
                  failure: (_) => const Text('Failed to load coffee image!'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedIconButton(
                      onTap: () {
                        context
                            .read<ExploreCoffeeBloc>()
                            .add(const ExploreCoffeeEvent.refresh());
                      },
                      icon: Icons.refresh,
                    ),
                    const SizedBox(width: 16),
                    RoundedIconButton(
                      onTap: () {
                        context
                            .read<ExploreCoffeeBloc>()
                            .add(const ExploreCoffeeEvent.favoriteCurrent());
                      },
                      color: Colors.red,
                      iconColor: Colors.white,
                      icon: Icons.favorite,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
