import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Provider for managing shopping cart
class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// Get total number of items in cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total price of all items in cart
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Product already in cart, update quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Add new product to cart
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update quantity of a cart item
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// Increase quantity of a cart item
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && _items[index].quantity < 10) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrease quantity of a cart item
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Clear all items from cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Get cart item by product ID
  CartItem? getCartItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
