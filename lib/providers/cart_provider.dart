import 'package:flutter/material.dart';
import 'package:bison_pos/models/order.dart';
import 'package:bison_pos/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product, {ProductVariant? variant, String notes = ''}) {
    // Check if item already exists
    int index = _items.indexWhere((item) => item.product.id == product.id && item.variant?.id == variant?.id);

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, variant: variant, notes: notes));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      _items.remove(item);
    } else {
      item.quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
