class ProductVariant {
  final String id;
  final String name; // e.g. "Small", "Spicy"
  final double additionalPrice;
  int stock;

  ProductVariant({
    required this.id,
    required this.name,
    this.additionalPrice = 0.0,
    required this.stock,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final double sellPrice;
  final double costPrice;
  final String category;
  final String imageUrl;
  int baseStock;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.sellPrice,
    required this.costPrice,
    required this.category,
    this.imageUrl = '',
    this.baseStock = 0,
    this.variants = const [],
  });

  bool get hasVariants => variants.isNotEmpty;

  int get totalStock {
    if (hasVariants) {
      return variants.fold(0, (sum, variant) => sum + variant.stock);
    }
    return baseStock;
  }
}
