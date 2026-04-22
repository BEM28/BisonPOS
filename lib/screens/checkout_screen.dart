import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/providers/auth_provider.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'Tunai';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Pembayaran: ${currencyFormatter.format(cart.totalAmount)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('Metode Pembayaran:', style: TextStyle(fontSize: 18)),

            // Using ignored deprecations for compatibility
            // ignore: deprecated_member_use
            RadioListTile<String>(
              title: const Text('Tunai'),
              value: 'Tunai',
              // ignore: deprecated_member_use
              groupValue: _selectedPayment,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _selectedPayment = value!),
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              title: const Text('Kartu Kredit/Debit'),
              value: 'Kartu',
              // ignore: deprecated_member_use
              groupValue: _selectedPayment,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _selectedPayment = value!),
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              title: const Text('E-Wallet (QRIS)'),
              value: 'E-Wallet',
              // ignore: deprecated_member_use
              groupValue: _selectedPayment,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _selectedPayment = value!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _processPayment(context, cart),
                child: const Text('PROSES PEMBAYARAN', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, CartProvider cart) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    orderProvider.placeOrder(
      cart.items,
      cart.totalAmount,
      _selectedPayment,
      cashierId: auth.currentUser?.id ?? '',
    );

    cart.clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Transaksi Berhasil'),
        content: const Text('Pembayaran telah diterima dan stok telah diperbarui.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to POS Home
            },
            child: const Text('KEMBALI KE POS'),
          ),
        ],
      ),
    );
  }
}
