import 'dart:io';

/// A data-class representing a saved Coffee image.
///
class CoffeeImage {
  /// Creates a [CoffeeImage].
  ///
  const CoffeeImage({
    required this.path,
    required this.savedAt,
  });

  /// Creates a [CoffeeImage] from a [FileSystemEntity].
  ///
  /// This helper function extracts the path and last modified date from the
  /// provided [FileSystemEntity].
  ///
  CoffeeImage.fromFileSystemEntity(FileSystemEntity file)
      : this(
          path: file.path,
          savedAt: file.statSync().modified,
        );

  /// The path to the saved image.
  ///
  final String path;

  /// The date and time the image was saved.
  ///
  final DateTime savedAt;

  /// Retrieves the [File] representation of the image.
  ///
  File get file => File(path);
}
