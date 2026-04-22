import 'package:flutter/material.dart';
import 'package:bison_pos/models/order.dart';

import 'package:bison_pos/providers/product_provider.dart';
import 'package:uuid/uuid.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final ProductProvider _productProvider;

  OrderProvider(this._productProvider);

  List<Order> get orders => _orders;

  void placeOrder(List<CartItem> items, double totalAmount, String paymentMethod, {String cashierId = ''}) {
    final order = Order(
      id: const Uuid().v4(),
      items: List.from(items), // Make a copy
      createdAt: DateTime.now(),
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      cashierId: cashierId,
    );

    _orders.add(order);

    // Reduce stock
    for (var item in items) {
      _productProvider.reduceStock(item.product.id, item.variant?.id, item.quantity);
    }

    notifyListeners();
  }
}
