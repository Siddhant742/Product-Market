//
//
// // lib/widgets/color_variants.dart
// import 'package:flutter/material.dart';
//
// class ColorVariants extends StatelessWidget {
//   final List<String> variants;
//   final String selectedVariant;
//   final Function(String) onVariantSelected;
//
//   const ColorVariants({
//     Key? key,
//     required this.variants,
//     required this.selectedVariant,
//     required this.onVariantSelected,
//   }) : super(key: key);
//
//   Color _getColorFromString(String colorName) {
//     switch (colorName.toLowerCase()) {
//       case 'red': return Colors.red;
//       case 'pink': return Colors.pink;
//       case 'nude': return Color(0xFFDEB887);
//       default: return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       children: variants.map((color) {
//         return GestureDetector(
//           onTap: () => onVariantSelected(color),
//           child: Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _getColorFromString(color),
//               border: Border.all(
//                 color: selectedVariant == color ? Colors.blue : Colors.grey,
//                 width: 2,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ColorVariants extends StatelessWidget {
  final List colorAttributes;
  final String selectedVariant;
  final Function(String) onVariantSelected;

  const ColorVariants({
    Key? key,
    required this.colorAttributes,
    required this.selectedVariant,
    required this.onVariantSelected,
  }) : super(key: key);

  Color _getColorFromHex(String hexColor) {
    final String cleanHex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$cleanHex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: colorAttributes.map((attribute) {
        final colorData = attribute['colorValue'][0] as String;
        final variantId = attribute['_id'] as String;
        final variantName = attribute['name'] as String;

        return Tooltip(
          message: variantName,
          child: GestureDetector(
            onTap: () => onVariantSelected(variantId),
            child: Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getColorFromHex(colorData),
                border: Border.all(
                  color: selectedVariant == variantId ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

