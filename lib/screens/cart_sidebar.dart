import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/screens/checkout_screen.dart';

class CartSidebar extends StatefulWidget {
  const CartSidebar({super.key});

  @override
  State<CartSidebar> createState() => _CartSidebarState();
}

class _CartSidebarState extends State<CartSidebar> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            width: double.infinity,
            child: const Text('Keranjang Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Keranjang Kosong'));
                }
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text(item.variant != null ? 'Varian: ${item.variant!.name}' : ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => cart.updateQuantity(item, item.quantity - 1),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cart.updateQuantity(item, item.quantity + 1),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  children: [
                    if (cart.appliedPromoCode == null)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              decoration: const InputDecoration(
                                hintText: 'Kode Promo',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_promoController.text.isNotEmpty) {
                                bool success = cart.applyPromo(_promoController.text);
                                if (!success) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kode promo tidak valid')));
                                } else {
                                  _promoController.clear();
                                }
                              }
                            },
                            child: const Text('Gunakan'),
                          )
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Promo: ${cart.appliedPromoCode}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red, size: 20),
                            onPressed: () => cart.removePromo(),
                          )
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border(top: BorderSide(color: Colors.grey.shade400)),
                ),
                child: Column(
                  children: [
                    if (cart.discountAmount > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                          Text(currencyFormatter.format(cart.subtotalAmount), style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Diskon:', style: TextStyle(fontSize: 16, color: Colors.green)),
                          Text('- ${currencyFormatter.format(cart.discountAmount)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                        ],
                      ),
                      const Divider(),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(currencyFormatter.format(cart.totalAmount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: cart.items.isEmpty ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                        child: const Text('BAYAR', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
