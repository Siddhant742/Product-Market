import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/models/product_detail_model.dart';
import '../data/repositories/product_detail_repository.dart';
import '../data/services/product detail service.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/color_variants.dart';
import '../widgets/message_bottom_sheet.dart';
import '../widgets/product_tabs.dart';
import '../widgets/product_thumbnail.dart';
import '../widgets/review_section.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final ProductRepository _repository = ProductRepository(ProductService());

  late TabController _tabController;
  ProductDetail? _productDetail;
  bool _isLoading = true;
  bool isMessageBoxVisible = false;
  String selectedVariant = '';
  int currentImageIndex = 0;
  TextEditingController messageController = TextEditingController();
  bool _isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  int _quantity = 1;
  int _maxQuantity = 1000;

  // New variables to track selected variant details
  int currentPrice = 0;
  int currentStrikePrice = 0;
  int currentOffPercent = 0;
  String currentProductCode = '';
  List<String> currentImages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeNotifications();
    _loadProductDetails();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadProductDetails() async {
    try {
      debugPrint('Loading product details for ID: ${widget.productId}');
      final productDetail = await _repository.getProductDetail(widget.productId);

      setState(() {
        _productDetail = productDetail;
        _isLoading = false;

        // Debug print of product details
        debugPrint('Product loaded: ${productDetail.title}');
        debugPrint('Total color variants: ${productDetail.colorAttributes.length}');

        // Initialize with the first color variant
        if (productDetail.colorAttributes.isNotEmpty) {
          _updateSelectedVariant(productDetail.colorAttributes.first);
        }
      });
    } catch (e) {
      debugPrint('Error loading product details: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar();
    }
  }

  void _updateSelectedVariant(dynamic variantData) {
    try {
      setState(() {
        // Safely access color name with null checks
        selectedVariant = variantData['color']?['name'] ?? '';

        // Safely access price and other details with null checks and default values
        currentPrice = variantData['price'] ?? 0;
        currentStrikePrice = variantData['strikePrice'] ?? 0;
        currentOffPercent = variantData['offPercent'] ?? 0;
        currentProductCode = variantData['productCode'] ?? '';

        // Determine max quantity for this variant
        _maxQuantity = variantData['maxOrder'] ?? 10;

        // Reset quantity to 1 when variant changes
        _quantity = 1;

        // Fallback to product images if variant images are empty
        currentImages = variantData['images'] != null && variantData['images'].isNotEmpty
            ? List<String>.from(variantData['images'])
            : _productDetail?.images ?? [];

        // Debug print of variant selection
        debugPrint('Selected Variant: $selectedVariant');
        debugPrint('Current Price: $currentPrice');
        debugPrint('Max Quantity: $_maxQuantity');
      });
    } catch (e) {
      debugPrint('Error updating variant: $e');
    }
  }

  void _incrementQuantity() {
    setState(() {
      if (_quantity < _maxQuantity) {
        _quantity++;
        debugPrint('Quantity increased to $_quantity');
      } else {
        // Show a snackbar if max quantity is reached
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum quantity of $_maxQuantity reached'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        debugPrint('Quantity decreased to $_quantity');
      }
    });
  }

  void _handleAddToCart() {
    // Calculate total price for the selected quantity
    int totalPrice = currentPrice * _quantity;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added $_quantity ${selectedVariant} - Total: NPR $totalPrice',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
            debugPrint('Navigating to cart');
          },
          textColor: Colors.white,
        ),
      ),
    );

    // Additional debug information
    debugPrint('Added to Cart:');
    debugPrint('Variant: $selectedVariant');
    debugPrint('Quantity: $_quantity');
    debugPrint('Unit Price: $currentPrice');
    debugPrint('Total Price: $totalPrice');
  }

  void _showMessageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageBottomSheet(
        onSend: () {
          _showNotification();
          Navigator.pop(context);
          messageController.clear();
        },
        messageController: messageController,
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Failed to load product details'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadProductDetails,
          textColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'message_channel',
      'Message Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Message Sent',
      'Thank you for contacting us',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              SizedBox(height: 16),
              Text(
                'Loading product details...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(),
                _buildColorVariants(),
                _buildProductTabs(),
                _buildReviewSection(),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            ProductImagesCarousel(
              images: currentImages,
              currentIndex: currentImageIndex,
              onPageChanged: (index) {
                setState(() => currentImageIndex = index);
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                child: ProductThumbnails(
                  images: currentImages,
                  selectedIndex: currentImageIndex,
                  onThumbnailSelected: (index) {
                    setState(() => currentImageIndex = index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: child,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(_isFavorite),
              color: _isFavorite ? Colors.red : null,
            ),
          ),
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {/* Implement share functionality */},
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title remains the same
          Text(
            _productDetail?.title ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Dynamic current price
              Text(
                'NPR $currentPrice',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              // Dynamic strike price
              Text(
                'NPR $currentStrikePrice',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              // Dynamic off percentage
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$currentOffPercent% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Dynamic product code with selected variant color name
          Text(
            'Product Code: $currentProductCode (${selectedVariant})',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Optional: Add color swatch if available
          if (_productDetail?.colorAttributes != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    'Color: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _getColorFromVariant(),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    selectedVariant,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

// Helper method to convert color name to Color object
  Color _getColorFromVariant() {
    // Find the current variant's color value
    final variant = _productDetail?.colorVariants.firstWhere(
          (v) => v['color']?['name'] == selectedVariant,
      orElse: () => null,
    );

    if (variant != null && variant['color']?['colorValue'] != null) {
      try {
        // Convert color value (assuming it's in the format [#a43127])
        String colorHex = variant['color']['colorValue'][0].toString().replaceAll('[', '').replaceAll(']', '');
        return Color(int.parse(colorHex.replaceFirst('#', ''), radix: 16) + 0xFF000000);
      } catch (e) {
        debugPrint('Error parsing color: $e');
      }
    }

    // Fallback to a default color
    return Colors.grey.shade500;
  }

  Widget _buildColorVariants() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color Variants',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ColorVariants(
            colorAttributes: _productDetail?.colorAttributes ?? [],
            selectedVariant: selectedVariant,
            onVariantSelected: (variant) {
              // Log variant name
              debugPrint('Variant selected: $variant');

              // Find the full variant data
              final fullVariant = _productDetail?.colorVariants.firstWhere(
                    (v) => v['color']?['_id'] == variant,
                orElse: () {
                  debugPrint('No matching variant found for: $variant');
                  return null;
                },
              );

              if (fullVariant != null) {
                // Log full variant details
                debugPrint('Full Variant Data: $fullVariant');
                _updateSelectedVariant(fullVariant);
              }
            },
          ),
          SizedBox(height: 12,),
          _buildQuantitySelector(),
        ],
      ),
    );
  }


  Widget _buildProductTabs() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ProductTabs(
        tabController: _tabController,
        description: _productDetail?.description ?? '',
        ingredients: _productDetail?.ingredients ?? '',
        howToUse: _productDetail?.howToUse ?? '',
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          ReviewSection(rating: _productDetail?.rating ?? 0),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: _decrementQuantity,
          ),
          Text(
            '$_quantity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: _incrementQuantity,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _handleAddToCart,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart),
                      SizedBox(width: 8),
                      Text('Add to Cart'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _showMessageBottomSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.message),
                      SizedBox(width: 8),
                      Text('Message'),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}