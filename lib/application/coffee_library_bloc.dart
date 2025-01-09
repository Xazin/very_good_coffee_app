import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:very_good_coffee_app/application/startup.dart';
import 'package:very_good_coffee_app/data/coffee_image.dart';
import 'package:very_good_coffee_app/data/storage_repository.dart';

part 'coffee_library_bloc.freezed.dart';

/// The business logic component for the ExploreScreen.
///
class CoffeeLibraryBloc extends Bloc<CoffeeLibraryEvent, CoffeeLibraryState> {
  /// Creates an instance of the ExploreCoffeeBloc.
  ///
  CoffeeLibraryBloc() : super(const CoffeeLibraryState.loading()) {
    on<CoffeeLibraryEvent>((event, emit) async {
      await event.when(
        started: () async {
          _storageRepository.addListener(onImagesChanged);

          final images = await _storageRepository.fetchSavedImages();
          images.sort((a, b) => b.savedAt.compareTo(a.savedAt));
          emit(CoffeeLibraryState.loaded(images));
        },
        imagesChanged: (images) async =>
            emit(CoffeeLibraryState.loaded(images)),
      );
    });
  }

  @override
  Future<void> close() async {
    _storageRepository.removeListener(onImagesChanged);
    await super.close();
  }

  /// Fetches all saved images from the [StorageRepository],
  /// and requests the state to be updated.
  ///
  Future<void> onImagesChanged() async {
    final images = await _storageRepository.fetchSavedImages();
    images.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    add(CoffeeLibraryEvent.imagesChanged(images));
  }

  late final StorageRepository _storageRepository = getIt<StorageRepository>();
}

/// The events that the [CoffeeLibraryBloc] can handle.
///
@freezed
class CoffeeLibraryEvent with _$CoffeeLibraryEvent {
  /// The event that is emitted when the [CoffeeLibraryBloc] is started.
  ///
  const factory CoffeeLibraryEvent.started() = _Started;

  /// The event that is emitted when the images have changed.
  ///
  const factory CoffeeLibraryEvent.imagesChanged(List<CoffeeImage> images) =
      _ImagesChanged;
}

/// The states that the [CoffeeLibraryBloc] can be in.
///
@freezed
class CoffeeLibraryState with _$CoffeeLibraryState {
  /// The initial state of the [CoffeeLibraryBloc].
  ///
  /// This state signifies that the images have not yet been loaded.
  ///
  const factory CoffeeLibraryState.loading() = _Loading;

  /// The state of the [CoffeeLibraryBloc] when the request has finished.
  ///
  const factory CoffeeLibraryState.loaded(List<CoffeeImage> images) = _Loaded;
}
