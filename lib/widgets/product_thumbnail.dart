
// lib/widgets/product_thumbnails.dart
import 'package:flutter/material.dart';

class ProductThumbnails extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onThumbnailSelected;

  const ProductThumbnails({
    Key? key,
    required this.images,
    required this.selectedIndex,
    required this.onThumbnailSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onThumbnailSelected(index),
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
              child: Image.network(images[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}