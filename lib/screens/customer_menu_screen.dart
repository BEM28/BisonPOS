import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/models/product.dart';
import 'package:bison_pos/providers/product_provider.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/screens/customer_cart_screen.dart';

class CustomerMenuScreen extends StatelessWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Restoran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Clear cart when leaving customer mode for demo purposes
            Provider.of<CartProvider>(context, listen: false).clearCart();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // Exclude 'Semua' category
          final categories = provider.categories.where((c) => c != 'Semua').toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryProducts = provider.products.where((p) => p.category == category).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(category, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryProducts.length,
                    itemBuilder: (context, pIndex) {
                      final product = categoryProducts[pIndex];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                        title: Text(product.name),
                        subtitle: Text(currencyFormatter.format(product.sellPrice)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: () {
                            if (product.totalStock > 0) {
                               if (product.hasVariants) {
                                  _showVariantDialog(context, product);
                               } else {
                                  Provider.of<CartProvider>(context, listen: false).addItem(product);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} ditambahkan'), duration: const Duration(seconds: 1)));
                               }
                            } else {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stok habis')));
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerCartScreen()));
            },
            label: Text('${cart.items.length} Item - ${currencyFormatter.format(cart.totalAmount)}'),
            icon: const Icon(Icons.shopping_cart),
          );
        },
      ),
    );
  }

  void _showVariantDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Varian - ${product.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: product.variants.length,
              itemBuilder: (context, index) {
                final variant = product.variants[index];
                return ListTile(
                  title: Text(variant.name),
                  subtitle: variant.stock > 0 ? Text('+ Rp${variant.additionalPrice}') : const Text('Habis', style: TextStyle(color: Colors.red)),
                  onTap: variant.stock > 0 ? () {
                    Provider.of<CartProvider>(context, listen: false).addItem(product, variant: variant);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} (${variant.name}) ditambahkan'), duration: const Duration(seconds: 1)));
                  } : null,
                );
              },
            ),
          ),
        );
      }
    );
  }
}
