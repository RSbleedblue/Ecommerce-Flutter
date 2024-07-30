import 'package:flutter/material.dart';
import 'package:CredexEcom/model/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  double get totalPrice => _items.fold(0.0, (total, item) => total + item.totalPrice);

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void deleteFromCart(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity -= 1;
      } else {
        _items.removeAt(existingItemIndex);
      }
    }
    notifyListeners();
  }

  int get totalProductCount => _items.fold(0, (total, item) => total + item.quantity);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price! * quantity;
}
