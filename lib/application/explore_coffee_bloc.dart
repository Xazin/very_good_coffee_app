import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_coffee_app/data/coffee_repository.dart';
import 'package:very_good_coffee_app/data/storage_repository.dart';

part 'explore_coffee_bloc.freezed.dart';

/// The business logic component for the ExploreScreen.
///
class ExploreCoffeeBloc extends Bloc<ExploreCoffeeEvent, ExploreCoffeeState> {
  /// Creates an instance of the ExploreCoffeeBloc.
  ///
  ExploreCoffeeBloc() : super(const ExploreCoffeeState.loading()) {
    on<ExploreCoffeeEvent>((event, emit) async {
      await event.when(
        started: () async {
          emit(await _refresh());
        },
        refresh: () async {
          emit(await _refresh());
        },
        favoriteCurrent: () async {
          await state.maybeWhen(
            loaded: (imageUrl, isFavorited) async {
              if (!isFavorited) {
                await _storageRepository.saveImage(imageUrl);
                emit(ExploreCoffeeState.loaded(imageUrl, isFavorited: true));
              }
            },
            orElse: () {},
          );
        },
      );
    });
  }

  /// Fetches a random coffee image from the [CoffeeRepository], and
  /// maps the result to the appropriate [ExploreCoffeeState].
  ///
  Future<ExploreCoffeeState> _refresh() async {
    final coffeeOrFailure = await _coffeeRepository.getRandomCoffeeImage();
    return coffeeOrFailure.fold(
      ExploreCoffeeState.failure,
      ExploreCoffeeState.loaded,
    );
  }

  late final CoffeeRepository _coffeeRepository = CoffeeRepository();
  late final StorageRepository _storageRepository = StorageRepository();
}

/// The events that the [ExploreCoffeeBloc] can handle.
///
@freezed
class ExploreCoffeeEvent with _$ExploreCoffeeEvent {
  /// The event that is emitted when the [ExploreCoffeeBloc] is started.
  ///
  const factory ExploreCoffeeEvent.started() = _Started;

  /// The event that is emitted when the image should be refreshed.
  ///
  const factory ExploreCoffeeEvent.refresh() = _Refresh;

  /// The event that is emitted when the current image should be favorited.
  ///
  const factory ExploreCoffeeEvent.favoriteCurrent() = _FavoriteCurrent;
}

/// The states that the [ExploreCoffeeBloc] can be in.
///
@freezed
class ExploreCoffeeState with _$ExploreCoffeeState {
  /// The initial state of the [ExploreCoffeeBloc].
  ///
  /// This state signifies that a request has not yet finished.
  ///
  const factory ExploreCoffeeState.loading() = _Loading;

  /// The state of the [ExploreCoffeeBloc] when the request has finished.
  ///
  const factory ExploreCoffeeState.loaded(
    String imageUrl, {
    @Default(false) bool isFavorited,
  }) = _Loaded;

  /// The state of the [ExploreCoffeeBloc] when an error occurs during
  /// the request.
  ///
  /// The [CoffeeFailure] implicitly provides the reason for the error.
  ///
  const factory ExploreCoffeeState.failure(CoffeeFailure failure) = _Failure;
}
