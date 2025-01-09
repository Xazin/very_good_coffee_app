import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/application/coffee_library_bloc.dart';
import 'package:very_good_coffee_app/data/coffee_image.dart';

/// Renders a [CoffeeImage]
///
class LibraryItem extends StatelessWidget {
  /// Creates a [CoffeeImage].
  ///
  const LibraryItem({
    required this.coffeeImage,
    required this.index,
    super.key,
  });

  /// The [CoffeeImage] to render.
  ///
  final CoffeeImage coffeeImage;

  /// The index of the [CoffeeImage],
  /// used to perform action(s) such as unfavoriting the item.
  ///
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInteractiveViewer(context),
      child: Image.file(
        coffeeImage.file,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _showInteractiveViewer(BuildContext context) async => showDialog(
        context: context,
        builder: (dialogContext) {
          final size = MediaQuery.of(dialogContext).size;
          return Stack(
            fit: StackFit.expand,
            children: [
              SizedBox.expand(
                child: InteractiveViewer(
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Image.file(coffeeImage.file),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: BlocProvider.value(
                  value: context.read<CoffeeLibraryBloc>(),
                  child: _LibraryItemToolbar(index: index),
                ),
              ),
            ],
          );
        },
      );
}

class _LibraryItemToolbar extends StatelessWidget {
  const _LibraryItemToolbar({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context
                .read<CoffeeLibraryBloc>()
                .add(CoffeeLibraryEvent.unfavorite(index));
            Navigator.of(context).pop();
          },
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(),
            ),
            child: const Center(child: Text('Unfavorite')),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(),
            ),
            child: const Center(child: Icon(Icons.close)),
          ),
        ),
      ],
    );
  }
}
