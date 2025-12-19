import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

/// Admin panel screen for managing products and viewing live orders
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _isLoggedIn = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return _buildLoginScreen();
    }

    // ✅ Using DefaultTabController to switch between Products and Orders
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Products'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Live Orders'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                setState(() => _isLoggedIn = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildProductManagementTab(),
            _buildLiveOrdersTab(), // ✅ New Live Orders Tab
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Only show FAB when the "Products" tab is active
            final tabController = DefaultTabController.of(context);
            return AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                return tabController.index == 0
                    ? FloatingActionButton.extended(
                  onPressed: () => _showAddEditProductDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                )
                    : const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  /// ✅ TAB 1: Product Management (Your original logic)
  Widget _buildProductManagementTab() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          children: [
            _buildStatsCard(productProvider),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: productProvider.allProducts.length,
                itemBuilder: (context, index) {
                  final product = productProvider.allProducts[index];
                  return _buildProductCard(product, productProvider);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// ✅ TAB 2: Live Orders from Firebase
  Widget _buildLiveOrdersTab() {
    return StreamBuilder<QuerySnapshot>(
      // Listen to the "orders" collection in real-time
      stream: FirebaseFirestore.instance
          .collection('orders')
          .orderBy('orderDate', descending: true) // Newest orders first
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No orders found yet.'));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = orders[index].data() as Map<String, dynamic>;
            final timestamp = orderData['orderDate'] as Timestamp?;
            final dateString = timestamp != null
                ? DateFormat('MMM d, h:mm a').format(timestamp.toDate())
                : 'Just now';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  orderData['customerName'] ?? 'Unknown Customer',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: Rs. ${orderData['totalAmount']} | Items: ${orderData['itemCount']}'),
                    Text(dateString, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }

  // --- Login Screen ---
  Widget _buildLoginScreen() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings, size: 80, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 24),
                  const Text('Admin Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (usernameController.text == 'admin' && passwordController.text == '1234') {
                          setState(() => _isLoggedIn = true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials'), backgroundColor: Colors.red));
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Stats Card ---
  Widget _buildStatsCard(ProductProvider productProvider) {
    final totalProducts = productProvider.allProducts.length;
    final categories = productProvider.categories.length - 1;
    final totalStock = productProvider.allProducts.fold<int>(0, (sum, product) => sum + product.stock);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(icon: Icons.inventory, label: 'Products', value: '$totalProducts', color: Colors.blue),
            _buildStatItem(icon: Icons.category, label: 'Categories', value: '$categories', color: Colors.orange),
            _buildStatItem(icon: Icons.storage, label: 'Stock', value: '$totalStock', color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label, required String value, required Color color}) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // --- Product List Card ---
  Widget _buildProductCard(Product product, ProductProvider productProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (product.image.isNotEmpty && !product.image.startsWith('assets/'))
                ? Image.file(File(product.image), fit: BoxFit.cover)
                : const Icon(Icons.shopping_bag, color: Colors.grey),
          ),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Rs. ${product.price.toStringAsFixed(0)} • Stock: ${product.stock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditProductDialog(context, product: product)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _showDeleteConfirmation(context, product, productProvider)),
          ],
        ),
      ),
    );
  }

  // --- Add/Edit Dialog ---
  void _showAddEditProductDialog(BuildContext context, {Product? product}) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?.name);
    final priceController = TextEditingController(text: product?.price.toString());
    final categoryController = TextEditingController(text: product?.category);
    final descriptionController = TextEditingController(text: product?.description);
    final stockController = TextEditingController(text: product?.stock.toString());
    String? selectedImagePath = product?.image;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity, height: 150,
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: (selectedImagePath != null && selectedImagePath!.isNotEmpty && !selectedImagePath!.startsWith('assets/'))
                      ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(selectedImagePath!), fit: BoxFit.cover))
                      : const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
                Row(
                  children: [
                    Expanded(child: TextButton.icon(onPressed: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) setDialogState(() => selectedImagePath = image.path);
                    }, icon: const Icon(Icons.photo), label: const Text('Gallery'))),
                  ],
                ),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
                TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(onPressed: () {
              final newProduct = Product(
                id: isEdit ? product.id : DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                price: double.parse(priceController.text),
                category: categoryController.text,
                description: descriptionController.text,
                image: selectedImagePath ?? '',
                stock: int.parse(stockController.text),
              );
              final provider = Provider.of<ProductProvider>(context, listen: false);
              isEdit ? provider.updateProduct(product.id, newProduct) : provider.addProduct(newProduct);
              Navigator.pop(context);
            }, child: Text(isEdit ? 'Update' : 'Add')),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product, ProductProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Remove ${product.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(onPressed: () { provider.deleteProduct(product.id); Navigator.pop(context); }, child: const Text('Yes', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}