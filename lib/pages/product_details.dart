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
      final productDetail = await _repository.getProductDetail(widget.productId);
      setState(() {
        _productDetail = productDetail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar();
    }
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

  void _handleAddToCart() {
    // Add to cart logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text('Added to cart'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
          textColor: Colors.white,
        ),
      ),
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
              images: _productDetail?.images ?? [],
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
                  images: _productDetail?.images ?? [],
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
          Text(
            _productDetail?.name ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'NPR ${_productDetail?.price}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'NPR ${_productDetail?.originalPrice}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${((_productDetail?.originalPrice ?? 0) - (_productDetail?.price ?? 0)) / (_productDetail?.originalPrice ?? 1) * 100}% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              setState(() => selectedVariant = variant);
            },
          ),
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
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ReviewSection(rating: _productDetail?.rating ?? 0),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleAddToCart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 8),
                  Text('Add to Cart'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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