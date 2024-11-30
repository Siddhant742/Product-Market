// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../data/models/product_detail_model.dart';
// import '../data/repositories/product_detail_repository.dart';
// import '../data/services/product_detail_service.dart';
// import '../widgets/carousel_slider.dart';
// import '../widgets/color_variants.dart';
// import '../widgets/message_bottom_sheet.dart';
// import '../widgets/product_tabs.dart';
// import '../widgets/product_thumbnail.dart';
// import '../widgets/review_section.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   final String productId;
//
//   const ProductDetailScreen({
//     Key? key,
//     required this.productId,
//   }) : super(key: key);
//
//   @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen>
//     with SingleTickerProviderStateMixin {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   final ProductRepository _repository = ProductRepository(ProductService());
//
//   late TabController _tabController;
//   ProductDetail? _productDetail;
//   bool _isLoading = true;
//   bool isMessageBoxVisible = false;
//   String selectedVariant = '';
//   int currentImageIndex = 0;
//   TextEditingController messageController = TextEditingController();
//   bool _isFavorite = false;
//   final ScrollController _scrollController = ScrollController();
//
//   // New variables for quantity management
//   int _quantity = 1;
//   int _maxQuantity = 10; // Maximum quantity that can be added to cart
//
//   // Variant details tracking
//   int currentPrice = 0;
//   int currentStrikePrice = 0;
//   int currentOffPercent = 0;
//   String currentProductCode = '';
//   List<String> currentImages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _initializeNotifications();
//     _loadProductDetails();
//   }
//
//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _loadProductDetails() async {
//     try {
//       debugPrint('Loading product details for ID: ${widget.productId}');
//       final productDetail = await _repository.getProductDetail(widget.productId);
//
//       setState(() {
//         _productDetail = productDetail;
//         _isLoading = false;
//
//         // Debug print of product details
//         debugPrint('Product loaded: ${productDetail.title}');
//         debugPrint('Total color variants: ${productDetail.colorVariants.length}');
//
//         // Initialize with the first color variant
//         if (productDetail.colorVariants.isNotEmpty) {
//           _updateSelectedVariant(productDetail.colorVariants.first);
//         }
//       });
//     } catch (e) {
//       debugPrint('Error loading product details: $e');
//       setState(() => _isLoading = false);
//       _showErrorSnackBar();
//     }
//   }
//
//   void _updateSelectedVariant(dynamic variantData) {
//     try {
//       setState(() {
//         // Safely access color name with null checks
//         selectedVariant = variantData['color']?['name'] ?? '';
//
//         // Safely access price and other details with null checks and default values
//         currentPrice = variantData['price'] ?? 0;
//         currentStrikePrice = variantData['strikePrice'] ?? 0;
//         currentOffPercent = variantData['offPercent'] ?? 0;
//         currentProductCode = variantData['productCode'] ?? '';
//
//         // Determine max quantity for this variant
//         _maxQuantity = variantData['maxOrder'] ?? 10;
//
//         // Reset quantity to 1 when variant changes
//         _quantity = 1;
//
//         // Fallback to product images if variant images are empty
//         currentImages = variantData['images'] != null && variantData['images'].isNotEmpty
//             ? List<String>.from(variantData['images'])
//             : _productDetail?.images ?? [];
//
//         // Debug print of variant selection
//         debugPrint('Selected Variant: $selectedVariant');
//         debugPrint('Current Price: $currentPrice');
//         debugPrint('Max Quantity: $_maxQuantity');
//       });
//     } catch (e) {
//       debugPrint('Error updating variant: $e');
//     }
//   }
//
//   void _incrementQuantity() {
//     setState(() {
//       if (_quantity < _maxQuantity) {
//         _quantity++;
//         debugPrint('Quantity increased to $_quantity');
//       } else {
//         // Show a snackbar if max quantity is reached
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Maximum quantity of $_maxQuantity reached'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     });
//   }
//
//   void _decrementQuantity() {
//     setState(() {
//       if (_quantity > 1) {
//         _quantity--;
//         debugPrint('Quantity decreased to $_quantity');
//       }
//     });
//   }
//
//   void _handleAddToCart() {
//     // Calculate total price for the selected quantity
//     int totalPrice = currentPrice * _quantity;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.shopping_cart, color: Colors.white),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'Added $_quantity ${selectedVariant} - Total: NPR $totalPrice',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//         behavior: SnackBarBehavior.floating,
//         action: SnackBarAction(
//           label: 'View Cart',
//           onPressed: () {
//             // Navigate to cart
//             debugPrint('Navigating to cart');
//           },
//           textColor: Colors.white,
//         ),
//       ),
//     );
//
//     // Additional debug information
//     debugPrint('Added to Cart:');
//     debugPrint('Variant: $selectedVariant');
//     debugPrint('Quantity: $_quantity');
//     debugPrint('Unit Price: $currentPrice');
//     debugPrint('Total Price: $totalPrice');
//   }
//
//   // Rest of the previous code remains the same...
//
//   Widget _buildQuantitySelector() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Text(
//             'Quantity',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           Spacer(),
//           IconButton(
//             icon: Icon(Icons.remove_circle_outline),
//             onPressed: _decrementQuantity,
//           ),
//           Text(
//             '$_quantity',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.add_circle_outline),
//             onPressed: _incrementQuantity,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Existing build method remains the same, but modify the action buttons section
//     // Replace _buildActionButtons() with this updated version:
//     Widget _buildActionButtons() {
//       return Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildQuantitySelector(), // Add this new quantity selector
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: _handleAddToCart,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.shopping_cart),
//                         SizedBox(width: 8),
//                         Text('Add $quantity to Cart'),
//                       ],
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: _showMessageBottomSheet,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.message),
//                         SizedBox(width: 8),
//                         Text('Message'),
//                       ],
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     }
//
//     // Rest of the build method remains the same...
//   }
//
// // Existing dispose method remains the same
// }