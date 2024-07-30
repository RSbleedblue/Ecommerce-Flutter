import 'dart:convert';
import 'package:CredexEcom/model/product_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductsLoad {
  static Future<List<Product>> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      final data = json.decode(response) as List;
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('Error loading JSON data: $e');
      return [];
    }
  }
}
