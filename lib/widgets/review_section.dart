

// lib/widgets/review_section.dart
import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  final double rating;

  const ReviewSection({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating & Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(
              5,
                  (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
            ),
            SizedBox(width: 8),
            Text('$rating/5'),
          ],
        ),
      ],
    );
  }
}