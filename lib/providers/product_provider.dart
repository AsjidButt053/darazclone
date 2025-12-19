import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

/// Provider for managing products catalog
class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  /// Get list of unique categories
  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  /// Load products from JSON file
  Future<void> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);
      _products = data.map((json) => Product.fromJson(json)).toList();
      _filteredProducts = List.from(_products);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  /// Add a new product (for admin)
  void addProduct(Product product) {
    _products.add(product);
    _applyFilters();
    notifyListeners();
  }

  /// Update an existing product (for admin)
  void updateProduct(String id, Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = updatedProduct;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Delete a product (for admin)
  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    _applyFilters();
    notifyListeners();
  }

  /// Search products by name
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  /// Filter products by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Apply search and category filters
  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _filteredProducts = List.from(_products);
    notifyListeners();
  }
}
