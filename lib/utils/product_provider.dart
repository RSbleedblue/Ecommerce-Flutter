import 'dart:convert';
import 'package:CredexEcom/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String response =
          await rootBundle.loadString('assets/products.json');
      final List<dynamic> jsonData = json.decode(response);

      _allProducts = jsonData.map((item) => Product.fromJson(item)).toList();
      _products = _allProducts;
    } catch (error) {
      _errorMessage = 'Failed to load products: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterProducts({String? category, double? minPrice, double? maxPrice}) {
    List<Product> filteredProducts = _allProducts;
    if (category != null && category.isNotEmpty) {
      category = category.toLowerCase();
      filteredProducts = filteredProducts
          .where((product) => product.category == category)
          .toList();
    }

    if (minPrice != null) {
      filteredProducts =
          filteredProducts.where((product) => product.price! >= minPrice).toList();
    }

    if (maxPrice != null) {
      filteredProducts =
          filteredProducts.where((product) => product.price! <= maxPrice).toList();
    }

    _products = filteredProducts;
    notifyListeners();
  }
}
