import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/data/coffee_image.dart';
import 'package:very_good_coffee_app/data/storage_repository.dart';

class MockStorageRepository implements IStorageRepository {
  MockStorageRepository() : _savedImages = [];

  final List<CoffeeImage> _savedImages;

  final String _directory = 'images/';

  @override
  Future<List<CoffeeImage>> fetchSavedImages() async {
    return _savedImages;
  }

  @override
  Future<CoffeeImage?> getImage(String image) async {
    for (var i = 0; i < _savedImages.length; i++) {
      if (_savedImages[i].file.uri.pathSegments.last == image) {
        return _savedImages[i];
      }
    }

    return null;
  }

  @override
  Future<void> removeFile(String path) async {
    _savedImages.removeWhere((i) => i.path == path);
  }

  @override
  Future<void> removeImage(String imageUrl) async {
    _savedImages.removeWhere((i) => i.file.uri.pathSegments.last == imageUrl);
  }

  @override
  Future<void> saveImage(String imageUrl) async {
    _savedImages.add(
      CoffeeImage(path: '$_directory$imageUrl', savedAt: DateTime.now()),
    );
  }
}

void main() {
  late final IStorageRepository storageRepository;

  setUp(() {
    storageRepository = MockStorageRepository();
  });

  group('StorageRepository tests', () {
    test('Save and remove by image name/url', () async {
      var savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 0);

      const imageOne = 'abc.png';
      await storageRepository.saveImage(imageOne);

      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 1);

      const imageTwo = 'cba.png';
      await storageRepository.saveImage(imageTwo);

      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 2);

      await storageRepository.removeImage(imageOne);
      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 1);

      await storageRepository.removeImage(imageTwo);
      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 0);
    });

    test('Save, get and remove by file path', () async {
      var savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 0);

      const imageOne = 'abc.png';
      await storageRepository.saveImage(imageOne);

      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 1);

      final image = await storageRepository.getImage(imageOne);
      expect(image, isNotNull);

      await storageRepository.removeFile(image!.path);
      savedImages = await storageRepository.fetchSavedImages();
      expect(savedImages.length, 0);
    });
  });
}
