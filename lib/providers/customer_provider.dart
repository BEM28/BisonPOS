import 'package:flutter/material.dart';

enum MembershipTier { bronze, silver, gold, platinum }

class Customer {
  final String id;
  final String name;
  final String phone;
  int loyaltyPoints;
  MembershipTier tier;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.loyaltyPoints = 0,
    this.tier = MembershipTier.bronze,
  });

  void addPoints(int points) {
    loyaltyPoints += points;
    _updateTier();
  }

  void _updateTier() {
    if (loyaltyPoints >= 10000) {
      tier = MembershipTier.platinum;
    } else if (loyaltyPoints >= 5000) {
      tier = MembershipTier.gold;
    } else if (loyaltyPoints >= 1000) {
      tier = MembershipTier.silver;
    } else {
      tier = MembershipTier.bronze;
    }
  }
}

class CustomerProvider extends ChangeNotifier {
  final List<Customer> _customers = [
    Customer(id: 'c1', name: 'Budi Santoso', phone: '081234567890', loyaltyPoints: 1200, tier: MembershipTier.silver),
    Customer(id: 'c2', name: 'Siti Aminah', phone: '089876543210', loyaltyPoints: 6000, tier: MembershipTier.gold),
  ];

  List<Customer> get customers => _customers;

  void addCustomer(Customer customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void addPointsToCustomer(String customerId, int points) {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      _customers[index].addPoints(points);
      notifyListeners();
    }
  }
}
