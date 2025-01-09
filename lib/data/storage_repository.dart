import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:very_good_coffee_app/data/coffee_image.dart';

/// A repository that manages the storage of favorited Coffee images
/// on the device.
///
/// This reposiory is listenable, and will notify listeners when an
/// image is saved or removed.
///
class StorageRepository extends ChangeNotifier {
  /// Creates a [StorageRepository].
  ///
  StorageRepository() {
    fetchDocumentsDirectory();
  }

  static const String _imageDirectory = 'images';

  final Completer<void> _initialized = Completer<void>();
  late final Directory _documentsDirectory;

  /// Saves an image to the device.
  ///
  /// The image is saved to the application's documents directory.
  ///
  Future<void> saveImage(String imageUrl) async {
    await _initialized.future;

    final uri = Uri.parse(imageUrl);
    final response = await http.get(uri);

    // The image url comes from the Coffee API, it is safe to assume that the
    // final path segment will be unique, and thus safe to use as a filename.
    final imageFile = File(
      '${_documentsDirectory.path}/$_imageDirectory/${uri.pathSegments.last}',
    );
    await imageFile.writeAsBytes(response.bodyBytes);

    notifyListeners();
  }

  /// Removes an image from the device.
  ///
  Future<void> removeImage(String imageUrl) async {
    await _initialized.future;

    final uri = Uri.parse(imageUrl);
    final imageFile = File(
      '${_documentsDirectory.path}/$_imageDirectory/${uri.pathSegments.last}',
    );
    await imageFile.delete();

    notifyListeners();
  }

  /// Fetches the saved images from the device.
  ///
  /// Returns a list of [CoffeeImage] objects representing the saved images.
  ///
  Future<List<CoffeeImage>> fetchSavedImages() async {
    await _initialized.future;

    final files =
        Directory('${_documentsDirectory.path}/$_imageDirectory').listSync();

    // Map each FileSystemEntity to a CoffeeImage.
    return files.map(CoffeeImage.fromFileSystemEntity).toList();
  }

  /// Attempts to fetch an image from the device.
  ///
  /// If the image does not exist, null is returned.
  ///
  Future<CoffeeImage?> getImage(String image) async {
    await _initialized.future;

    final file = File('${_documentsDirectory.path}/$_imageDirectory/$image');
    if (file.existsSync()) {
      return CoffeeImage.fromFileSystemEntity(file);
    }

    return null;
  }

  /// Fetches the documents directory of the device.
  ///
  /// When completed, the [_documentsDirectory] will be set.
  ///
  Future<void> fetchDocumentsDirectory() async {
    _documentsDirectory = await getApplicationDocumentsDirectory();
    imagesDirectoryExists();
    _initialized.complete();
  }

  /// Ensures that the images directory exists.
  ///
  /// If the directory does not exist, it will be created.
  ///
  void imagesDirectoryExists() {
    final imagesDirectory =
        Directory('${_documentsDirectory.path}/$_imageDirectory');
    if (!imagesDirectory.existsSync()) {
      imagesDirectory.createSync();
    }
  }
}
