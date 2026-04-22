import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/providers/order_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    final totalOrders = orderProvider.orders.length;
    final totalRevenue = orderProvider.orders.fold(0.0, (sum, order) => sum + order.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Laporan'),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text('Total Pendapatan', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          Text(currencyFormatter.format(totalRevenue), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.green.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text('Total Transaksi', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          Text('$totalOrders', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Riwayat Transaksi Terbaru', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: orderProvider.orders.isEmpty
                ? const Center(child: Text('Belum ada transaksi.'))
                : ListView.builder(
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      // Reverse order to show newest first
                      final order = orderProvider.orders[orderProvider.orders.length - 1 - index];
                      return Card(
                        child: ListTile(
                          title: Text('Order ID: ${order.id.substring(0, 8)}...'),
                          subtitle: Text('${dateFormatter.format(order.createdAt)} • ${order.paymentMethod}'),
                          trailing: Text(currencyFormatter.format(order.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      );
                    },
                  ),
            )
          ],
        ),
      ),
    );
  }
}
