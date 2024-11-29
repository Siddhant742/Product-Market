// lib/utils/color_utils.dart
import 'package:flutter/material.dart';

class ColorUtils {
  static Color getColorFromString(String colorName) {
    final Map<String, Color> colorMap = {
      'red': Colors.red,
      'pink': Colors.pink,
      'nude': Color(0xFFDEB887),
      'brown': Colors.brown,
      'orange': Colors.orange,
      'coral': Colors.deepOrange,
      'maroon': Color(0xFF800000),
    };

    return colorMap[colorName.toLowerCase()] ?? Colors.grey;
  }
}