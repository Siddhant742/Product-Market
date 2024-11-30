// import 'package:flutter/material.dart';
//
// import '../utilities/price_utils.dart';
//
// class PriceSection extends StatelessWidget {
//   final double price;
//   final double originalPrice;
//
//   const PriceSection({
//     Key? key,
//     required this.price,
//     required this.originalPrice,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final discount = PriceUtils.calculateDiscount(originalPrice, price);
//
//     return Row(
//       children: [
//         Text(
//           PriceUtils.formatPrice(price),
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           PriceUtils.formatPrice(originalPrice),
//           style: const TextStyle(
//             fontSize: 16,
//             decoration: TextDecoration.lineThrough,
//             color: Colors.grey,
//           ),
//         ),
//         SizedBox(width: 8),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Text(
//             discount,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }