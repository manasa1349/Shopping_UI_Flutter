import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  void add(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (!_items.containsKey(product)) return;
    if (_items[product] == 1) {
      _items.remove(product);
    } else {
      _items[product] = _items[product]! - 1;
    }
    notifyListeners();
  }

  double get total => _items.entries.fold(
    0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );

  int get count => _items.values.fold(0, (sum, qty) => sum + qty);
}
