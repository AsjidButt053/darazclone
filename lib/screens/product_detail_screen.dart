import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

/// Modern Product detail screen with enhanced UI
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          /// App Bar
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: _circleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
            actions: [
              _circleButton(
                iconWidget: Consumer<CartProvider>(
                  builder: (_, cart, __) => Badge(
                    label: Text('${cart.itemCount}'),
                    isLabelVisible: cart.itemCount > 0,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                onTap: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${widget.product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[100]!, Colors.grey[200]!],
                    ),
                  ),
                  // ADD THE HIGH-QUALITY CODE HERE
                  child: widget.product.image.isNotEmpty
                      ? Image.asset(
                    widget.product.image,
                    fit: BoxFit.contain, // Improves pixel quality
                    filterQuality: FilterQuality.high, // Smooths edges
                    errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
                  )
                      : _imagePlaceholder(),
                ),
              ),
            ),
          ),

          /// Product Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryStockRow(),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRatingRow(),
                    const SizedBox(height: 20),
                    _buildPriceBox(),
                    const SizedBox(height: 24),
                    const Text('Quantity',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildQuantitySelector(),
                    const SizedBox(height: 24),
                    const Text('Description',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.local_shipping_outlined,
                            title: 'Free Delivery',
                            subtitle: '2-3 Days',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.verified_user_outlined,
                            title: 'Warranty',
                            subtitle: '1 Year',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Helpers -------------------------------------------------------

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(Icons.shopping_bag, size: 120, color: Colors.grey[400]),
    );
  }

  Widget _circleButton({
    IconData? icon,
    Widget? iconWidget,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: IconButton(
        icon: iconWidget ?? Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCategoryStockRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.product.category,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        Icon(
          widget.product.stock > 0 ? Icons.check_circle : Icons.cancel,
          color: widget.product.stock > 0 ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 6),
        Text(
          widget.product.stock > 0 ? 'In Stock' : 'Out of Stock',
          style: TextStyle(
            color: widget.product.stock > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(
          5,
              (i) => Icon(
            i < 4 ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text('4.0 (128 reviews)', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPriceBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('Price', style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(
            'Rs. ${widget.product.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        _qtyBtn(Icons.remove, () {
          if (_quantity > 1) setState(() => _quantity--);
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$_quantity',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _qtyBtn(Icons.add, () {
          if (_quantity < 10 && _quantity < widget.product.stock) {
            setState(() => _quantity++);
          }
        }),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onTap,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Rs. ${(widget.product.price * _quantity).toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.product.stock > 0
                    ? () {
                  Provider.of<CartProvider>(context, listen: false)
                      .addToCart(widget.product, quantity: _quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                }
                    : null,
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
