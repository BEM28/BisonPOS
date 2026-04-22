import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/providers/order_provider.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Keranjang Anda kosong.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cart.updateQuantity(item, item.quantity - 1),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cart.updateQuantity(item, item.quantity + 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, offset: const Offset(0, -2), blurRadius: 5)
                  ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 18)),
                        Text(currencyFormatter.format(cart.totalAmount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        onPressed: () => _submitOrder(context, cart),
                        child: const Text('KIRIM PESANAN', style: TextStyle(fontSize: 18)),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _submitOrder(BuildContext context, CartProvider cart) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Simulate order submission from customer directly to backend (cashierId is empty)
    orderProvider.placeOrder(cart.items, cart.totalAmount, 'Pending (Pembayaran di Kasir)');

    cart.clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pesanan Diterima!'),
        content: const Text('Pesanan Anda sedang diproses dan telah masuk ke sistem kasir.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to Menu
            },
            child: const Text('KEMBALI KE MENU'),
          ),
        ],
      ),
    );
  }
}
