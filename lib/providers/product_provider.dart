import 'package:flutter/material.dart';
import 'package:bison_pos/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Nasi Goreng Spesial',
      description: 'Nasi goreng dengan telur, ayam, dan sosis',
      sellPrice: 25000,
      costPrice: 15000,
      category: 'Makanan Utama',
      baseStock: 50,
      variants: [
        ProductVariant(id: 'v1_1', name: 'Biasa', stock: 20),
        ProductVariant(id: 'v1_2', name: 'Pedas', additionalPrice: 2000, stock: 30),
      ],
    ),
    Product(
      id: '2',
      name: 'Es Teh Manis',
      sellPrice: 5000,
      costPrice: 2000,
      category: 'Minuman',
      baseStock: 100,
    ),
    Product(
      id: '3',
      name: 'Mie Goreng Seafood',
      sellPrice: 30000,
      costPrice: 20000,
      category: 'Makanan Utama',
      baseStock: 40,
    )
  ];

  List<Product> get products => _products;

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'Semua');
    return cats;
  }

  void reduceStock(String productId, String? variantId, int quantity) {
    final product = _products.firstWhere((p) => p.id == productId);
    if (product.hasVariants && variantId != null) {
      final variant = product.variants.firstWhere((v) => v.id == variantId);
      variant.stock -= quantity;
    } else {
      product.baseStock -= quantity;
    }
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}
