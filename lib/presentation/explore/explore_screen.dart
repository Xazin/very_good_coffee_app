import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/application/explore_coffee_bloc.dart';
import 'package:very_good_coffee_app/data/coffee_repository.dart';
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
        builder: (_, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.map(
                  loading: (_) => const CircularProgressIndicator(),
                  loaded: (state) => ExploreCoffeeCard(
                    imageUrl: state.imageUrl,
                  ),
                  failure: (state) => _ErrorText(failure: state.failure),
                ),
                const _ImageActions(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImageActions extends StatelessWidget {
  const _ImageActions();

  @override
  Widget build(BuildContext context) {
    final isFavorited = context.watch<ExploreCoffeeBloc>().state.maybeWhen(
          loaded: (_, isFavorited) => isFavorited,
          orElse: () => false,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconButton(
          onTap: () => context
              .read<ExploreCoffeeBloc>()
              .add(const ExploreCoffeeEvent.refresh()),
          icon: Icons.refresh,
        ),
        const SizedBox(width: 16),
        RoundedIconButton(
          onTap: () => context
              .read<ExploreCoffeeBloc>()
              .add(const ExploreCoffeeEvent.toggleFavorite()),
          color: isFavorited ? Colors.grey : Colors.red,
          iconColor: Colors.white,
          icon: isFavorited ? Icons.delete_rounded : Icons.favorite,
        ),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.failure});

  final CoffeeFailure failure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        switch (failure) {
          CoffeeFailure.serverError => 'The request failed, please try again.',
          _ => 'Something went wrong, please try again.',
        },
        textAlign: TextAlign.center,
      ),
    );
  }
}
