import 'package:flutter/material.dart';

class PurchaseOrder {
  final String id;
  final String supplierName;
  final String productName;
  final int quantity;
  final double totalCost;
  String status; // pending, approved, received

  PurchaseOrder({
    required this.id,
    required this.supplierName,
    required this.productName,
    required this.quantity,
    required this.totalCost,
    this.status = 'pending',
  });
}

class InventoryProvider extends ChangeNotifier {
  final List<PurchaseOrder> _purchaseOrders = [
    PurchaseOrder(id: 'po1', supplierName: 'PT Beras Makmur', productName: 'Beras Premium 50kg', quantity: 10, totalCost: 5000000, status: 'approved'),
    PurchaseOrder(id: 'po2', supplierName: 'CV Teh Manis', productName: 'Daun Teh Kering 10kg', quantity: 5, totalCost: 1500000),
  ];

  List<PurchaseOrder> get purchaseOrders => _purchaseOrders;

  void addPurchaseOrder(PurchaseOrder po) {
    _purchaseOrders.add(po);
    notifyListeners();
  }

  void updatePoStatus(String id, String status) {
    final index = _purchaseOrders.indexWhere((po) => po.id == id);
    if (index != -1) {
      _purchaseOrders[index].status = status;
      notifyListeners();
    }
  }
}
