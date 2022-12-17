import 'package:flutter/material.dart';

import '../shared/ProfileImg.dart';

class Images extends StatelessWidget {
  final List<String> images;

  const Images({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    switch (images.length) {
      case 1:
        return Container(
          color: Colors.pink,
          height: 300,
          width: 300,
        );
      case 2:
        return TwoImages(images: images);
      case 3:
        return ThreeImages(images: images);
      case 4:
        return Container(
          color: Colors.yellow,
          height: 300,
          width: 300,
        );
      default:
        return Container(
          color: Colors.orange,
          height: 300,
          width: 300,
        );
    }
  }
}

class ThreeImages extends StatelessWidget {
  const ThreeImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300.0,
        maxWidth: 300.0,
        maxHeight: 600.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                    minHeight: 10,
                    maxWidth: 146,
                    minWidth: 146,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      fit: BoxFit.cover,
                      images[1] != "" ? images[1] : defaultImageURL,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                    minHeight: 10,
                    maxWidth: 146,
                    minWidth: 146,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      fit: BoxFit.cover,
                      images[2] != "" ? images[2] : defaultImageURL,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
                maxWidth: 300,
                minHeight: 10,
                minWidth: 300,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Image.network(
                  fit: BoxFit.cover,
                  images[0] != "" ? images[0] : defaultImageURL,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TwoImages extends StatelessWidget {
  const TwoImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300.0,
        maxWidth: 300.0,
        maxHeight: 600.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
                minHeight: 10,
                maxWidth: 146,
                minWidth: 146,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  fit: BoxFit.cover,
                  images[0] != "" ? images[0] : defaultImageURL,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
                minHeight: 10,
                maxWidth: 146,
                minWidth: 146,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
                child: Image.network(
                  fit: BoxFit.cover,
                  images[1] != "" ? images[1] : defaultImageURL,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
