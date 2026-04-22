import 'package:bison_pos/models/product.dart';

class CartItem {
  final Product product;
  final ProductVariant? variant;
  int quantity;
  final String notes;

  CartItem({
    required this.product,
    this.variant,
    this.quantity = 1,
    this.notes = '',
  });

  double get unitPrice => product.sellPrice + (variant?.additionalPrice ?? 0);
  double get totalPrice => unitPrice * quantity;
}

enum OrderStatus { pending, completed, cancelled }

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final double totalAmount;
  final String paymentMethod;
  final OrderStatus status;
  final String cashierId; // Empty if it's a customer order

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.totalAmount,
    required this.paymentMethod,
    this.status = OrderStatus.completed,
    this.cashierId = '',
  });
}
