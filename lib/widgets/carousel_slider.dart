// lib/widgets/product_images_carousel.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductImagesCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final Function(int) onPageChanged;

  const ProductImagesCarousel({
    Key? key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
          items: images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(url, fit: BoxFit.cover),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == entry.key ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}