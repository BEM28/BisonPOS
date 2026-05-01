import 'package:flutter/material.dart';
import 'package:bison_pos/models/order.dart';
import 'package:bison_pos/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;

  List<CartItem> get items => _items;
  String? get appliedPromoCode => _appliedPromoCode;
  double get discountPercentage => _discountPercentage;

  double get subtotalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    return subtotalAmount * _discountPercentage;
  }

  double get totalAmount {
    return subtotalAmount - discountAmount;
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
      if (_items.isEmpty) {
        removePromo();
      }
    } else {
      item.quantity = quantity;
    }
    notifyListeners();
  }

  bool applyPromo(String code) {
    // Mock promo logic
    if (code.toUpperCase() == 'DISKON10') {
      _appliedPromoCode = code.toUpperCase();
      _discountPercentage = 0.10;
      notifyListeners();
      return true;
    } else if (code.toUpperCase() == 'DISKON20') {
      _appliedPromoCode = code.toUpperCase();
      _discountPercentage = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    removePromo();
  }
}
