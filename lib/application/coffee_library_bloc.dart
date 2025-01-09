import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
          final images = await _storageRepository.fetchSavedImages();
          emit(CoffeeLibraryState.loaded(images));
        },
      );
    });
  }

  late final StorageRepository _storageRepository = StorageRepository();
}

/// The events that the [CoffeeLibraryBloc] can handle.
///
@freezed
class CoffeeLibraryEvent with _$CoffeeLibraryEvent {
  /// The event that is emitted when the [CoffeeLibraryBloc] is started.
  ///
  const factory CoffeeLibraryEvent.started() = _Started;
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
  const factory CoffeeLibraryState.loaded(List<File> images) = _Loaded;
}
